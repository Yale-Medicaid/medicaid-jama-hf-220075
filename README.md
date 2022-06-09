# medicaid-jama-hf-220075
Repository for JAMA Health Forum paper entitled "Disparities in Health Care Spending and Utilization Among Black and White Medicaid Enrollees"

Jacob Wallace, Anthony Lollo, Chima Ndumele, Kate A. Duchowny, Matthew Lavallee, JAMA Health Forum

# Replication Code
The programs for the main paper regressions are provide as .do files that need to be run in a stata environment. An extra .py file that needs to be run in a python environment is provided for adjusting the Stata prodcued p-values using the Benjamini-Hochberg procedure.

#### Required Packages and Versions 
The analysis was performed with the following libraries and versions, so to ensure reproducibility packages and versions should match

```
python 3.8.7 

pandas 1.3.2
numpy 1.20.1
statsmodels 0.12.2
linearmodels 4.19
matplotlib 3.3.4
```

#### Data
This paper uses restricted data which must be aqcuired from XXXX

#### Analysis and Processing Scripts
All code for this project is provided within the `code\` folder.

Creation of the analytic table from administrative claims and enrollment data including health care outcomes and spending, patient characteristics were performed with Python. Figures were created with matplotlib. Coefficients for racial disparities were estimated by importing the analytic tables into Stata 16 and using reghdfe. The estimation code can be found in the code\ folder where:
1. `main_regressions.do`: Stata do file that runs the main regressions using `reghdfe` command for the follwing specifications:
   -  No controls
   -  Adjusted for enrollee demographics
   -  Adjusted for enrollee demograohics and health status
2. `main_regressions_with_provider_FE.do`: Stata do file that runs the main regressions using `reghdfe` command for the follwing specification:
   -  Adjusted for enrollee demograohics, health status and usual source of care (i.e., provider fixed effect)

A final .py file `adjuted_pvals.py` adjusts Stata produced p-values from `main_regressions_provider_FE.do` using the Benjamini-Hochberg procedue in `statsmodels'.

