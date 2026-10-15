# Paper-derived simulation results (non-Crucible)

## Source and scope

Extracted from the supplied `research_paper.pdf`, “Design and VLSI Implementation of a Decision-Making System for Bone Fracture Detection,” principally its Results and Discussion section. These are results reported by the paper’s authors, not measurements from the Crucible SKY130 implementation in this repository.

The paper describes a rule-based RTL architecture evaluated using MATLAB reference simulations, RTL simulation, and real leg X-ray test cases. It reports the ASIC study in a separate 90 nm CMOS/Cadence flow. Those implementation PPA numbers are intentionally excluded here because this note records simulation results only.

## MATLAB functional simulations

The paper reports two representative image examples:

| Input case | Cluster score | Corner score | Chaos score | Brightness score | Rules voted | Classification |
|---|---:|---:|---:|---:|---:|---|
| Fractured bone | 120 | 39 | 99 | 5,930,506 | 4 of 5 | Fractured |
| Normal bone | 24 | 27 | 29 | 12,296,740 | 2 of 5 | Not fractured |

In the reported fractured example, the cluster and chaos scores increase around the fracture region and four of five rule conditions vote for fracture. In the normal example, only two rules vote for fracture, below the paper’s decision threshold.

## RTL simulation

The paper describes RTL simulation of the datapath and control logic before synthesis. Its waveform is used to check pixel streaming, accumulation of cluster/corner/chaos/brightness-related counters, frame-end voting, the final diagnosis output, and the output-valid pulse. The paper reports deterministic operation and a correct final decision for its representative simulated case.

## Dataset accuracy

Across the evaluated real leg X-ray test cases, the paper reports approximately **85% overall classification accuracy**. The paper does not provide the dataset size or class-by-class confusion matrix in the cited results text, so sensitivity, specificity, and confidence intervals cannot be derived from this accuracy figure alone.

## Attribution and comparison limits

- Source: supplied research paper, “Design and VLSI Implementation of a Decision-Making System for Bone Fracture Detection,” Results and Discussion (MATLAB validation, RTL simulation, case studies, and overall accuracy).
- These reported outcomes are paper-level reference results; this repository does not include the paper’s test dataset or enough testbench details to independently reproduce them.
- Keep these results separate from [Crucible QoR](QOR_SUMMARY.md) and the completed [SKY130 chip-I/O QoR](QOR_CHIP_IO.md). Their technologies, tools, and evaluation endpoints differ.
- This is a research/educational prototype, not a clinically validated diagnostic product.
