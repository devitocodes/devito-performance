#### Experimentation framework for the manuscript:

> Architecture and performance of Devito, a system for automated stencil
> computation

#### Usage

You will need:

* [Devito v3.1](https://github.com/opesci/devito/releases/tag/v3.1.0) to
  reproduce the experiments with the CORE backend.
* [YASK 7f0334d](https://github.com/opesci/yask) to run the experiments with
  the YASK backend.
* [Devito v3.3](https://github.com/opesci/devito/releases/tag/v3.3) and
  [Opescibench v0.1](https://github.com/opesci/opescibench/releases) to
  recreate the plots. The reason Devito v3.3 is used for plotting instead
  of the aforementioned Devito v3.1 is simply that substantial improvements to
  the plotting routines have been added over time, and the final version of
  the manuscript uses the v3.3 variant.

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
  DEVITO_HOME=/absolute/path/to/devito python plot.py `pwd`/results
  ```
  Note that you are expected to run it from this directory, otherwise you have
  to specify the right path to ``results``. You will find the generated plots
  within ``results``.
* A ``Makefile`` that you can invoke to clean up the directory tree (e.g., to
  remove all of the generated plot files)
