# Section 1 - DATA PREPARATION:

# Install all the relevant libraries:
library(scales)   # better date formatting
library(tidyverse)


# RETRIEVING THE DATA:
uk_observed <- readRDS("data/uk_observed.rds")
uk_prediction_baseline <- readRDS("data/uk_prediction_baseline.rds")
uk_prediction_epiforecasts <- readRDS("data/uk_prediction_epiforecasts.rds")

# A) OBSERVED DATA:
observed_data <- uk_observed %>%
  mutate(date = as.Date(date)) %>%
  rename(observed = incidence) %>%
  select(date, observed)

# B) FORECAST DATA:
# Baseline:
baseline_data <- uk_prediction_baseline %>%
  mutate(date = as.Date(date),
         issue_date = as.Date(issue_date)) %>%
  select(date, horizon, baseline_pred = prediction)

# Epiforecast:
epiforecasts_data <- uk_prediction_epiforecasts %>%
  filter(name == "median") %>%  # keep only median predictions
  mutate(date = as.Date(date)) %>%
  select(date, horizon, epiforecasts_pred = prediction)

paired <- epiforecasts_data %>%
  inner_join(baseline_data, by = c("date","horizon")) %>%  # keep only common targets
  left_join(observed_data, by = "date") %>%                     # attach observations
  filter(!is.na(observed))                             # ensure we can evaluate


# Section 2 - DATA VISUALISATION:

epinow2_forecast_vs_data_one_horizon <- ggplot(paired %>% filter(horizon == 10), aes(x = date)) +
  geom_line(aes(y = observed, color = "Observed"), linewidth = 0.4) +
  geom_line(aes(y = epiforecasts_pred, color = "Epiforecast"), linewidth = 0.6) +
  geom_line(aes(y = baseline_pred, color = "Baseline"), linewidth = 0.4) +
  scale_y_continuous(labels = scales::comma) +
  scale_color_manual(values = c("Observed" = "red", 
                                "Epiforecast" = "#4B0082", 
                                "Baseline" = "#0080FE")) +
  labs(title = "Forecasts vs Observed",
       x = "Date", y = "Incidence",
       color = "Legend") +
  theme_minimal()
epinow2_forecast_vs_data_one_horizon

forecasts_by_horizon <- ggplot(paired, aes(date)) +
  geom_line(aes(y = observed, color = "Observed"), linewidth = 0.4) +
  geom_line(aes(y = epiforecasts_pred, color = "Epiforecast"), linewidth = 0.4) +
  geom_line(aes(y = baseline_pred, color = "Baseline"), linewidth = 0.4) +
  scale_y_continuous(labels = scales::comma) +
  scale_x_date(
    date_breaks = "1 year",   # show one tick per year
    date_labels = "%Y",       # label format = just year
    expand = c(0,0)           # remove extra padding
  ) +
  scale_color_manual(values = c("Observed" = "red", "Epiforecast" = "#4B0082", "Baseline" = "#0080FE")) +
  facet_wrap(~ horizon, scales = "free_y") +
  labs(title = "Forecasts vs Observed by Horizon",
       x = "Date", y = "Incidence",
       color = "Legend") +
  theme_minimal()
forecasts_by_horizon

p_mae <- metrics %>%
  select(horizon, mae_epiforecasts, mae_baseline) %>%
  pivot_longer(-horizon, names_to = "model", values_to = "mae") %>%
  ggplot(aes(horizon, mae, color = model)) +
  geom_line() +
  geom_point() +
  scale_x_continuous(breaks = seq(1, 14, 1)) +
  scale_color_manual(values = c("mae_epiforecasts" = "#4B0082", "mae_baseline" = "#0080FE")) +
  labs(x = "Horizon (days ahead)", y = "MAE",
       title = "MAE by horizon: epiforecasts vs baseline") +
  theme_minimal()
p_mae

p_score <- ggplot(metrics, aes(horizon, score)) +
  geom_hline(yintercept = 0, linetype = 2, colour = "red") +
  geom_line() +
  geom_point() +
  scale_x_continuous(breaks = seq(1, 14, 1)) +
  labs(x = "Horizon (days ahead)",
       y = "Model score: 1 - (MAE_epiforecasts / MAE_base)",
       title = "Relative skill of epiforecast vs baseline by horizon") +
  theme_minimal()
p_score


# Section 3 - FORECAST EVALUATION:

eval_df <- paired %>%
  mutate(
    err_epiforecasts  = epiforecasts_pred  - observed,
    err_base = baseline_pred - observed,
    ae_epiforecasts   = abs(err_epiforecasts),
    ae_base  = abs(err_base)
  )

metrics <- eval_df %>%
  group_by(horizon) %>%
  summarise(
    n            = n(),
    mae_epiforecasts      = mean(ae_epiforecasts,  na.rm = TRUE),
    mae_baseline = mean(ae_base, na.rm = TRUE),
    score        = 1 - mae_epiforecasts / mae_baseline,
    .groups = "drop"
  ) %>%
  arrange(horizon)
metrics
write.csv(metrics, "metrics_by_horizon.csv", row.names = FALSE)