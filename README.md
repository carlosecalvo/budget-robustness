# US Budget Robustness RDM Analysis Project

Author: Carlos Calvo-Hernandez

Welcome to the **US Budget Robustness RDM Analysis Project** by Carlos Calvo-Hernandez,
Horacio Trujillo, and Rob Lempert.  

In this repository you will find all the files that have been created up to date. 
The most important files are those that begin with a number (i.e., 01_setup.R, 02_growthModel, etc.),
these files are where the most up to date parts of the analysis takes place.

The [dashboard](https://carloscalvo.shinyapps.io/Budget-model-dashboard/) 
to visualize the model results is deployed from the file `100_model-dashboard.Rmd`.
This file "calls" the files 01, 02, and 03.

## Model Files

* `01_setup.R`: contains the variables and series that the model needs to setup.

* `02_growthModel.R`: as the name suggests, this is the main function of the growth model.

* `03_debtModel.R`: this script contains the budget model, plus the tax calculation function.

## Other files

* `100_model-dashboard.Rmd`: contains the code for the interactive dashboard.

* `data_input.R`: contains the information from the Excel model, particularly from 
the "RDM Dashboard" and the "Inputs by Category" sheets.
