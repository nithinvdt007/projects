PROJECT_ROOT := $(abspath ..)
PYTHON ?= python
.PHONY: all sta sta-tt sta-ss corners clean
all: corners
sta: sta-tt
sta-tt:
	cd "$(PROJECT_ROOT)" && igny run openroad -exit 08_sta/openroad_sta.tcl
sta-ss:
	cd "$(PROJECT_ROOT)" && igny run openroad -exit 08_sta/openroad_sta.tcl
corners: sta-tt sta-ss
clean:
	rm -f "$(PROJECT_ROOT)/08_sta/timing_report.txt" "$(PROJECT_ROOT)/08_sta/timing_report_tt.txt" "$(PROJECT_ROOT)/08_sta/timing_report_ss.txt"
