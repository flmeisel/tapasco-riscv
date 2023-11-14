#!/bin/bash
set -e

BRAM_SIZE="${BRAM_SIZE:-0x10000}"

cd riscv/naxriscvsmall || :

git clone https://github.com/SpinalHDL/NaxRiscv || [ -d NaxRiscv ]
pushd NaxRiscv
git checkout 6d1d48379609c5a390f8f4f02527282b21b311b6
git apply --reverse --check ../naxriscv-patch.diff 2> /dev/null || git apply ../naxriscv-patch.diff
popd

git clone https://github.com/SpinalHDL/SpinalHDL.git || [ -d SpinalHDL ]
pushd SpinalHDL
git checkout 912f4b37239e97f83e940b718d85e34d553092ad
popd

git clone https://github.com/litex-hub/pythondata-cpu-naxriscv || [ -d pythondata-cpu-naxriscv ]
pushd pythondata-cpu-naxriscv
git checkout 64b2fc1988b223f0ea6aa964201cd9da81ac0d14 #2023.04
git apply --reverse --check ../pythondata-patch.diff 2> /dev/null || git apply ../pythondata-patch.diff
popd


cd NaxRiscv
sbt "runMain naxriscv.platform.LitexGen --memory-region=$((0x11000000)),$((0x10000)),io,p --memory-region=$((0x00000000)),$(($BRAM_SIZE)),xc,m --memory-region=$(($BRAM_SIZE)),$(($BRAM_SIZE)),rwc,m --reset-vector=0 --scala-args=alu-count=1,decode-count=1 --xlen=32 --ram-data-width=32 --io-data-width=32 --scala-file=../pythondata-cpu-naxriscv/pythondata_cpu_naxriscv/verilog/configs/gen.scala --netlist-name=NaxTapascoRiscvSmall"
cd ..

mkdir -p ../../IP/riscv/NaxRiscvSmall
cp NaxRiscv/NaxTapascoRiscvSmall.v ../../IP/riscv/NaxRiscvSmall
cp pythondata-cpu-naxriscv/pythondata_cpu_naxriscv/verilog/Ram_1w_1rs_Generic.v ../../IP/riscv/NaxRiscvSmall

# cd to tapasco-riscv
cd ../..

vivado -nolog -nojournal -mode batch -source riscv/naxriscvsmall/naxriscv_ip.tcl -tclargs $(pwd)/IP/riscv/NaxRiscvSmall NaxTapascoRiscvSmall

