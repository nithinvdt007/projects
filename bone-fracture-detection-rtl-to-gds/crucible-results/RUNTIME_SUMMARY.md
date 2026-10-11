# RTL-to-GDS Runtime and Peak Memory

## Crucible run

These values are transcribed from the Crucible execution log `Pasted text(20261011-040930).txt`. They are stage wall-clock durations, not necessarily time spent exclusively inside the EDA engine.

| Stage | Wall time (s) | Wall time | Peak memory (KB) |
|---|---:|---:|---:|
| Lint | 3.54 | 00:00:03.54 | 53,912 |
| Synthesis | 11.97 | 00:00:11.97 | 78,460 |
| Floorplanning | 3.41 | 00:00:03.41 | 152,400 |
| Placement | 8.72 | 00:00:08.72 | 168,396 |
| CTS | 7.44 | 00:00:07.44 | 172,456 |
| Routing | 2169.54 | 00:36:09.54 | 879,348 |
| STA | 7.93 | 00:00:07.93 | 188,040 |
| GDS stream-out | Not established | — | — |

**Sum of seven recorded Crucible stage times:** 2212.55 s (**36 min 52.55 s**).

**Highest reported Crucible stage peak memory:** 879,348 KB (about 859 MiB if KB is interpreted as KiB).

## Standalone (direct executable) run

The user-provided standalone OpenROAD routing log reports:

| Stage | OpenROAD reported runtime | Peak memory |
|---|---:|---|
| Detailed routing + post-processing | 2404.83 s (**40 min 4.83 s**) | Not supplied in the pasted excerpt |

The standalone run generated `route.def`, `route.odb`, `route.spef`, `route_output.v`, and `route_drc.rpt`. The command's final shell exit status was not visible in the provided excerpt, and the DRC report has not yet been inspected. This is therefore recorded as routing completion in the log, not as proof of a DRC-clean design.

The standalone routing runtime is **235.29 s (3 min 55.29 s) longer**, approximately **10.8% longer** than the Crucible routing wall time (2169.54 s). This is a preliminary comparison: verify that the runs used equivalent inputs, tool builds, constraints, machine conditions, and stage boundaries before attributing the difference to Crucible.

## Caveats

- The Crucible log contains a GDS stream-out start, but no verified completed `gds: ... s wall, ... KB peak` line in the available extract. GDS runtime is not included in its total.
- The Crucible sum excludes unreported orchestration overhead and any unrecorded stages; it is not an independently timed end-to-end run.
- Standalone runtimes for lint, synthesis, floorplanning, placement, CTS, STA, and GDS are not yet captured consistently, so a full end-to-end comparison cannot yet be calculated.
- Routing completion does not imply zero DRC violations or signoff success. Inspect `route_drc.rpt` and physical-verification results.
- For a fair comparison, use identical RTL, PDK/library versions, constraints, tool versions, machine resources, and measurement methods.
