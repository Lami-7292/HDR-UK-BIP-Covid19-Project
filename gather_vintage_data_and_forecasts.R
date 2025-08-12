# install.packages("COVID19")
library("COVID19")
library("tidyverse")

#---
# Source required functions
#---
source("get_covid19_nowcasts.R")
source("baseline_forecast_models.R")

#---
# Reconstruct the Uk forecasts from GitHub commits
#---
uk_prediction_epiforecasts <- get_covid19_nowcasts(location = "United Kingdom") %>%
    mutate(model = "epiforecasts-EpiNow2") %>%
    select(-country) %>%
    filter(name == "median")

saveRDS(uk_prediction_epiforecasts, "data/uk_prediction_epiforecasts.rds")

#---
# Get observed data
#---
# Using vintage data. Data here was cross-checked against that returned by the
# covidData package, which is not available on CRAN. This package was chosen
# because it's on CRAN and also provides a simple interface to the UK COVID-19
# data, including vintage data.
uk_observed <- COVID19::covid19(
    country = "United Kingdom",
    vintage = as.Date(max(uk_prediction_epiforecasts$date))) %>%
    select(date, confirmed) %>%
    rename(cumulative = confirmed) %>%
    mutate(incidence = cumulative - lag(cumulative, default = 0)) %>%
    select(date, incidence)

# Save observed data
saveRDS(uk_observed, "data/uk_observed.rds")

#---
# Construct the baseline forecasts using the vintage data
#---
uk_prediction_baseline <- constant_baseline_forecasts(uk_observed, col = "incidence", horizon = 14)
# Get median baseline forecast
uk_prediction_baseline <- uk_prediction_baseline %>%
    mutate(model = "constant_baseline", name = "median")

saveRDS(uk_prediction_baseline, "data/uk_prediction_baseline.rds")
