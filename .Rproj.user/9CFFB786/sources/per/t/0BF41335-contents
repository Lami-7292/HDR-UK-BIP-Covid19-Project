# Section 1 - DATA PREPARATION:

# Install all the relevant libraries:
library(dplyr)   # for data manipulation (e.g. aggregating data)
library(scales)   # better date formatting
library(ggplot2)   # for plotting graphs
library(tidyverse)
library(digest)   # creates hash values for data, which is essential for caching, data verification and ensuring reproducibility
library(COVID19)

# Loading & filtering the csv file (for the predicted data):
setwd("C:/Users/OlamideAdenuga/Desktop/evaluating_covid_19_forecasts_internship_project/hdr_uk_bip_covid_19_project")
getwd()
predicted_data = read.csv("predicted_cases.csv")
predicted_data <- predicted_data %>%
  filter(region == "United Kingdom")   # filters the data for where the region is United Kingdom
predicted_data$date <- as.Date(predicted_data$date)    # converts the date (column) variable into an actual Date (class) format
predicted_data$region <- NULL   # region variable (column) is redundant and so can be removed using NULL
predicted_data <- predicted_data[, c("date", "confirm")]   # allows me to extract only the 2 variables (columns) that I needed from the data

# Loading the observed data from the COVID19 R package (cumulative curve):
# install.packages("COVID19")
observed_data <- covid19(country = "United Kingdom", level = 1, start = "2022-03-04", end = "2022-06-24")
observed_data$date <- as.Date(observed_data$date)    # converts the date (column) variable into an actual Date (class) format
observed_data <- observed_data[, c("date", "confirmed")]   # allows me to extract only the 2 variables (columns) that I needed from the data
observed_data <- observed_data %>%
  rename(confirm = confirmed)

# Transform the predicted data from an incidence plot to an cumulative plot plot to match that of the observed data:
predicted_data <- predicted_data %>%
  arrange(date) %>%
  mutate(confirm = cumsum(confirm)) %>%   # cumulative sum of incidence
  select(date, confirm)

# Transform the observed data from a cumulative plot to an incidence plot to match that of the predicted data:
observed_data <- observed_data %>%
  arrange(date) %>%
  mutate(confirm = confirm - lag(confirm)) %>%
  mutate(confirm = ifelse(is.na(confirm), 0, confirm)) %>%   # replaces any NA values with 0
  select(date, confirm)

# Creating the data frame to help me calculate the MAE, MSE & RMSE:
df <- data.frame(
  date = predicted_data$date,
  predicted = predicted_data$confirm,
  observed = observed_data$confirm
) %>%
  mutate(time = row_number())

# Reshaping the data frame for plotting:
df_long <- tidyr::pivot_longer(
  df,
  cols = c(predicted, observed),
  names_to = "variable",
  values_to = "value"
)




# Section 2 - DATA VISUALISATION:

# predicted data initially produces an incidence curve
# observed data initially produces a cumulative curve

# Plotting the predicted data:
ggplot(predicted_data, aes(x = date, y = confirm)) +
  geom_line(color = "slateblue", linewidth = 0.5) +   #linewidth dictates the size or 'thickness' of the line on the plot
  scale_x_date(date_labels = "%B %Y") +
  # modifies the x-axis to add month and year, not just have the month: %B = full month name and %Y = 4-digit year  
  scale_y_continuous(labels = comma) +   # modifies y-axis to make it more readable (e.g. from 2e+05 to 200,000) to show the actual integer
  labs(title = "Predicted COVID-19 Cases in The United Kingdom",
       x = "Date",
       y = "Number of Predicted Cases") +
  theme_classic()

# Plotting the observed data:
ggplot(observed_data, aes(x = date, y = confirm)) +
  geom_line(color = "red", linewidth = 0.5) +
  scale_x_date(date_labels = "%B %Y") +
  scale_y_continuous(labels = comma) +
  labs(
    title = "Observed COVID-19 Cases in The United Kingdom",
    x = "Date",
    y = "Number of Observed Cases"
  ) +
  theme_classic()

# Plotting the overlay:
predicted_data <- predicted_data %>% select(date, confirm)
observed_data <- observed_data %>% select(date, confirm)

predicted_data$source <- "Predicted"
observed_data$source <- "Observed"

combined_data <- bind_rows(predicted_data, observed_data)

ggplot(combined_data, aes(x = date, y = confirm, color = source)) +
  geom_line(linewidth = 1) +
  scale_color_manual(values = c("Predicted" = "slateblue", "Observed" = "orange")) +
  scale_x_date(date_labels = "%B %Y" ) +
  scale_y_continuous(labels = comma) +
  labs(title = "A Comparison of Predicted and Observed COVID-19 Cases In The UK",
       x = "Date",
       y = "Number of Cases",
       color = "Type of Case Data") + 
  theme_classic() +
  theme(legend.position = "top")

# Formulating the plot for the data frame:
ggplot(df_long, aes(x = time, y = value, color = variable)) +
  geom_point() +
  geom_line(ggplot2::aes(group = variable)) +
  labs(title = "Predicted vs Observed Cases") +
  theme_classic()




# Section 3 - FORECAST EVALUATION:

# Calculating the MAE, MSE & RMSE:
metrics <- df %>%
  mutate(
    error = observed - predicted,   # calculates the difference between the observed and predicted data
    abs_error = abs(error),   # calculate the absolute error independently first for the MAE
    squared_error = error^2   # calculate the squared error independently first for the MSE and RMSE
  ) %>%
  summarise(
    MAE = mean(abs_error),
    MSE = mean(squared_error),
    RMSE = sqrt(MSE)
  )