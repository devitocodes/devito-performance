#!/bin/bash
# Job name
#PBS -N fix_bench_mpi_test_devito_benchmarking
# Time required in hh:mm:ss
#PBS -l walltime=00:40:00
# Resource requirements
#PBS -lselect=1:ncpus=24:mem=46gb:mpiprocs=24:ompthreads=1
# Files to contain standard error and standard output
##PBS -o stdout
##PBS -e stderr
## Mail notification
#PBS -m bea
#PBS -M g.bisbas18@imperial.ac.uk

echo Working Directory is $PBS_O_WORKDIR
cd $PBS_O_WORKDIR
rm -f stdout* stderr*
conda remove --name devito --all

# Load gcc and mpi/intel-2018

# Install devito
module load gcc/8.2.0
module load intel-suite/2017
module load mpi

cd opesci
git clone https://github.com/opesci/devito.git
cd devito
# Load anaconda3
module load anaconda3/personal

# Create devito environment
conda env create -f environment.yml
source activate devito
pip install -e .
conda install gcc_linux-64
conda install mpi4py
pip install -r requirements-optional.txt
cd ../
# Install dependencies (optional as well for MPI)

# Install OpesciBench
git clone https://github.com/opesci/opescibench.git
cd opescibench
## module load anaconda3/personal

# Installing OpesciBench
pip install -e .
# Navigate to benchmarks folder

cd ../
export DEVITO_HOME=`pwd`/devito
cd devito/benchmarks/user/


# Start time
echo Start time is `date` > date

# Set env variables
export DEVITO_ARCH=gcc
export DEVITO_OPENMP=0
export DEVITO_MPI=1
export DEVITO_LOGGING=DEBUG
export DEVITO_DEBUG_COMPILER=1
# Experiment
numactl --cpubind=0 --membind=0 mpiexec python benchmark.py bench -P acoustic -bm O2 -d 50 50 50 -so 12 -a --tn 60

# End time
echo End time is `date` >> date
