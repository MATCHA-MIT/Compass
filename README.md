
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

#### Generate taint logic based on user annotation for sodor

```
python3 src/sodor2/scripts/genTaintLogic.py
```

- User annotation is provided through `iftConfig()` function calls in the `src/sodor2/generators` folder
- Taint logic is generated in the `src/sodor2/verilog_taint` folder


#### More Content (e.g., CEGAR loop, rocket and boom processors) Will Be Added to This Repo through March 2026.

