
# envDir=/homes/yuhengy/3-PrjTimingTaint2/Compass/env
envDir=$(dirname -- "$(readlink -f -- "$BASH_SOURCE")")
cd $envDir




## STEP: conda
wget https://repo.anaconda.com/miniconda/Miniconda3-py39_24.5.0-0-Linux-x86_64.sh
bash Miniconda3-py39_24.5.0-0-Linux-x86_64.sh -b -p $envDir/conda
rm Miniconda3-py39_24.5.0-0-Linux-x86_64.sh
source $envDir/conda/etc/profile.d/conda.sh




## STEP: chipyard
conda install -y -n base python=3.9.19 conda-lock=1.4
conda activate base
git clone --depth 1 -b 1.11.0 https://github.com/ucb-bar/chipyard.git
cd chipyard && ./build-setup.sh riscv-tools -s 6 -s 7 -s 8 -s 9 && cd ..
source $envDir/chipyard/env.sh




## STEP: circt
## STEP.1: cmake
wget https://github.com/Kitware/CMake/releases/download/v3.29.0/cmake-3.29.0-linux-x86_64.sh
mkdir cmake
bash cmake-3.29.0-linux-x86_64.sh --prefix=$envDir/cmake --skip-license
rm cmake-3.29.0-linux-x86_64.sh
export PATH=$envDir/cmake/bin:$PATH

## STEP.2: ninja
mkdir -p ninja/bin && cd ninja/bin
wget https://github.com/ninja-build/ninja/releases/download/v1.11.1/ninja-linux.zip
unzip ninja-linux.zip
rm ninja-linux.zip
cd ../..
export PATH=$envDir/ninja/bin:$PATH

## STEP.3: cache
wget https://github.com/ccache/ccache/releases/download/v4.12.3/ccache-4.12.3-linux-x86_64.tar.xz
mkdir -p ccache/bin
tar -xf ccache-4.12.3-linux-x86_64.tar.xz -C ccache/bin --strip-components=1
rm ccache-4.12.3-linux-x86_64.tar.xz
export PATH=$envDir/ccache/bin:$PATH

## STEP.4: circt
git clone --depth 1 https://github.com/MATCHA-MIT/Compass-circt.git
cd Compass-circt && git submodule update --init --depth 1
cmake -S llvm/llvm -B build -G Ninja \
  -DCMAKE_BUILD_TYPE=Release \
  -DLLVM_ENABLE_PROJECTS=mlir \
  -DLLVM_ENABLE_ASSERTIONS=ON \
  -DLLVM_BUILD_EXAMPLES=OFF \
  -DLLVM_ENABLE_OCAMLDOC=OFF \
  -DLLVM_ENABLE_BINDINGS=OFF \
  -DLLVM_BUILD_TOOLS=ON \
  -DLLVM_OPTIMIZED_TABLEGEN=ON \
  -DLLVM_INCLUDE_TOOLS=ON \
  -DLLVM_USE_SPLIT_DWARF=ON \
  -DLLVM_BUILD_LLVM_DYLIB=ON \
  -DLLVM_LINK_LLVM_DYLIB=ON \
  -DLLVM_CCACHE_BUILD=ON \
  -DLLVM_EXTERNAL_PROJECTS=circt \
  -DLLVM_EXTERNAL_CIRCT_SOURCE_DIR=$PWD
ninja -C build bin/firtool
cd ..
export PATH=$envDir/Compass-circt/build/bin:$PATH

