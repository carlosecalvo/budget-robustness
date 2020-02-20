library(readxl)
library(dplyr)

results = readxl::read_xlsx("aggregated-results.xlsx", sheet = "Results")

library(rpart.plot)

treated_results = results %>%
  mutate(model_fails = ifelse(results$`GDP pc final` > 10000, "GDP pc > 10k", "GDP pc < 10K")) %>%
  select(2:31, model_fails)
  
mean(treated_results$model_fails)

forest = randomForest::randomForest(model_fails ~ ., data = treated_results, importance = T)


tree = rpart::rpart(model_fails ~ ., data = treated_results,method = "class")

rpart.plot(tree)
