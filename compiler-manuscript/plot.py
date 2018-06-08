import os
import sys
from subprocess import call
import re

#
# Expected directory tree:
#
# root (eg: 'results')
#  | -- problemname (eg: acoustic, tti)
#  |       | -- backend (eg: core, yask)
#  |       |      | -- benchmode (eg: O2, dse)
#  |       |      |       | -- archname (eg: knl7250)
#  |       |      |       |       | -- grid512 -- files
#  |       |      |       |       | -- grid768 -- files
#  |       |      |       |       | -- grid1024 -- files
#
# E.g.: results/acoustic/core/bmO2/knl7250/grid512
#

if len(sys.argv) != 2:
    print("Usage: python plot.py absolute/path/to/root")
    sys.exit(0)

machines = {}
exec(open("machines.txt").read(), {}, machines)

subfolders = ['problemname', 'backend', 'benchmode', 'archname', 'grid']

benchmarkpy = os.path.join(os.environ['DEVITO_HOME'], 'examples', 'seismic', 'benchmark.py')

root = sys.argv[1]
dirs = [x[0] for x in os.walk(root)]

root_depth = len(root.split('/'))
plot_dirs = [i for i in dirs if len(i.split('/')) - len(subfolders) == root_depth]

for i in plot_dirs:
    problem, backend, benchmode, arch, _ = i.split('/')[root_depth:]
    files = [f for f in os.listdir(i) if f.endswith('json')]
    if not files:
        print("No data files?")
        sys.exit(0)

    if arch not in machines:
        print("Don't own any information for %s architecture" % arch)
        sys.exit(0)
    machine = machines[arch]

    grid = re.search(r"shape\[([A-Za-z0-9_,]+)\]", files[0]).group(1).split(',')
    space_orders = sorted(set([int(re.search(r"so\[(\w+)\]", j).group(1)) for j in files]))
    tn = re.search(r"tn\[(\w+)\]", files[0]).group(1)
    autotune = re.search(r"at\[([A-Za-z0-9_,]+)\]", files[0]).group(1)

    args = ['python', benchmarkpy, 'plot', '-P', problem, '-bm', benchmode]  # plot cmd
    args += ['-d'] + grid  # grid shape
    for j in space_orders:
        args += ['-so', str(j)]  # space orders tested
    args += ['-to', '2', '--tn', tn]  # time-related simulation parameters
    args += ['-r', i]  # plot dir
    args += ['--autotune', autotune]
    args += ['--backend', backend]
    args += ['--arch', arch, '--max-bw', str(machine['dram-stream-bw']),  # arch params
             '--flop-ceil', str(machine['machine-peak']), 'ideal',
             '--flop-ceil', str(machine['linpack-peak']), 'linpack']
    call(' '.join(args), shell=True)
