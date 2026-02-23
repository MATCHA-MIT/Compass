
envDir=$(dirname -- "$(readlink -f -- "$BASH_SOURCE")")


## STEP: conda
source $envDir/conda/etc/profile.d/conda.sh


## STEP: chipyard
source $envDir/chipyard/env.sh


## STEP: circt
export PATH=$envDir/Compass-circt/build/bin:$PATH

