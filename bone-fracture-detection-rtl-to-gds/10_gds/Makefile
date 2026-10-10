PROJECT_ROOT := $(abspath ..)
.PHONY: all gds clean
all: gds
gds:
	cd "$(PROJECT_ROOT)" && bash 10_gds/run_gds_streamout.sh
clean:
	rm -f "$(PROJECT_ROOT)/10_gds/top_level_final_decision.gds"
