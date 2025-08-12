# Inputting all the relevant libraries: STEP 1
# install.packages("dplyr")
# install.packages("scales")
# install.packages("ggplot2")
# install.packages("digest")
library(dplyr)   # for data manipulation (e.g. aggregating data)
library(scales)   # better date formatting
library(ggplot2)   # for plotting graphs
library(digest)   # creates hash values for data, which is essential for caching, data verification and ensuring reproducibility
library(COVID19)
library(scoringutils)

# Loading & filtering the csv file (for the predicted data):STEP 2
#setwd("C:/Users/OlamideAdenuga/Desktop/COVID-19 Forecasts Internship Project/HDR-UK-BIP-Covid19-Project")
#getwd()
predicted_data = read.csv("predicted_cases.csv")
predicted_data <- predicted_data %>%
  filter(region == "United Kingdom")   # filters the data for where the region is United Kingdom
predicted_data$date <- as.Date(predicted_data$date)    # converts the date (column) variable into an actual Date (class) format
predicted_data$region <- NULL   # region variable (column) is redundant and so can be removed using NULL
predicted_data <- predicted_data[, c("date", "confirm")]   # allows me to extract only the 2 variables (columns) that I needed from the data

# Loading the observed data from the COVID19 R package [cumulative curve] :STEP 4
# install.packages("COVID19")
# library("COVID19")
observed_data <- covid19(country = "United Kingdom", level = 1, start = "2022-03-04", end = "2022-06-24")
observed_data$date <- as.Date(observed_data$date)    # converts the date (column) variable into an actual Date (class) format
observed_data <- observed_data[, c("date", "confirmed")]   # allows me to extract only the 2 variables (columns) that I needed from the data
observed_data <- observed_data %>%
  rename(confirm = confirmed)
#plot(observed_data)   # the output was a cumulative plot


# Transform the observed data from a cumulative plot to an incidence plot to match that of the predicted data:
observed_data <- observed_data %>%
  arrange(date) %>%
  mutate(confirm = confirm - lag(confirm)) %>%
  mutate(confirm = ifelse(is.na(confirm), 0, confirm)) %>%   # replaces any NA values with 0
  select(date, confirm)


# Incidence curve produced when plotting observed data (just for checking how it look without overlaying) - just to check how the plot looks visually
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

# Overlay the predicted and observed cases for a comparison [INCIDENCE CURVE]: STEP 5
predicted_data <- predicted_data %>% select(date, confirm)
observed_data <- observed_data %>% select(date, confirm)

predicted_data$source <- "Predicted"
observed_data$source <- "Observed"

combined_data <- bind_rows(predicted_data, observed_data)


# predicted data initially produces an incidence curve
# observed data initially produces a cumulative curve




# Overlay the predicted and observed cases for a comparison [CUMULATIVE CURVE]: STEP 6
#install.packages("COVID19")

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



#setwd("C:/Users/OlamideAdenuga/Desktop/COVID-19 Forecasts Internship Project/HDR-UK-BIP-Covid19-Project")
#getwd()
predicted_data = read.csv("predicted_cases.csv")
predicted_data <- predicted_data %>%
  filter(region == "United Kingdom")   # filters the data for where the region is United Kingdom
predicted_data$date <- as.Date(predicted_data$date)    # converts the date (column) variable into an actual Date (class) format
predicted_data$region <- NULL   # region variable (column) is redundant and so can be removed using NULL
predicted_data <- predicted_data[, c("date", "confirm")]   # allows me to extract only the 2 variables (columns) that I needed from the data

# Transform the predicted data from an incidence plot to an cumulative plot plot to match that of the observed data:
predicted_data <- predicted_data %>%
  arrange(date) %>%
  mutate(confirm = cumsum(confirm)) %>%   # cumulative sum of incidence
  select(date, confirm)




predicted_data <- predicted_data %>% select(date, confirm)
observed_data <- observed_data %>% select(date, confirm)

predicted_data$source <- "Predicted"
observed_data$source <- "Observed"

combined_data <- bind_rows(predicted_data, observed_data)

# Visualisations

# Plotting & formatting the line graph for the predicted data [incidence curve]: STEP 3
ggplot(predicted_data, aes(x = date, y = confirm)) +
  geom_line(color = "slateblue", linewidth = 0.5) +   #linewidth dictates the size or 'thickness' of the line on the plot
  scale_x_date(date_labels = "%B %Y") +
  # modifies the x-axis to add month and year, not just have the month: %B = full month name and %Y = 4-digit year
  scale_y_continuous(labels = comma) +   # modifies y-axis to make it more readable (e.g. from 2e+05 to 200,000) to show the actual integer
  labs(title = "Predicted COVID-19 Cases in The United Kingdom",
       x = "Date",
       y = "Number of Predicted Cases") +
  theme_classic()

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

predicted_vs_observed <- ggplot(combined_data, aes(x = date, y = confirm, color = source)) +
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

predicted_vs_observed


ggplot(predicted_data, aes(x = date, y = confirm)) +
  geom_line(color = "red", linewidth = 0.5) +
  scale_x_date(date_labels = "%B %Y") +
  scale_y_continuous(labels = comma) +
  labs(
    title = "Predicted COVID-19 Cases in The United Kingdom",
    x = "Date",
    y = "Number of Predicted Cases"
  ) +
  theme_classic()

# Plotting & formatting the line graph for the predicted data [incidence curve]
ggplot(predicted_data, aes(x = date, y = confirm)) +
  geom_line(color = "slateblue", linewidth = 0.5) +   #linewidth dictates the size or 'thickness' of the line on the plot
  scale_x_date(date_labels = "%B %Y") +
  # modifies the x-axis to add month and year, not just have the month: %B = full month name and %Y = 4-digit year
  scale_y_continuous(labels = comma) +   # modifies y-axis to make it more readable (e.g. from 2e+05 to 200,000) to show the actual integer
  labs(title = "Predicted COVID-19 Cases in The United Kingdom",
       x = "Date",
       y = "Number of Predicted Cases") +
  theme_classic()

# Forecast evaluation
