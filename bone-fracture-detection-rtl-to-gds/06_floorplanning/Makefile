PROJECT_ROOT := $(abspath ..)
PDK_ROOT ?= $(shell find $(HOME)/.ciel -path "*/sky130A/libs.tech/netgen/sky130A_setup.tcl" -print -quit 2>/dev/null | sed 's#/sky130A/libs.tech/netgen/sky130A_setup.tcl##')
export PDK_ROOT
.PHONY: all floorplan clean
all: floorplan
floorplan:
	cd "$(PROJECT_ROOT)" && igny run openroad -exit 06_floorplanning/openroad_floorplan.tcl
clean:
	rm -f "$(PROJECT_ROOT)/06_floorplanning/floorplan.def" "$(PROJECT_ROOT)/06_floorplanning/floorplan.odb"
