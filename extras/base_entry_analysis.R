# Base Entry Analysis


source("network_risk_run_experiments.R")
library(dplyr)


base_entry = base_entry_model() %>%
  base_entry_set_parameter(model = ., parameter_name = "n", experimental_design = "grid", values = seq.default(from = 10, to = 40, by = 2)) %>%
  base_entry_set_parameter(model = ., parameter_name = "p", experimental_design = "lhs", min = 0.0001, max = 0.01) %>%
  base_entry_set_parameter(model = ., parameter_name = "immunized.p", experimental_design = "grid", values = seq.default(from = 0.02, to = 0.3,length.out = 10)) %>%
  base_entry_set_parameter(model = ., parameter_name = "t", experimental_design = "grid", values = c(14)) %>%
  base_entry_set_parameter(model = ., parameter_name = "R0", experimental_design = "grid", values = c(1)) %>%
  base_entry_set_experimental_design(model = ., n_new_lhs = 2)

  
results = base_entry %>%
  base_entry_evaluate_experiment(model = ., n_cores = 7, parallel_mode = "PSOCK", write_csv = T, test_run = F)


write.csv(base_entry$future_experimental_design, "./output_base_entry/experimental_design.csv", row.names = F)

write.csv(results, "./output_base_entry/experimental_results.csv", row.names = F)
