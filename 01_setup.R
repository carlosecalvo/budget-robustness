####### RDM Budget Robustness Model #################
######## Setup and Configuration ############
##### Author: Carlos Calvo-Hernandez
##### 2020-10-03

########## Load packages #########
library(tidyverse)

########## Source Data Script #########
source("data_input.R")

##### Parameter initialization and initial conditions ######

## Growth Model parameters

k <- rep(NA, 76)      # Capital
y <- rep(NA, 76)      # Gross Domestic Product (GDP)
g <- rep(NA, 76)      # Rate of growth of GDP
a <- rep(NA, 76)      # Rate of growth of Multi-factor productivity (MFP)
lPol <- rep(NA, 76)   # Influence of fiscal policies in labor
kPol <- rep(NA, 76)   # Influence of fiscal policies in capital
aPol <- rep(NA, 76)   # Influence of fiscal polcies in MFP

Ly <- 0.6             # Share of the economy of Labor
Ky <- 0.4             # Share of the economy of Capital
a1 <- 0.012           # MFP trend

k[1] <- 0.03 
y[1] <- 15000
g[1] <- 0.018         # y_t in the model
a[1] <- 0.0112

li <- 0.2
ki <- 0.1

dlTrend <- 0.0084 # Labor initial trend
dkTrend <- 0.0181 # Capital Initial trend

dldTaxPersonal <- RDMdash$Experimental.Value[19]  # Labor supply sensitivity to PERSONAL tax rate

### Population settings

pop0 <- 140L

population <- rep(NA, 76)

population[1] <- pop0

dpop <- rep(0.006, 76)

for (t in 2:length(population)) {
  population[t] <- population[t - 1] * (1 + dpop[t])
}

## Debt Model parameters

## Interest rates
intRate <- rep(NA, 76)
intRateSet <- values$Experimental[28] #"FIAT" or "MARKET"
intRate[1] <- 0.027 # B166
intRateTrend <- RDMdash$Experimental.Value[4] # B167
intThreshold <- 1.5 # B168
dIntdy <- as.numeric(values$Experimental[30])/100 # dInterest/dGDP  B169
dIntdDebtY <- as.numeric(values$Experimental[31])/100 # dInterest/d(Debt/GDP) B170
intConstant <- values$Experimental[32]/100 # B171

## parameters

corp <- rep(NA, 76)

otherTax <- rep(NA, 76)
otherExp <- rep(NA, 76)

income <- rep(NA, 76)
fica <- rep(NA, 76)
defense <- rep(NA, 76)
RD <- rep(NA, 76)
educ <- rep(NA, 76)
infr <- rep(NA, 76)
health <- rep(NA, 76)
social <- rep(NA, 76)




# Multiple plot function
#
# ggplot objects can be passed in ..., or to plotlist (as a list of ggplot objects)
# - cols:   Number of columns in layout
# - layout: A matrix specifying the layout. If present, 'cols' is ignored.
#
# If the layout is something like matrix(c(1,2,3,3), nrow=2, byrow=TRUE),
# then plot 1 will go in the upper left, 2 will go in the upper right, and
# 3 will go all the way across the bottom.
#
multiplot <- function(..., plotlist=NULL, file, cols=1, layout=NULL) {
  library(grid)
  
  # Make a list from the ... arguments and plotlist
  plots <- c(list(...), plotlist)
  
  numPlots = length(plots)
  
  # If layout is NULL, then use 'cols' to determine layout
  if (is.null(layout)) {
    # Make the panel
    # ncol: Number of columns of plots
    # nrow: Number of rows needed, calculated from # of cols
    layout <- matrix(seq(1, cols * ceiling(numPlots/cols)),
                     ncol = cols, nrow = ceiling(numPlots/cols))
  }
  
  if (numPlots==1) {
    print(plots[[1]])
    
  } else {
    # Set up the page
    grid.newpage()
    pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))
    
    # Make each plot, in the correct location
    for (i in 1:numPlots) {
      # Get the i,j matrix positions of the regions that contain this subplot
      matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))
      
      print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row,
                                      layout.pos.col = matchidx$col))
    }
  }
}
