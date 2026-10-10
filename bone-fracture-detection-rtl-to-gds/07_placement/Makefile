PROJECT_ROOT := $(abspath ..)
PDK_ROOT ?= $(shell find $(HOME)/.ciel -path "*/sky130A/libs.tech/netgen/sky130A_setup.tcl" -print -quit 2>/dev/null | sed 's#/sky130A/libs.tech/netgen/sky130A_setup.tcl##')
export PDK_ROOT
.PHONY: all place clean
all: place
place:
	@if [ ! -f "$(PROJECT_ROOT)/06_floorplanning/floorplan.odb" ]; then $(MAKE) -C "$(PROJECT_ROOT)/06_floorplanning" floorplan; fi
	cd "$(PROJECT_ROOT)" && igny run openroad -exit 07_placement/openroad_placement.tcl
clean:
	rm -f "$(PROJECT_ROOT)/07_placement/placement.def" "$(PROJECT_ROOT)/07_placement/placement.odb"
