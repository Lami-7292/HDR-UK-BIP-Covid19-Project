library(tidyverse)
library(scales)

# We'll use data up to the end of 2022 (the rest are NA's; see the
# cumulative plot)
data_filter_date <- as.Date("2022-05-19")

# Load the model forecasts
uk_prediction_epiforecasts <- readRDS("data/uk_prediction_epiforecasts.rds") %>%
  filter(date <= data_filter_date) %>%
  filter(name == "median")

# Load the baseline predicted data
uk_prediction_baseline <- readRDS("data/uk_prediction_baseline.rds") %>%
  filter(date <= data_filter_date)


# Load the observed data
uk_observed <- readRDS("data/uk_observed.rds") %>%
  filter(date <= data_filter_date)

# Make plot
obs_vs_pred <- ggplot() +
  geom_line(
    data = uk_observed,
    aes(x = date, y = incidence, color = "Observed"),
    linewidth = 1
  ) +
  geom_line(data = uk_prediction_epiforecasts %>% filter(name == "median"),
            aes(x = date, y = prediction, color = "Epiforecasts"),
            linewidth = 1
  ) +
  geom_line(data = uk_prediction_baseline,
            aes(x = date, y = prediction, color = "Baseline"),
            linewidth = 1
  ) +
  scale_y_continuous(labels = comma) +
  labs(
    title = "UK COVID-19 Cases",
    x = "Date",
    y = "Number of Cases",
    color = "Data"
  ) +
  facet_wrap(~horizon) +
  theme_minimal()

ggsave(obs_vs_pred, filename = "figures/uk_obs_vs_pred.jpeg",
       width = 10, height = 6, dpi = 300)
