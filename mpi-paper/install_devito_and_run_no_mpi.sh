#!/bin/bash
# Job name
#PBS -N test_devito_benchmarking_no_mpi
# Time required in hh:mm:ss
#PBS -l walltime=00:08:00
# Resource requirements
#PBS -lselect=1:ncpus=8:mem=96gb:mpiprocs=1:ompthreads=8
# Files to contain standard error and standard output
# Mail notification
#PBS -m bea
#PBS -M g.bisbas18@imperial.ac.uk

echo Working Directory is $PBS_O_WORKDIR
cd $PBS_O_WORKDIR
conda remove --name devito --all

# Load gcc and mpi/intel-2018

# Install devito
git clone https://github.com/opesci/devito.git
cd devito
# Load anaconda3
module load anaconda3/personal
##anaconda–setup

# Create devito environment
conda env create -f environment.yml
source activate devito
# Install dependencies (optional as well for MPI)
pip install -e .

## pip install -r requirements-optional.txt

# Install OpesciBench
git clone https://github.com/opesci/opescibench.git
cd opescibench
## module load anaconda3/personal

# Installing OpesciBench
python setup.py build
python setup.py install

# Navigate to benchmarks folder

cd ../benchmarks/user/


# Start time
echo Start time is `date` > date


# Set env variables
export DEVITO_ARCH=gcc
export DEVITO_HOME=`pwd`/devito
export DEVITO_OPENMP=1
export DEVITO_MPI=0
export DEVITO_LOGGING=DEBUG
export DEVITO_DEBUG_COMPILER=1
# Experiment
numactl --cpubind=0 --membind=0 python benchmark.py bench -P acoustic -bm O2 -d 80 80 80 -so 12 -a --tn 40

# End time
echo End time is `date` >> date
