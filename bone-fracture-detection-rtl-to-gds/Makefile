PROJECT_ROOT := $(abspath .)
.PHONY: all lint synth floorplan place cts route sta gds clean
all: lint synth floorplan place cts route sta gds
lint:
	$(MAKE) -C 00_lint
synth:
	$(MAKE) -C 04_synthesis
floorplan:
	$(MAKE) -C 06_floorplanning floorplan
place:
	$(MAKE) -C 07_placement place
cts:
	$(MAKE) -C 09_place_and_route cts
route:
	$(MAKE) -C 09_place_and_route route
sta:
	$(MAKE) -C 08_sta corners
gds:
	$(MAKE) -C 10_gds gds
clean:
	$(MAKE) -C 00_lint clean
	$(MAKE) -C 04_synthesis clean
	$(MAKE) -C 06_floorplanning clean
	$(MAKE) -C 07_placement clean
	$(MAKE) -C 09_place_and_route clean
	$(MAKE) -C 08_sta clean
	$(MAKE) -C 10_gds clean
