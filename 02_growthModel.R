####### RDM Budget Robustness Model #################
####### Growth Model Specification #################
#### Author: Carlos Calvo-Hernandez
#### 2020-10-01

#' Growth Model Evaluation function
#' 
#' @param dMFP a 76-length empty series with an initial value on entry 1
#' @param dGDP a 76-length empty series with an initial value on entry 1
#' @param GDP a 76-length empty series with an initial value on entry 1
#' @param dlTrend a number
#' @param dkTrend a number
#' @return a list of \code{GDP}, \code{dGDP}, \code{MFP}, \code{dlTrend}, and
#' \code{dkTrend}


growthModel <- function(dMFP = a, dGDP = g, GDP = y, dlTrend, dkTrend){
  
  ######## Labor parameters #########
  
  dl <- rep(NA, 76) # change in labor 
  
  # Initial condition
  dl[1] <- dlTrend # transition later to a dashboard like input (TO DO)
  
  
  for (t in 2:length(dl)) {
    if (t != 2) {
      dl[t] <- (population[t] / population[t - 1]) - 1
    } else {
      dl[t] <- (population[t] / pop0) - 1
    }
  }
  
  ######## Capital parameters #########
  
  dk <- rep(NA, 76) # change in capital
  
  # Initial condition
  dk[1] <- dkTrend #(TO DO)
  
  
  for (t in 2:76){
    dk[t] <- dk[1]*(1 + kTax[t] + kInf[t])
  }
  
  ###### Growth Model Specification ######
  
  for (t in 2:76){
    #aPol[t] <- lPol[t] + kPol[t] # (TO DO) Include adaptive policies
    dMFP[t] <- dMFP[t-1]*(1 + dk[t]) #+ aPol[t-1]
    g[t] <- dMFP[t] + dl[t]*Ly + dk[t]*Ky 
    y[t] <- y[t-1]*(1+g[t-1])
  }
  
  results <- list(GDP = y, dGDP = g, MFP = dMFP, dl = dlTrend, dk = dkTrend) 
  
  return(results)
  
}


