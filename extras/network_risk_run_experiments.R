
#### Network Risk Experiments Function-------------------------------------------------####

#----------------------------------------------------------------------------------------#
# Author: Pedro Nascimento de Lima & Raffaelle Vardavas
#
# Purpose: Generic Functions for Running Experiments for Raff's Network Experiments Model.
# These functions are used to set and run what-if scenarios defined in a Latin Hypercube
# Sample and/or in a Full Factorial Design Sample.
# These functions are particularly useful for RDM analyses that explore the robustness of
# Strategies across an ensemble of future states of the world.
#
# Creation Date: October 2020
#----------------------------------------------------------------------------------------#

load <- function(pkg){
  new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
  if (length(new.pkg))
    install.packages(new.pkg, dependencies = TRUE)
  sapply(pkg, require, character.only = TRUE)
} 

packages <- c("knitr","kableExtra","rmdformats","rmarkdown","dplyr","here","reshape2",
              "DBI","igraph","rgdal","zipcode","cowplot","DT",
              "htmltools","visNetwork","reticulate","DiagrammeR",
              "semTools","nonnest2","htmlTable", "deSolve","RefManageR",
              "qgraph","pracma","ggplot2","scales","ggthemes",
              "flumodels", "cli", "pbapply", "parallel")
load(packages)



get.num.expected.test.positive<- function(inf_0,n=30,immunized=0,t=14,fn=0.05,fp=0.01,R0=5,tau.eff=14,n.realizations=100){
  
  if(t>1.5*tau.eff) stop("going belond the limits of the assumptions made in the get.num.expected.test.positive function")
  
  ## seed in ids of the initially infected.
  initially.infected.id <- sample(n-immunized,min(n-immunized,inf_0))
  
  
  ## comupute transmision parameters
  k.avg <- n-1
  beta <- -log(1-R0/k.avg)/tau.eff   
  T.prob <- 1-exp(-beta*t)
  
  if( abs(k.avg*T.prob- R0)>1e-6) stop ("validation error")
  
  tmp<-NULL
  
  for(realization in 1:n.realizations){
    ## constract an erdos.renyi network where the edges are activatited based on the transmissibility. 
    g <- erdos.renyi.game(n, T.prob, type=c("gnp"))
    g <- delete_edges(g, unlist(incident_edges(g, c((n-immunized):n), mode = "all")))
    
    ## Do the percolation transmission process and find connected clusters
    g.sub.cluster <- clusters(g)
    ## find the Ids of the clusters that contain at least one of the initially infected individuals. 
    ## these clusters are assumed to be infected.
    infected.cluster.ids<-unique(g.sub.cluster$membership[initially.infected.id])
    
    ## find the ids and the number of people belonging to the infected clusters
    final.infected.id <- c(1:n)[g.sub.cluster$membership%in% infected.cluster.ids]
    inf_t <- length(final.infected.id)
    ## assume that some of the initially infected have recoved and that secondary infections recover once t>tau.eff
    inf_t <-  (inf_t-inf_0)* min(1,exp(-(t-tau.eff)/tau.eff)) +inf_0 *exp(-2*t/tau.eff) 
    tmp <- c(tmp,inf_t)
  }
  
  inf_t <- mean(tmp)
  
  ## find the expected number of people that are tested positive by the end of the isolation period
  expected.n.false.negatives <-  fn*inf_t 
  expected.n.false.positive <- fp*(n-inf_t)
  expected.test.positive<- inf_t-expected.n.false.negatives+ expected.n.false.positive
  
  return(c(infected= inf_t,expected.test.positive=expected.test.positive))
}


solve_base_entry = function(model, params) {
  
  # Params is a one line data.frame with each param for this function.
  # params = data.frame(
  #   n = 30, p = 0.001, immunized = 0, t = 14, R0 = 1
  # )
  
  n<- params$n
  p<- params$p
  immunized <- round(params$n * params$immunized.p, digits = 0) 
  t = params$t
  R0 = params$R0
  
  susc <- n - immunized
  
  inf_0<- c(0:(n-immunized))
  
  # This line effectively solves the model for several numbers of inittially infected:
  
  # I will have to remember to add more parameters here every time I add them in the outside function.
  
  out <- cbind.data.frame(
    intially.infected=inf_0,
    t(sapply(inf_0,get.num.expected.test.positive,n=n,immunized=immunized,t=t,R0=R0)))
  
  out <- out %>% 
    mutate(scenario.prob = choose(susc,intially.infected)* p^(intially.infected)*(1-p)^(susc-intially.infected))
  
  prob.of.positive.isolation.group <- as.numeric(out$scenario.prob%*%(out$expected.test.positive>=1))
  expected.infected <- as.numeric(out$scenario.prob%*%(out$infected))
  expected.test.positive <- as.numeric(out$scenario.prob%*%(out$expected.test.positive))

  cbind(
    params,
    data.frame(prob.of.positive.isolation.group, expected.infected, expected.test.positive)
  ) 
  
}


base_entry_model = function() {
  model = list()
  model$model_fn = solve_base_entry
  class(model) = "base_entry"
  model
}



#' Set Parameter
#' 
#' This functions constructs the experimental_parameter object, and appends experimental parameters that will be visible inside the model in the future.
#' Experimental parameters can be either uncertainties or decision levers.
#' Every parameter defined in this function can be accessed within the model by using \code{experimental_parameters$param_name}.
#' 
#' Experimental Parameters are not visible during calibration.
#'
#' @param model the c19model object that has already been calibrated.
#' @param parameter_name charachter string defining the parameter name.
#' @param experimental_design Either "grid" or "lhs" Use lhs if you want to create a Latin Hypercube Sample within the min and max bounds you provided. Use Grid
#' @param values use when experimental_design = "grid". This should be a numeric vector including the values to be included in a grid experimental design.
#' @param min use when experimental_design = "lhs". This should bea numeric value indicating the minimum bound in the Latin Hypercube sample.
#' @param max use when experimental_design = "lhs". This should bea numeric value indicating the minimum bound in the Latin Hypercube sample.
#'
#' @return a c19 model object including the defined experimental parameters.
#' @export
base_entry_set_parameter = function(model, parameter_name, experimental_design, values, min, max) {
  
  # Checking if Parameters make sense.
  assertthat::assert_that(!missing(model), msg = "A base_entry should be provided.")
  
  assertthat::assert_that("base_entry" %in% class(model), msg = "The model should be a base_entry object.")
  
  assertthat::assert_that(is.character(parameter_name), msg = "Parameter Name should be a character string.")
  
  assertthat::assert_that(experimental_design %in% c("lhs", "grid"), msg = "Experimental Design Should be either lhs or grid.")
  
  if(experimental_design == "lhs")  {
    
    assertthat::assert_that(!missing(min) & !missing(max), msg = "min and max parameters should be provided in an lhs sample.")
    
    assertthat::assert_that(missing(values), msg = "Values parameter should not be provided for an LHS sample.")
    
    assertthat::assert_that(min < max, msg = "Minimum value should lower than the maximum value. Use grid to simulate a single value.")
  
    } else if (experimental_design == "grid") {
    
    assertthat::assert_that(missing(min) & missing(max), msg = "min and max parameters should not be provided in a grid sample.")
    
    assertthat::assert_that(!missing(values), msg = "Values parameter should be provided in a grid experimental design.")
    
  }
  
  # If experimental parameters object doesn't exist, create it:
  if(is.null(model$experimental_parameters)) {
    model$experimental_parameters = list()
  }
  
  # The experimental design object is created here as a list aiming to allow us to pass any length of values in parameters that have a "grid" experimental design.
  if(experimental_design == "lhs") {
    
    model$experimental_parameters[[parameter_name]] = list(parameter_name = parameter_name,
                                                           experimental_design = experimental_design,
                                                           min = min,
                                                           max = max)
    
  }
  
  if(experimental_design == "grid") {
    model$experimental_parameters[[parameter_name]] = list(parameter_name = parameter_name,
                                                           experimental_design = experimental_design,
                                                           values = values
                                                           )
    
  }
  
  return(model)
  
}



#' Set Experimental Design
#' 
#' Creates the future_experimental_design data.frame based on the paramers defined by the set_parameter functions. The experimental design created by this function is useful to run a typical RDM analysis where each policy is evaluated across a LHS of deep uncertainties. To achieve that, define each policy lever as a grid parameter, and each uncertainty as an "lhs" uncertainty.
#'
#' @param model The c19model object
#' @param n_new_lhs The number of points in the Latin Hypercube Sample to be created.
#'
#' @return The model object including a future_experimental_design data.frame.
#' @export
#' @importFrom lhs randomLHS
#' @import dplyr
base_entry_set_experimental_design = function(model, n_new_lhs) {
  
  ## Getting a Data.Frame of LHS Parameters
  lhs_params = Filter(f = function(x) x$experimental_design == "lhs", model$experimental_parameters) %>%
    do.call(rbind.data.frame, .)
  
  # Only sample lhs if there is one LHS variable:
  
  if(nrow(lhs_params)>0) {
    lhs_sample <- lhs::randomLHS(n = n_new_lhs, k = nrow(lhs_params)) %>%
      as.data.frame()
    
    names(lhs_sample) = lhs_params$parameter_name
    
    lhs_experiments = list()
    
    for (param in names(lhs_sample)) {
      ### Here: Also could consider other distributions.
      lhs_experiments[[param]] = qunif(p = lhs_sample[,param], min = lhs_params$min[lhs_params$parameter_name == param], max = lhs_params$max[lhs_params$parameter_name == param])  
    }
    
    lhs_experiments = lhs_experiments %>% as.data.frame(.) %>%
      mutate(LHSExperimentID = row_number())  
    
  } else {
    # lhs Experiments is a single experiment with no variable:
    lhs_experiments = data.frame(LHSExperimentID = 1)
  }
  
  
  ## Getting a Data.Frame of Grid Parameters:
  grid_params = Filter(f = function(x) x$experimental_design == "grid", model$experimental_parameters) %>%
    sapply(., function(x) x[3]) %>%
    expand.grid(.)
  
  # If there are no grid parameters, then there's only one point in the grid.
  if(nrow(grid_params)>0){
    grid_params = grid_params %>%
    mutate(GridExperimentID = row_number())
  } else {
    grid_params = data.frame(GridExperimentID = 1)
  }
  
  # Getting Rid of the .values appendix
  names(grid_params) = sub(pattern = '.values',replacement =  '',x = names(grid_params))

  
  experimental_design = expand.grid(lhs_experiments$LHSExperimentID, grid_params$GridExperimentID)
  names(experimental_design) = c("LHSExperimentID", "GridExperimentID")
  
  # Assert that the Names of Alternative tables don't collide.
  
  all_collumns = c(names(lhs_experiments), names(grid_params))
  
  duplicated_names = all_collumns[duplicated(all_collumns)]
  assertthat::assert_that({
    length(duplicated_names)==0  
  }, msg = paste0("The Names of these Parameters are duplicated: ", duplicated_names))
  
  # Defining the Future Runs:
  future_runs = expand.grid(grid_params$GridExperimentID, lhs_experiments$LHSExperimentID)
  names(future_runs) = c("GridExperimentID", "LHSExperimentID")
  
  future_runs = future_runs %>%
    left_join(grid_params, by = "GridExperimentID") %>%
    left_join(lhs_experiments, by = "LHSExperimentID") %>%
    mutate(ExperimentID = row_number())
  
  model$future_experimental_design = future_runs
  
  return(model)
  
}


#' Evaluate Experiments (in Parallel)
#' 
#' This function evaluates experiments in parallel, and can be used to scale model runs vertically and horizontally. You can first define your experiments using the \code{set_parameter} and \code{set_experimental_design} functions. Then, you can save your model object and send it to different servers, if you want. Then, use this function to evaluate the experiments in parallel, while saving results to the ./output_base_entrys folder. These results can be visualized before your complete experiments are ready.
#'
#' @param model The c19model object
#' @param sim_end_date Simulation end date (in the yyyy-mm-dd format, e.g." "2021-01-20")
#' @param runs Vector of Runs to perform (should correspond to ExperimentIDs defined in the future_experimental_design data.frame)
#' @param n_cores Number of CPU cores to use, defaults to total number of cores - 2
#' @param parallel_mode Parallel Cluster type to use. Either "PSOCK" or "FORK". Windows users, use "PSOCK", otherwise, use "FORK"
#' @param solver "lsoda" by default, but could use any deSolve-compatible solver.
#' @param write_csv TRUE if you want to save preliminary results to an ./output_base_entry folder. Make sure this folder exists and is empty.
#'
#' @return a data.frame with simulation results
#' @export
base_entry_evaluate_experiment = function(model, runs, n_cores = parallel::detectCores() - 2, parallel_mode = "PSOCK", write_csv = T, test_run = F) {
  
  # If runs is missing, assume all runs:
  if(missing(runs)) {
    runs = sample(1:nrow(model$future_experimental_design), size = nrow(model$future_experimental_design), replace = F) 
  }
  
  ### Reducing the Model Object Size - This is Important to fully leverage parallelization ###
  cat_green_tick(paste(Sys.time(),"- Hold Tight. Running ", length(runs), "future scenario runs in Parallel with", n_cores, "cores."))
  start_time = Sys.time()
  cat_green_tick(start_time)
  
  if(write_csv) {
    write.csv(x = model$future_experimental_design,file = "./output_base_entry/experimental_design.csv", row.names = F)
  }
  
  if(test_run) {
    cat_green_tick(paste0(Sys.time(), " - Starting Test Run."))
    scenarios_outputs = base_entry_run_experiment(experiment_id = runs[1], model = model)  
  }
  
  cl <- parallel::makeCluster(n_cores, type = parallel_mode)
  set_up_cluster(cluster = cl, model = model, parallel_mode = parallel_mode)
  # Original Apply:
  #scenarios_outputs <- parLapply(cl = cl, X = selected_model$future_runs$ExperimentID,fun = run_future_scenario_rep, selected_model = filtered_model, sim_end_date = sim_end_date, solver = solver)
  # Bcat_green_tick(paste(Sys.time(),"- Running Test experiment."))
  
  # Parallel Implementation:
  # Testing a Single Experiment:
  
  scenarios_outputs <- pbapply::pblapply(cl = cl, X = runs,FUN = base_entry_run_experiment, model = model)
  
  stopCluster(cl)
  
  finish_time = Sys.time()
  
  cat_green_tick(finish_time)
  
  cat_green_tick(paste0(Sys.time(), " - We're done with this simulation. Total time: ", finish_time - start_time, " for ", length(runs), " model runs."))
  
  # Return all runs:
  do.call(rbind, scenarios_outputs)
  
}


#' Runs a Single Experiment
#' 
#' Runs a single Experiment defined by the set_experimental_design function. The experiment_id corresponds to the ExperimentID collumn in the future_experimental_design data.frame
#'
#' @param experiment_id The ExperimentID
#' @param model The c19model object
#' @param sim_end_date Simulation end date (in the yyyy-mm-dd format, e.g." "2021-01-20")
#' @param solver "lsoda" by default, but could use any deSolve-compatible solver.
#' @param ... Additional parameters to be passed to the inner function.
#'
#' @return data.frame with simulation results.
#' @export
base_entry_run_experiment = function(experiment_id, model, write_csv = T) {
  
  future_run = model$future_experimental_design %>%
    dplyr::filter(ExperimentID == experiment_id)
 
  # Solve Model
  results = solve_base_entry(model, future_run)
  results$ExperimentID = experiment_id
  
  # This function executes an user-defined function to process the results. This will replace the "compute augmented outputs" function which is used elsewhere.
  # This allows more flexibility and allows us to tailor the output files for each application we want to have.
  #results = model$compute_experiment_output(results = results, model = model)
  
  if(write_csv) {
    # Trying to generate results as we go, within each core:
    #write.csv(x = results, file = "./output_base_entry/experimental_results.csv", append = T, row.names = F)
    write.table(x = results, file = "./output_base_entry/experimental_results.csv", append = T, row.names = F, sep = ",")
  
  }
  
  results
  
}



set_up_cluster = function(cluster, model, parallel_mode) {
  
  ## Definitive fix to this function will be to export custommodel functions, and if this is a custom Run, run a different clusterExport function.
  #model_fn = model$model_fn
  
  if(parallel_mode == "PSOCK") {
    clusterEvalQ(cluster, library(dplyr))
    clusterEvalQ(cluster, library(igraph))
    # Exportando objetos que preciso ter nos clusters:
    clusterExport(cluster, varlist = list("model",
                                          "solve_base_entry",
                                          "get.num.expected.test.positive"
                                          #"model_fn"
                                          ), envir = environment())
  }
  
}




# Messages Symbols
#' @importFrom cli cat_bullet
#' @export
cat_green_tick <- function(...){
  cat_bullet(
    ..., 
    bullet = "tick", 
    bullet_col = "green"
  )
}

#' @importFrom cli cat_bullet
#' @export
cat_red_bullet <- function(...){
  cat_bullet(
    ..., 
    bullet = "bullet",
    bullet_col = "red"
  )
}

#' @importFrom cli cat_bullet
#' @export
cat_info <- function(...){
  cat_bullet(
    ..., 
    bullet = "arrow_right",
    bullet_col = "grey"
  )
}
