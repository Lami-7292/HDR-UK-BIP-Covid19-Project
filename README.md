# A Retrospective Evaluation of COVID-19 Case Forecasts in the UK:
This repository contains R code and data for evaluating COVID-19 case forecasts for the UK. It compares forecast and baseline models with observed data, visualises the results, and calculates the forecast performance using metrics.

## Summary:
Forecasting is a key objective of infectious disease modelling and plays a vital role in informing public health decisions during outbreaks and epidemics. It helps public health officials, policymakers and healthcare providers anticipate healthcare demands, guide resource allocation, and support timely intervention planning.

During the COVID-19 pandemic, the Epiforecasts Group at the Centre for Mathematical Modelling of Infectious Diseases (CMMID) at the London School of Hygiene and Tropical Medicine (LSHTM) produced real-time forecasts of COVID-19 cases at the national level. However, these forecasts were only shared as tabular content and data visualisations through dashboards, with no formal evaluations being conducted to asses their accuracy.

This aim of this project was to compare a point forecast model (EpiNow2) to that of a constant baseline model over a 14-day horizon using the Mean Absolute Error (MAE).

## Repository Structure:
| Folder/File                  | Description                                                  |
|-------------------------------|--------------------------------------------------------------|
| `code/`                       | R scripts for analysis and evaluation                       |
| `data/`                       | Observed data, baseline forecasts, model forecasts           |
| `figures/`                    | Generated plots and visualisations                           |
| `analysis_plan_steps.md/html` | Workflow steps and project plan                              |
| `metrics_by_horizon.csv`      | Forecast performance metrics                                 |
| `README.md`                   | Project documentation                                        |
| `.Rproj / .Rhistory / .RData` | R project files (session data, project structure, history)   |

## Analysis Plan:
The workflow for this project followed these steps:
1. Collecting observed COVID-19 case data.  
2. Obtaining forcast and baseline models.  
3. Calculating forecast performance metrics (e.g., MAE & Model Score).  
4. Comparing forecast performance across horizons (e.g., days 1 - 14).  
5. Visualising and interpreting results.  

For more details, see: [analysis_plan_steps.md](analysis_plan_steps.md).

## Method:
- **Models Compared:**
  - *Forecast (EpiNow2) model* → Real-time forecasts produced during the pandemic.  
  - *Baseline model* → A persistence model assuming cases remain the same, which allows us to evaluate the performance of other models (reference model).

- **Metrics Used:**  
  - Mean Absolute Error (MAE) = (1/n) Σ |yᵢ - ŷᵢ|
  - Model Score (relative skill) = 1 - (MAE_EpiNow2 / MAE_baseline)

- **Forecast Horizons:**  
  - 14 days ahead (2 weeks)

## 📈 Results & Visualisations:
- Forecast performance was evaluated retrospectively against observed case data.  
- Results are stored in `figures/` and metrics in `metrics_by_horizon.csv`.  
- Key findings:  
  - The baseline model outperfromed the EpiNow2 model as it progressed from horizon 1-14. More uncertainty arises as the models predict further into the future, with more factors being vulverable to changing over time.
  - Although, this may not be ideal for public health decisions, this project only utilised the simplest models and with a plethora of other models available, the results may not always be linear and may show varying results.

### Running the Analysis
1. Clone this repository:
   ```bash
   git clone https://github.com/your-username/your-repo-name.git
2. Open the R project (HDR-UK-BIP-Covid19-Project.Rproj) in RStudio.
3. Run scripts inside the code/ folder in sequence to reproduce results.

### Acknowledgements:
The Epiforecasts Group at the CMMID, The London School of Hygiene and Tropical Medicine & HDR UK
