library(simmer)
library(magrittr)
library(parallel)

#################################################################################################################################
################################################# PART A ########################################################################
#################################################################################################################################

# First run for 7, 8 and 9 ambulances and compare results for how many runs ended with not waiting time.

for (v in 1:3) {
  seeds <- c(1541, 1625, 1365, 1785, 1521, 1451, 1121, 1681, 1781, 1411, 1321, 1544, 1521, 1235, 1327,1000)
  AMBULANCE_NUMBER <- 6 + v
  result <- mclapply(seeds, function(the_seed) {
    set.seed(the_seed)
    
    hospital <- simmer()
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
    c(sum(table$waiting_time))
  }) %>% unlist()
  result
  print(paste("On 16 runs all the demand was cover with ", AMBULANCE_NUMBER," ambulances on ", sum(result == 0), " times"))
}

#################################################################################################################################
################################################# PART B ########################################################################
#################################################################################################################################

# Run for 1 ambulance and analyse if 1 ambulance can support the entire calls.

seeds <- c(1541, 1625, 1365, 1785, 1521, 1451, 1121, 1681, 1781, 1411, 1321, 1544, 1521, 1235, 1327,1000)
AMBULANCE_NUMBER <- 1
result <- mclapply(seeds, function(the_seed) {
  set.seed(the_seed)
  
  hospital <- simmer()
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
  c(sum(table$waiting_time))
}) %>% unlist()
result
print(paste("On 16 runs all the demand was cover with ", AMBULANCE_NUMBER," ambulances on ", sum(result == 0), " times"))

#################################################################################################################################
################################################# PART C ########################################################################
#################################################################################################################################

# Run for 1, 2, 3 and 4 ambulances and compare stadistics.

AMBULANCE_NUMBER <- 1
seeds <- c(1541, 1625, 1365, 1785, 1521, 1451, 1121, 1681, 1781, 1411, 1321, 1544, 1521, 1235, 1327,1000)
result <- mclapply(seeds, function(the_seed) {
  set.seed(the_seed)
  
  hospital <- simmer()
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
  c(mean(table$waiting_time), sum(table$waiting_time != 0) / 500, sum(table$activity_time) / table$end_time[length(table$end_time)])
}) %>% unlist()
result
table_result <- matrix(result,ncol=3,byrow=TRUE) 
print(paste("Mean waiting time: ", mean(table_result[, 1]), " Mean percetage of calls that must wait: ", mean(table_result[, 2]) * 100, 
            " Mean activity time: ", mean(table_result[, 3]) * 100))
result_arr <- c(AMBULANCE_NUMBER, mean(table_result[, 1]), mean(table_result[, 2]) * 100, mean(table_result[, 3]) * 100)

AMBULANCE_NUMBER <- 2
seeds <- c(1541, 1625, 1365, 1785, 1521, 1451, 1121, 1681, 1781, 1411, 1321, 1544, 1521, 1235, 1327,1000)
result <- mclapply(seeds, function(the_seed) {
  set.seed(the_seed)
  
  hospital <- simmer()
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
  c(mean(table$waiting_time), sum(table$waiting_time != 0) / 500, sum(table$activity_time) / table$end_time[length(table$end_time)])
}) %>% unlist()
result
table_result <- matrix(result,ncol=3,byrow=TRUE) 
print(paste("Mean waiting time: ", mean(table_result[, 1]), " Mean percetage of calls that must wait: ", mean(table_result[, 2]) * 100, 
            " Mean activity time: ", mean(table_result[, 3]) * 100))
result_arr <- c(result_arr, c(AMBULANCE_NUMBER, mean(table_result[, 1]), mean(table_result[, 2]) * 100, mean(table_result[, 3]) * 100))

AMBULANCE_NUMBER <- 3
seeds <- c(1541, 1625, 1365, 1785, 1521, 1451, 1121, 1681, 1781, 1411, 1321, 1544, 1521, 1235, 1327,1000)
result <- mclapply(seeds, function(the_seed) {
  set.seed(the_seed)
  
  hospital <- simmer()
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
  c(mean(table$waiting_time), sum(table$waiting_time != 0) / 500, sum(table$activity_time) / table$end_time[length(table$end_time)])
}) %>% unlist()
result
table_result <- matrix(result,ncol=3,byrow=TRUE) 
print(paste("Mean waiting time: ", mean(table_result[, 1]), " Mean percetage of calls that must wait: ", mean(table_result[, 2]) * 100, 
            " Mean activity time: ", mean(table_result[, 3]) * 100))

result_arr <- c(result_arr, c(AMBULANCE_NUMBER, mean(table_result[, 1]), mean(table_result[, 2]) * 100, mean(table_result[, 3]) * 100))

AMBULANCE_NUMBER <- 4
seeds <- c(1541, 1625, 1365, 1785, 1521, 1451, 1121, 1681, 1781, 1411, 1321, 1544, 1521, 1235, 1327,1000)
result <- mclapply(seeds, function(the_seed) {
  set.seed(the_seed)
  
  hospital <- simmer()
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
  c(mean(table$waiting_time), sum(table$waiting_time != 0) / 500, sum(table$activity_time) / table$end_time[length(table$end_time)])
}) %>% unlist()
result
table_result <- matrix(result,ncol=3,byrow=TRUE) 
print(paste("Mean waiting time: ", mean(table_result[, 1]), " Mean percetage of calls that must wait: ", mean(table_result[, 2]) * 100, 
            " Mean activity time: ", mean(table_result[, 3]) * 100))

result_arr <- c(result_arr, c(AMBULANCE_NUMBER, mean(table_result[, 1]), mean(table_result[, 2]) * 100, mean(table_result[, 3]) * 100))
table_result <- matrix(result_arr,ncol=4,byrow=TRUE)
table_result
colnames(table_result) <- c("Ambulance Number", "Mean waiting time", "Mean percetage of calls that must wait", "Mean activity time")
table_result <- as.data.frame.matrix(table_result)
range <- c(paste("[ ",toString(min(table_result$"Ambulance Number"))," , ",toString(max(table_result$"Ambulance Number"))," ]"),
           paste("[ ",toString(min(table_result$"Mean waiting time"))," , ",toString(max(table_result$"Mean waiting time"))," ]"),
           paste("[ ",toString(min(table_result$"Mean percetage of calls that must wait"))," , ",toString(max(table_result$"Mean percetage of calls that must wait"))," ]"),
           paste("[ ",toString(min(table_result$"Mean activity time"))," , ",toString(max(table_result$"Mean activity time"))," ]"))

sd <- c(sd(table_result$"Ambulance Number"), 
        sd(table_result$"Mean waiting time"), 
        sd(table_result$"Mean percetage of calls that must wait"), 
        sd(table_result$"Mean activity time"))
table_result <- rbind(table_result, range)
table_result <- rbind(table_result, sd)
rownames(table_result) <- c("1", "2", "3", "4", "range", "standard deviation")
table_result
