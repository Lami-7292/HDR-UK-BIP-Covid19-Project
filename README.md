# A Retrospective Evaluation of COVID-19 Case Forecasts at the UK Sub-National Level:
This repository contains R code and data for evaluating COVID-19 case forecasts for the UK. It compares predicted cases (from a CSV file) with observed data from the COVID19 R package, visualises the results,and calculates forecast perfromance metrics (MAE, MSE & RMSE).

## Summary:
Forecasting is a key objective of infectious disease modelling and plays a vital role in informing public health decisions during outbreaks and epidemics. It helps public health officials, policymakers and healthcare providers anticipate healthcare demands, guide resource allocation, and support timely intervention planning.

During the COVID-19 pandemic, the Epiforecasts Group at the Centre for Mathematical Modelling of Infectious Diseases (CMMID) at the London School of Hygiene and Tropical Medicine (LSHTM) produced real-time forecasts of COVID-19 cases at the sub-national level. However, these forecasts were only shared as tabular content and data visualisations through dashboards, with no formal evaluations being conducted to asses their accuracy.

This project was built throughout an eight-week summer internship at the LSHTM organised through Health Data Research UK (HDR UK).

## Project Structure:
1. Directories
2. How To Run The Analysis
3. Results & Figures

## Directories:
| File / Folder | Description |
|---------------|-------------|
| `.Rproj.user` | RStudio hidden folder storing project-specific settings, history, and environment details. |
| `.RData` | Binary file storing your current R workspace (variables, data, etc.). |
| `.Rhistory` | Contains the history of R console commands for this project. |
| `.gitattributes` | Git configuration for file attributes (e.g., line endings, merge rules). |
| `README.md` | Main project documentation in Markdown format. |
| `hdr_uk_bip_covid_19_project.Rproj` | RStudio project file that opens your project with all settings. |
| `predicted_cases.csv` | Dataset containing predicted COVID-19 case counts. |
| `predicted_vs_observed_sub_national_covid_19_cases_uk.R` | R script comparing predicted vs. actual COVID-19 case data. |

## How To Run The Analysis:
1. Clone the repository:
   git clone https://github.com/YOUR_USERNAME/hdr_uk_bip_covid_19_project.git
   
2. Install R dependencies:
   install.packages(c("dplyr", "scales", "ggplot2", "tidyverse", "digest", "COVID19"))
  
3. Set the working directory and run the script:
   setwd("path/to/hdr_uk_bip_covid_19_project")
   source("predicted_vs_observed_sub_national_covid_19_cases_uk.R")

4. View the outputs:
   Plots will be displayed in RStudio
   Forecast accuracy metrics will be printed in the R console.

## Results & Figures:
### Forecast Accuracy Metrics:



### Plots:
