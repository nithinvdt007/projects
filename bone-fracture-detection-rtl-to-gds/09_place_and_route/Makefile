PROJECT_ROOT := $(abspath ..)
PYTHON ?= python
PDK_ROOT ?= $(shell find $(HOME)/.ciel -path "*/sky130A/libs.tech/netgen/sky130A_setup.tcl" -print -quit 2>/dev/null | sed 's#/sky130A/libs.tech/netgen/sky130A_setup.tcl##')
export PDK_ROOT
.PHONY: all cts route clean
all: route
cts:
	cd "$(PROJECT_ROOT)" && igny run openroad -exit 09_place_and_route/openroad_cts.tcl
route: cts
	cd "$(PROJECT_ROOT)" && igny run openroad -exit 09_place_and_route/openroad_route.tcl
clean:
	rm -f "$(PROJECT_ROOT)/09_place_and_route/cts.def" "$(PROJECT_ROOT)/09_place_and_route/cts.odb" "$(PROJECT_ROOT)/09_place_and_route/route.def" "$(PROJECT_ROOT)/09_place_and_route/route.odb" "$(PROJECT_ROOT)/09_place_and_route/route.spef" "$(PROJECT_ROOT)/09_place_and_route/route.guide" "$(PROJECT_ROOT)/09_place_and_route/route_output.v" "$(PROJECT_ROOT)/09_place_and_route/route_drc.rpt"
