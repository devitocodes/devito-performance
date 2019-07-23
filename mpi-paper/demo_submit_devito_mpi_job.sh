#!/bin/bash
# Job name
#PBS -N demo_mpi_devito_job
# Time required in hh:mm:ss
#PBS -l walltime=00:59:00
# Resource requirements
#PBS -lselect=1:ncpus=24:mem=46gb:mpiprocs=24:ompthreads=1
# Files to contain standard error and standard output

echo Working Directory is $PBS_O_WORKDIR
cd $PBS_O_WORKDIR

echo -ne Loading required modules...
module load intel-suite/2017
icc --version
module load mpi
mpicc -v
echo ...DONE

cd $HOME/opesci/
module load anaconda3/personal

source activate devito
export DEVITO_HOME=`pwd`/devito
cd devito/benchmarks/user/

# Start time
echo Start time is `date` > date

# Set env variables
export DEVITO_ARCH=intel
export DEVITO_OPENMP=0
export DEVITO_MPI=1
export DEVITO_LOGGING=DEBUG
export DEVITO_DEBUG_COMPILER=1
# Experiment
numactl --cpubind=0 --membind=0 mpiexec python benchmark.py bench -P acoustic -bm O2 -d 50 50 50 -so 12 -a --tn 60 --arch intel
# End time
echo End time is `date` >> date
