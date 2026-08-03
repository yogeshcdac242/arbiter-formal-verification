# Round-Robin Arbiter Formal Verification

This repository contains the RTL design and formal verification environment for a 4-input Round-Robin Arbiter. It demonstrates advanced Formal Verification methodologies using Cadence JasperGold, specifically focusing on liveness properties, fairness, and environmental constraints.

## Project Structure
- `arbiter.sv`: The SystemVerilog RTL design of the Round-Robin Arbiter.
- `arbiter_props.sv`: The SystemVerilog Assertions (SVA) containing the formal properties (`assert`) and environmental constraints (`assume`).
- `run_jg.tcl`: A TCL script to load the design and execute the formal proofs in JasperGold.
- `Makefile`: A standard EDA Makefile for automated execution in batch or GUI mode.

## What is Verified?

This project uses Formal Verification to mathematically prove that the arbiter operates flawlessly and fairly under all possible legal request combinations.

### 1. Mutual Exclusion
- **Property:** `assert_mutual_exclusion`
- **Description:** Proves that it is mathematically impossible for more than one agent to receive a grant at the exact same time. It utilizes the SVA `$onehot0` system function.

### 2. Spurious Grants & Work Conservation
- **Property:** `assert_no_spurious_gnt_*`
- **Description:** Proves that a grant is *never* given to an agent that did not actively request it.
- **Property:** `assert_work_conservation`
- **Description:** Proves that the arbiter never sits idle; if there is at least one active request, the arbiter *must* issue a grant in that exact same clock cycle.

### 3. Fairness and Starvation Prevention (Liveness)
- **Property:** `assert_fairness_0` (using unbounded delay `##[0:$]`)
- **Description:** Proves that the Round-Robin logic is fair. If an agent requests access, it is guaranteed to *eventually* receive a grant, preventing starvation.

### 4. Environmental Constraints (The Handshake)
- **Property:** `assume_hold_req_*`
- **Description:** During the verification of the liveness property, the formal engine initially found a false counter-example by dropping a request before a grant was issued. To accurately model real-world bus protocols (like APB/AXI), environmental assumptions were added to force the formal tool to hold a request high until a grant is received.

## How to Run

1. Ensure Cadence JasperGold is available in your environment (`xcelium` tools loaded).
2. Clone this repository and navigate to the directory.
3. You can run the formal proofs in two ways using the provided Makefile:

**Batch Mode (Silent execution in terminal):**
```bash
make jg_batch
```

**GUI Mode (Interactive visualization):**
```bash
make jg_gui
```
