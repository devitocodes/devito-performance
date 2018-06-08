#### Required changes before re-running the experiments with latest Devito

* Update ``run.sh``:
  * Make it work from ``DEVITO_HOME``
  * Drop ``DEVITO_AUTOTUNING`` and ``DEVITO_YASK_AUTOTUNING``
  * Fix ``sz`` loop? There should be a 768 somewhere, not 256
  * Fix ``so`` loop? There should be 4, 8, 12, 16
  * Change ``dir`` to write to ``data``?
