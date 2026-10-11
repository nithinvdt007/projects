# Crucible QoR Summary

These values were recorded from the Crucible implementation report and are preserved as a reference snapshot.

| Metric | Reported value | Notes |
|---|---:|---|
| Synthesized cell count | 5,906 | Synthesis snapshot |
| Cell area | 98,424 µm² | Reported area; 71.7% sequential |
| Core area | 128,175 µm² | Reported physical-design snapshot |
| Core utilization | 77.7% | Reported physical-design snapshot |
| Instances including taps/endcaps | 6,072 | Physical-design snapshot |
| I/O pins | 177 | Design snapshot |
| HPWL after global placement | 125,148 µm | Estimated half-perimeter wire length |
| HPWL after legalization | 168,997 µm | Approximately +35% versus global placement |
| Average / maximum displacement | 4.6 µm / 49.6 µm | Placement report |
| HPWL after CTS | 181,751 µm | Approximately +2% versus legalized placement |
| Setup WNS / TNS | 0.00 ns / 0.00 ns | STA SS-corner report snapshot |
| Worst max / min slack | 0.69 ns / 0.84 ns | STA SS-corner report snapshot; interpret according to report definitions |

## Interpretation limits

- WNS/TNS of 0.00 ns indicates no negative setup slack was reported in that snapshot; it does not by itself prove routing is DRC-clean or that every signoff check passed.
- HPWL is an estimate based on placement/routing geometry, not a substitute for extracted routed parasitics.
- These figures should only be compared with a non-Crucible run when the RTL, constraints, PDK/library versions, tool versions, and stage endpoints are comparable.
- Runtime figures are intentionally omitted here because the complete runtime log has not been independently reconciled for this summary.
