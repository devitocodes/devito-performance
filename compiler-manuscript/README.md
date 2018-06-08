#### Experimentation framework for the manuscript:

> Architecture and performance of Devito, a system for automated stencil
> computation

#### Usage

You will need:

* [Devito vTODO](todo) to reproduce the experiments in the manuscript.
* [Opescibench v0.1](https://github.com/opesci/opescibench/releases) to
  recreate the plots.

This directory is structured as follows:

* The collected performance data as well as the generated plots are located
  in the ``results`` directory.
* The script ``run.sh`` was used to run the experiments.
* The file ``machines.txt`` contains a description of the architectures used
  for the experiments. The file is structured so that it can be easily read and
  imported by a Python program. The Python program ``plot.sh`` (see below)
  reads ``machines.txt``.
* The program ``plot.py`` can be run to recreate the plots. You can run it as:
  ```
  DEVITO_HOME=/absolute/path/to/devito python plot.py data
  ```
  Note that you are expected to run it from this directory, otherwise you have
  to specify the right path to ``results``. You will find the generated plots
  within ``results``.
* A ``Makefile`` that you can invoke to clean up the directory tree (e.g., to
  remove all of the generated plot files)
