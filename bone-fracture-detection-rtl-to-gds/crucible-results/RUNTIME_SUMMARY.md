# Crucible Runtime and Peak Memory

These values are transcribed from the uploaded Crucible execution log `Pasted text(20261011-040930).txt`. They are **stage wall-clock durations**, not necessarily the time spent exclusively inside the EDA engine.

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

**Sum of seven recorded stage wall times:** 2212.55 s (**36 min 52.55 s**).

**Highest reported stage peak memory:** 879,348 KB (routing; about **859 MiB** if KB is interpreted as KiB).

## Caveats

- The log contains a GDS stream-out start, but the provided portion does **not** contain a verified `gds: ... s wall, ... KB peak` completion line. GDS runtime is therefore not included in the total.
- The sum above excludes unreported orchestration overhead and any unrecorded stages; it is not an independently timed end-to-end run.
- Routing dominates elapsed time. The log reports routing completion and extraction, but DRC/signoff status must be checked separately.
- For a fair comparison with the standalone (non-Crucible) run, use identical RTL, PDK, constraints, tool versions, machine resources and stage boundaries. Record wall time and peak RSS using the same measurement method.
