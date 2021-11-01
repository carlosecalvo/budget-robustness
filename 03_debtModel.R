####### RDM Budget Robustness Model #################
####### Debt Model Specification #################
#### Author: Carlos Calvo-Hernandez
#### 2020-10-12

## Need to add taxes function so debtModel can actually run.
## Replace budget
######## Tax Revenue #########
## Setting up the initial parameters for taxes based on input data
## budgetLines is an input from data_input.R

taxes <- function(type, k, GDP, budgetPol) { # personal, corporate and Other taxes
  y  <- as.double(GDP)
  budgetLine <- budgetPol
  for (t in 1:76) {
    type[t] <- y[t] * (budgetLine$trend[k]) #* (1 + budgetLines$pol[k])) + (1 + budgetLines$adap[k])
  }
  return(type)
}



debtModel <- function(intRate, intRateTrend, intRateSet = 1, GDP, budgetData = budgetLines){
  #browser()
  debt <- rep(NA, 76)
  bal <- rep(NA, 76)
  tax <- rep(NA, 76)
  exp <- rep(NA, 76)
  interest <- rep(NA, 76)
  discrete <- rep(NA, 76)
  mand <- rep(NA, 76)
  personal <- rep(NA, 76)
  
  y <- as.double(GDP)
  budget <- budgetData
  
  income <- taxes(income, 1, y, budgetPol = budget)
  fica <- taxes(fica, 2, y, budgetPol = budget)
  corp <- taxes(corp, 3, y, budgetPol = budget)
  otherTax <- taxes(otherTax, 4, y, budgetPol = budget)
  otherExp <- taxes(otherExp, 7, y, budgetPol = budget)
  defense <- taxes(defense, 8, y, budgetPol = budget)
  RD <- taxes(RD, 9, y, budgetPol = budget)
  educ <- taxes(educ, 10, y, budgetPol = budget)
  infr <- taxes(infr, 11, y, budgetPol = budget)
  
  
  # Health and social expenditures as %GDP (need to change as cost of beneficiaries)
  health <- taxes(health, 6, y, budgetPol = budget)
  social <- taxes(social, 5, y, budgetPol = budget)
  
  # Endogenous interest
  if (intRateSet == 1) { # 1 = FIAT and 0 = MARKET
    for (i in 1:length(intRate)) {
      intRate[i] <- intRateTrend
    }
  } else {
    intRate[1] <- intRateTrend
    for (j in 2:length(intRate)) {
      intRate[j] <- 0.015 + (0.45 * g[j - 1]) * (0.02 * (debt[j - 1] / y[j - 1]))
    }
  }
  
  ## Initial conditions for debt model
  
  
  debt[1] <- 10350
  interest[1] <- debt[1]*(1 + intRate[1])
  discrete[1] <- defense[1] + (educ[1] + infr[1] + RD[1]) #discretionary expenditure
  mand[1] <- social[1] + health[1] + otherExp[1] # Mandatory Expenditures
  exp[1] <- mand[1] + discrete[1] + interest[1] # Total Expenditures
  
  personal[1] <- income[1] + fica[1]
  tax[1] <- personal[1] + corp[1] + otherTax[1] # Taxes
  
  bal[1] <- tax[1] - exp[1] # GDP Balance
  
  ##### Debt Model Specification ######
  #browser()
  
  for (t in 2:76){
    interest[t] <- debt[t-1]*(1 + intRate[t]) # Interest Expenditures
    
    discrete[t] <- defense[t] + (educ[t] + infr[t] + RD[t]) # Discretionary Expenditure
    mand[t] <- social[t] + health[t] + otherExp[t] # Mandatory Expenditures
    exp[t] <- mand[t] + discrete[t] + interest[t] # Total Expenditures
    
    personal[t] <- income[t] + fica[t] # Personal taxes
    tax[t] <- personal[t] + corp[t] + otherTax[t] # Taxes
    
    bal[t] <- tax[t] - exp[t] # GDP Balance
    debt[t] <- debt[t-1] + bal[t-1]
  }
  
  results <- list(Debt = debt, Balance =  bal, TaxAgg = tax, PersonalTax = personal, ExpendituresAgg = exp, 
                  Mandatory = mand, DiscreteT = discrete, InterestAgg = interest)
  
  return(results)
}


