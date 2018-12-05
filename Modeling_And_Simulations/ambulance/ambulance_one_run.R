library(simmer)
library(magrittr)
library(parallel)

# example for only one run of ambulance exercise.

set.seed(1541)
hospital <- simmer()
AMBULANCE_NUMBER <- 1
call_1 <- 
  trajectory("Call Trajectory 1") %>% 
    set_attribute("strat_time_1", function (){now(hospital)}) %>%
    set_attribute("activity_time_1", function (){runif(1, 10, 14)}) %>%
    seize("ambulance") %>%
    timeout(function() {get_attribute(hospital, "activity_time_1")}) %>%
    release("ambulance")

call_2 <- 
  trajectory("Call Trajectory 2") %>% 
  set_attribute("strat_time_2", function (){now(hospital)}) %>%
  set_attribute("activity_time_2", function (){runif(1, 20, 30)}) %>%
  seize("ambulance") %>%
  timeout(function() {get_attribute(hospital, "activity_time_2")}) %>%
  release("ambulance")

call_3 <- 
  trajectory("Call Trajectory 3") %>% 
  set_attribute("strat_time_3", function (){now(hospital)}) %>%
  set_attribute("activity_time_3", function (){runif(1, 10, 30)}) %>%
  seize("ambulance") %>%
  timeout(function() {get_attribute(hospital, "activity_time_3")}) %>%
  release("ambulance")

hospital <-
  simmer("hospital") %>%
  add_resource("ambulance", AMBULANCE_NUMBER) %>%
  add_generator("call_1", call_1, function() {c(0, runif(74, 5, 25), -1)}) %>%
  add_generator("call_2", call_2, function() {c(runif(63, 5, 25), -1)}) %>%
  add_generator("call_3", call_3, function() {c(runif(362, 5, 25), -1)})

hospital %>% run(until = 100000000000)
table <-
  hospital %>%
  get_mon_arrivals %>%
  dplyr::mutate(waiting_time = end_time - start_time - activity_time)
table
