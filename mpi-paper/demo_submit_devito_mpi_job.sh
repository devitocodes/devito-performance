#!/bin/bash
# Job name
#PBS -N results_mpi_devito_job
# Time required in hh:mm:ss
#PBS -l walltime=00:15:00
# Resource requirements
#PBS -lselect=1:ncpus=24:mem=120gb:mpiprocs=12:ompthreads=2
# Files to contain standard error and standard output

lscpu

cd $PBS_O_WORKDIR

echo -ne Loading required modules...
module load anaconda3/personal
module load intel-suite/2017
icc --version
module load mpi
mpicc -v
echo ...DONE


source activate devito
#conda install mpi4py
python print_mpi4py_conf.py

cd $HOME/opesci/
module load anaconda3/personal

export DEVITO_HOME=`pwd`/devito
cd devito/benchmarks/user/

# Start time
echo Start time is `date`

# Set env variables
export DEVITO_ARCH=intel
export DEVITO_OPENMP=1
export DEVITO_MPI=1
export DEVITO_LOGGING=DEBUG
export DEVITO_DEBUG_COMPILER=1
# Experiment
mpiexec -genv I_MPI_DEBUG=40 python benchmark.py bench -P acoustic -bm O2 -d 768 768 768 -so 12 --tn 100 --arch intel

# End time
echo End time is `date`
