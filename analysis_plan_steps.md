* **Setup**

  * Load `tidyverse`.

* **Prepare inputs (make tables comparable)**

  * Observed: rename to `date`, `observed`.
  * Baseline: keep `date`, `horizon`, `baseline_pred`.
  * Epiforecasts: keep `date`, `horizon`, `epi_pred`.
  * Ensure dates are `Date` type; same units; no duplicates per `(date, horizon)`.

* **Keep only overlapping targets**

  * Inner-join epiforecasts and baseline on `(date, horizon)`.
  * Left-join observed on `date`.
  * Drop rows with missing `observed`.

* **Compute errors**

  * `err_epi = epi_pred - observed`; `err_base = baseline_pred - observed`.
  * `ae_epi = |err_epi|`; `ae_base = |err_base|`.

* **Summarise by horizon**

  * For each `horizon`:

    * `MAE_epi = mean(ae_epi)`, `MAE_base = mean(ae_base)`.
    * **Model score (relative skill)**: `score = 1 - MAE_epi / MAE_base`.
    * Keep `n` (rows per horizon).

* **Visualise**

  * **MAE by horizon** (two lines: epiforecasts vs baseline; lower is better).
  * **Model score by horizon** (line; add zero reference line; above zero is better than baseline).

* **Report**

  * Table: `horizon, n, MAE_epi, MAE_base, score`.
  * Brief summary: average score overall, 1–7 vs 8–14 days.

* **Hints for interpretation**

  * **MAE:** lower curve wins; expect MAE to grow with horizon.
  * **Model score:** `> 0` = epiforecasts better; `< 0` = baseline better.
  * **Short vs long horizons:** often stronger skill for 1–7 days than 8–14.
  * **Sample size:** small `n` at long horizons (start/end of series) → cautious conclusions.
  * **Data sanity:** confirm same units/scale across all tables; check for duplicate `(date, horizon)` pairs.
  * **Context:** baseline can win during stable periods; negative score there isn’t “bad” data—it’s insight.
  * **Next steps (optional):** add bias (mean signed error), Diebold–Mariano tests, and sliding-window skill over time.
