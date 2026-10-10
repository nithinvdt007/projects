PROJECT_ROOT := $(abspath ..)
.PHONY: all lint clean
all: lint
lint:
	cd "$(PROJECT_ROOT)" && igny run verilator --lint-only -Wall -Wno-fatal --top-module top_level_final_decision 01_rtl/bone_fracture_top_combined.v
clean:
	@echo "Verilator lint does not leave a build output in this stage."
