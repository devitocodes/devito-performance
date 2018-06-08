#! /usr/bin/bash
set -x

if [ ! -e $YASK_HOME ]; then
    exit 1
fi

for be in core yask; do
for prob in acoustic tti; do

if [[ $prob == tti && $be == core ]]; then
    bms='O3 dse'
else
    bms='O2'
fi

for bm in $bms; do
for sz in `seq 512 256 1024`; do
for so in `seq 4 4 16`; do

dir=devito.bench.`date +%Y-%m-%d`/$prob/$be/bm$bm/`hostname`/grid$sz/so$so
mkdir -p $dir

log=$dir/run.log
rm -f $log
touch $log
date >> $log
uname -a >> $log
lscpu >> $log
icpc -v 2>&1 >> $log
uname -a >> $log
numactl -H >> $log
numastat -m >> $log
top -b -n 1 | head -30 >> $log

szadj=0
if [[ $be == yask ]]; then
  szadj=20
fi
sz2=$(( $sz - $szadj ))

if [[ `hostname | grep -c skl` > 0 ]]; then
  plat="DEVITO_PLATFORM=skx DEVITO_ISA=avx512"
  nc="numactl --cpubind=1"
else
  plat="DEVITO_PLATFORM=knl DEVITO_ISA=avx512"
  nc="numactl --preferred=1"
fi
nruns=3

cmd="env $plat DEVITO_DEBUG_COMPILER=1 DEVITO_DLE_OPTIONS=blockinner:True DEVITO_AUTOTUNING=aggressive DEVITO_BACKEND=$be DEVITO_OPENMP=1 DEVITO_ARCH=intel DEVITO_LOGGING=DEBUG DEVITO_YASK_AUTOTUNING=preemptive DEVITO_YASK_DUMP=$dir $nc python examples/seismic/benchmark.py bench -bm $bm -P $prob -so $so -to 2 -d $sz2 $sz2 $sz2 --tn 1000 -x $nruns -r $dir"
echo $cmd >> $log
$cmd |& tee -a $log
date >> $log

done
done
done
done
done
