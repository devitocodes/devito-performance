## Script for a bash Devito Installation in $HOME Directory
## of a CX2 user.

cd $HOME
echo Working Directory is `pwd`

echo -ne Loading required modules...
module load intel-suite/2017
icc --version
module load mpi
mpicc -v
echo ...DONE

mkdir opesci
cd opesci
## Installing devito
git clone https://github.com/opesci/devito.git
cd devito

# Load anaconda3
module load anaconda3/personal

# Create devito environment
conda env create -f environment.yml
source activate devito
pip install -e .
#conda install gcc_linux-64
conda install mpi4py
# Install dependencies (optional as well for MPI)
pip install -r requirements-optional.txt
cd $HOME/opesci

# Install OpesciBench
git clone https://github.com/opesci/opescibench.git
cd opescibench
git status
git checkout mpi-perf-fixes

# Installing OpesciBench
pip install -e .
# Navigate to benchmarks folder

echo Returning to $HOME directory
cd $HOME
