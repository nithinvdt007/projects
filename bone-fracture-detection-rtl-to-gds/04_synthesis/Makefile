PROJECT_ROOT := $(abspath ..)
PDK_ROOT ?= $(shell find $(HOME)/.ciel -path "*/sky130A/libs.tech/netgen/sky130A_setup.tcl" -print -quit 2>/dev/null | sed 's#/sky130A/libs.tech/netgen/sky130A_setup.tcl##')
export PDK_ROOT

.PHONY: all synth sdc clean
all: synth sdc
synth:
	cd "$(PROJECT_ROOT)" && igny run yosys -s 04_synthesis/synth.tcl
sdc: synth
	cd "$(PROJECT_ROOT)" && igny run yosys -c 04_synthesis/gen_sdc.tcl
clean:
	rm -f "$(PROJECT_ROOT)/04_synthesis/_in.txt" "$(PROJECT_ROOT)/04_synthesis/_out.txt" "$(PROJECT_ROOT)/04_synthesis/synth_output.v" "$(PROJECT_ROOT)/04_synthesis/constraints.sdc"
