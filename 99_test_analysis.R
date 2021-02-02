####### RDM Budget Robustness Model #################
####### Analysis Script #################
#### Author: Carlos Calvo-Hernandez
#### 2020-10-14

library(ggplot2)
library(glue)

### Source scripts in order

files <- list.files(pattern = "^[0-3]{2}(.*).R$")

purrr::map(files, source)


### Single run of the growth model with labor and capital trends 
growthRes <- growthModel(dlTrend = 0.00837, dkTrend = 0.0181) %>% 
  as_tibble()

testMFP <- rep(NA, 76)
testMFP[1] <- 0.02

growthRes2 <- growthModel(dMFP = testMFP, dlTrend = 0.01, dkTrend = 0.05) %>% 
  as_tibble()
  
cbind(growthRes, growthRes2) %>% 
  ggplot(aes(x = 1:76))+
  geom_line(data = growthRes, aes( y = GDP*3736))+
  geom_point(data = growthRes, aes(y = GDP*3736)) + 
  geom_line(data = growthRes2, aes(y = GDP), color = 'red')+
  geom_point(data = growthRes2, aes(y = GDP), color = 'red')
  


  geom_line(data = growthRes2, aes( y = GDP ))+
  geom_point()


### Create grid of 3 values for each labor and capital trend based on RDMDashboard

createSeq <- function(index, size){
  x <- seq(RDMdash$Lower.Bound[index], RDMdash$Upper.Bound[index], length.out = size)
  return(x)
}

labor <- createSeq(3, 3)

capital <- createSeq(2, 3)

experiments <- expand.grid(dlTrend = labor, dkTrend = capital)

row.names(experiments) <- glue("Experiment {row(experiments)[,1]}")

arguments <- list(dlTrend = experiments$dlTrend, dkTrend = experiments$dkTrend)

resultRun <- arguments %>% 
  as_tibble(.) %>% 
  pmap( .f = growthModel) 

testExp <- experiments %>% 
  pmap(.f = growthModel)

names(testExp) <- row.names(experiments)

df_test <- testExp %>% 
  hoist(GDP)


onlygdp <- testExp %>% 
  as_tibble() 

onlygdp %>% 
  ggplot(aes(x = 1:76))+
  geom_line(aes(y = unlist(`Experiment 1`[[1]])), color = 'red')+
  geom_line(aes(y = unlist(`Experiment 2`[[1]])), color = 'green')+
  geom_line(aes(y = unlist(`Experiment 3`[[1]])), color = 'blue')

  
  
  
onlygdp %>% 
  ggplot()+
  geom_line(aes(x = 1:76, y = GDP...1))

onlydgdp <- testExp %>% 
  select(starts_with("dGDP", ignore.case = F))

resultRun %>% 
  mutate(time = row(.)) %>% 
  ggplot(aes(x = time)) +
  geom_line(aes(y = y...1)) +
  geom_line(aes(y = y...4))

### Terrible solution to plot GDP

onlygdp <- onlygdp[1,]

myPlot <- function(x){
  x <- unlist(x)
  p <- plot.ts(x)
  return(p)
}

map(onlygdp[,1], myPlot)

plot.ts(onlygdp$`Experiment 3`[[1]])




test <- as_tibble(experiments) %>% 
  mutate(ExpResults = as_tibble(growthRes))


#### Debt Model Runs



debtResult <- debtModel(intRate = intRate, intRateTrend = intRateTrend, intRateSet = intRateSet, GDP = growthRes$GDP) %>% 
  as.tibble()



### Think about running parallel computations in Julia through JuliaCall

library(JuliaCall)

JuliaCall::julia_setup(JULIA_HOME = r"(C:\Users\ccalvo\AppData\Local\Programs\Julia\Julia-1.5.2\bin)")




#### Fixing budgetLines assignment

library(tidyverse)

input <- policies[which(names(policies) == namesPol[[5]])]

#names(input) <- "pol"

test <- budgetLines %>%  
  mutate(pol = deframe(input))
