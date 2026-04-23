
# Compass

This repository provides the Compass framework presented in our ASPLOS 2026 paper, [Compass: Navigating the Design Space of Taint Schemes for RTL Security Verification](https://people.csail.mit.edu/mengjia/data/2026.ASPLOS.Compass.pdf).


## Environment Setup

#### Provided Scripts

The framework uses [chipyard](https://github.com/ucb-bar/chipyard) to generate source code of processors, and use our fork of [circt](https://github.com/MATCHA-MIT/Compass-circt) to generate their taint logic.
These dependencies can be installed in the `env` folder on your machine using:

```bash
bash env/install.sh
```

Each time you want to activate these dependencies, i.e., setting up the environment variables such as PATH, run:

```bash
source env/setup.sh
```


#### Additional JasperGold Requirement

The generated taint logic is sent to model checkers to formally verify security properties.
We currently use a commercial software, JasperGold, and assume version 2024.06 is avaliable through `jg` command.


## Running Example

#### Generate taint logic for sodor

1. Set `CONFIG` in `src/sodor2/scripts/param.py` to either `MySodor2StageNaiveConfig`, `MySodor2StageAutoSandboxConfig`, or `MySodor2StageCelliftConfig`.
They correspond to naive taint logic, taint logic from user annotation, and cellIFT.

2. User annotation is provided through `iftConfig()` function calls in the `src/sodor2/generators` folder

3. Run:

```
python3 src/sodor2/scripts/genTaintLogic.py
```

4. Taint logic is generated in the `src/sodor2/verilog_taint` folder


#### Verify sandbox contract using taint logic / self-composition

1. Set `TCL_PATH` in `src/sodor2/scripts/param.py` to either `src/sodor2/veri/1taint_sandbox.tcl` or `src/sodor2/veri/2original_sandbox.tcl`.

2. For taint logic case, run:

```
python3 src/sodor2/ISATaint/scripts/chisel_run.py
```

3. Run:

```
python3 src/sodor2/scripts/jg_run.py
```

4. Results, i.e., Jaspergold folder, is in `src/sodor2/veri`.


#### Run CEGAR loop

1. In `src/sodor2/scripts/param.py`, set `CONFIG` to `MySodor2StageAutoSandboxConfig`, and set `TCL_PATH` to `src/sodor2/veri/1taint_sandbox.tcl`.

2. Reset taint logic to the initial one by removing all `iftConfig()` function calls in the `src/sodor2/generators` folder under `markFor=="auto_sandbox"` condition.

3. Generate taint logic with:

```
python3 src/sodor2/scripts/genTaintLogic.py
```

4. Try to prove the property with:

```
python3 src/sodor2/scripts/jg_run.py
```

5. If it is proven, we are done. Otherwise, identify refinement location with:

```
python3 src/sodor2/scripts/refine.py
```

6. Add `iftConfig()` function calls in the `src/sodor2/generators` to refine taint logic.

7. Try to check whether the counterexample is eliminated with:

```
python3 src/sodor2/scripts/refineForSameCex.py
```

8. If eliminated, go back to step 4. Otherwise, go back to step 6.


#### More Content (e.g., rocket and boom processors) Will Be Added to This Repo through March 2026.

