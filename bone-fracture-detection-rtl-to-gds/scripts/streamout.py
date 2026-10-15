#!/usr/bin/env python3
import os,sys,json
from pathlib import Path
import klayout.db as k
root=Path(__file__).resolve().parent.parent
pdk=Path(os.environ['PDK_ROOT']);mode=sys.argv[1]
if mode not in ('preview','detailed'):raise SystemExit('Use preview or detailed')
refs=pdk/'libs.ref'
lefs=[refs/'sky130_fd_sc_hd/techlef/sky130_fd_sc_hd__nom.tlef',refs/'sky130_fd_sc_hd/lef/sky130_fd_sc_hd.lef',refs/'sky130_fd_io/lef/sky130_ef_io.lef',refs/'sky130_sram_macros/lef/sky130_sram_1kbyte_1rw1r_8x1024_8.lef']
gds=[refs/'sky130_fd_sc_hd/gds/sky130_fd_sc_hd.gds',refs/'sky130_fd_io/gds/sky130_fd_io.gds',refs/'sky130_fd_io/gds/sky130_ef_io__gpiov2_pad_wrapped.gds',refs/'sky130_fd_io/gds/sky130_ef_io.gds',refs/'sky130_sram_macros/gds/sky130_sram_1kbyte_1rw1r_8x1024_8.gds',refs/'sky130_fd_pr/gds/sky130_fd_pr.gds']
for f in lefs+gds:
 if not f.is_file():raise SystemExit('Missing '+str(f))
library=k.Layout()
for f in gds: library.read(str(f))
config=k.LEFDEFReaderConfiguration();config.macro_resolution_mode=2;config.macro_layouts=[library];config.lef_files=[str(x) for x in lefs];config.map_file=str(root/'12_chip_physical/config/sky130_layermap.txt');config.dbu=0.001
options=k.LoadLayoutOptions();options.lefdef_config=config
layout=k.Layout();input_def=root/'12_chip_physical/results'/('chip_global_route.def' if mode=='preview' else 'chip_detailed_route.def');layout.read(str(input_def),options)
top=layout.cell('chip_io_wrapper')
if top is None:raise SystemExit('Missing top cell')
reachable=set(top.called_cells())|{top.cell_index()}
empty=[layout.cell(i).name for i in reachable if layout.cell(i).is_empty()]
source_empty={'sky130_fd_pr__gendlring__example_559591418081','genDLring_CDNS_5246887918517'}
if set(empty)-source_empty:raise SystemExit('Missing physical cell geometry: '+','.join(empty))
print('PDK source itself has these empty cells; not fabricated or repaired:',empty)
output=root/'12_chip_physical/results'/('chip_global_route_preview.gds' if mode=='preview' else 'chip_detailed_route.gds')
save=k.SaveLayoutOptions();save.select_cell(top.cell_index());layout.write(str(output),save);check=k.Layout();check.read(str(output));top=check.cell('chip_io_wrapper')
report={'stage':mode,'not_signoff':True,'dbu_um':check.dbu,'top':top.name,'bbox_um':str(top.dbbox()),'cells':check.cells(),'top_instances':sum(1 for _ in top.each_inst()),'pads':[],'srams':[],'empty_cells':[check.cell(i).name for i in set(top.called_cells())|{top.cell_index()} if check.cell(i).is_empty()],'gds':output.name}
for i in top.each_inst():
 name=i.cell.name
 if 'gpiov2_pad_wrapped' in name:report['pads'].append({'master':name,'bbox_um':str(i.dbbox()),'transform':str(i.dcplx_trans)})
 if name=='sky130_sram_1kbyte_1rw1r_8x1024_8':report['srams'].append({'master':name,'bbox_um':str(i.dbbox()),'transform':str(i.dcplx_trans)})
(root/'12_chip_physical/reports'/('gds-'+mode+'-inspection.json')).write_text(json.dumps(report,indent=2));print(json.dumps(report,indent=2))

