library(simmer)
library(magrittr)
library(parallel)

# 16 runs of pier exercise.

seeds <- c(393943, 100005, 777999555, 319999772, 4544, 55454, 5468, 6554, 7945, 545121, 7455, 554, 78955, 232554, 58515, 54955)
result <- mclapply(seeds, function(the_seed) {
set.seed(the_seed)
  
pier <- simmer() %>%
  add_resource("crane", 2)

# Create Trajeectory Boat with 3 subtrajectories, one when there are not boats on servers, 
# another when there are only one and a third one when both servers are busy

boat <- trajectory() %>%
  branch(option = function() get_server_count(pier, "crane") + 1, continue = c(T, T, T),
         
         trajectory("Boat Trajectory 1") %>%
           trap("WARNING", 
                handler = trajectory() %>%
                  timeout(function(){  (get_attribute(pier, "activity_time1") - now(pier)) * 2  })
                
           ) %>%
           set_attribute("strat_time1", function (){now(pier)}) %>%
           set_attribute("multiplier1", function (){1 / 2}) %>%
           set_attribute("activity_time1", function (){get_attribute(pier, "multiplier1") * runif(1, 0.5, 1.5)}) %>%
           seize("crane") %>%
           timeout(function() {get_attribute(pier, "activity_time1")}) %>%
           release("crane") %>%
           log_("finishing trajectory number 1"),
         
         trajectory("Boat Trajectory 2") %>% 
           send("WARNING") %>%
           set_attribute("strat_time2", function (){now(pier)}) %>%
           set_attribute("multiplier2", function (){1}) %>%
           set_attribute("activity_time2", function (){get_attribute(pier, "multiplier2") * runif(1, 0.5, 1.5)}) %>%
           seize("crane") %>%
           timeout(function() {get_attribute(pier, "activity_time2")}) %>%
           release("crane") %>%
           log_("finishing trajectory number 2"),
         
         trajectory("Boat Trajectory 3") %>% 
           set_attribute("strat_time3", function (){now(pier)}) %>%
           set_attribute("multiplier3", function (){1}) %>%
           set_attribute("activity_time3", function (){get_attribute(pier, "multiplier3") * runif(1, 0.5, 1.5)}) %>%
           seize("crane") %>%
           timeout(function() {get_attribute(pier, "activity_time3")}) %>%
           release("crane") %>%
           log_("finishing trajectory number 3")
  )

pier <-
  simmer("pier") %>%
  add_resource("crane", 2) %>%
  add_generator("boat", boat, function() {c(0, rexp(9, 1/1.25), -1)})

pier %>% run(until = 90)
table <-
  pier %>%
  get_mon_arrivals %>%
  dplyr::mutate(waiting_time = end_time - start_time - activity_time)
table

c(sum(table$finished), mean(table$waiting_time), max(table$waiting_time), min(table$waiting_time), mean(table$activity_time), max(table$activity_time), min(table$activity_time))
}) %>% unlist()
result
table_result <- matrix(result,ncol=7,byrow=TRUE)
colnames(table_result) <- c("Number of Boats", 
                            "Mean waiting time", "Maximum waiting time", 
                            "Minimum waiting time", "Mean download time", 
                            "Maximum download time", "Minimum download time")
table_result <- as.table(table_result)

# Table of results.
table_result <- as.data.frame.matrix(table_result)
range <- c(paste("[ ",toString(min(table_result$"Number of Boats"))," , ",toString(max(table_result$"Number of Boats"))," ]"),
                                      paste("[ ",toString(min(table_result$"Mean waiting time"))," , ",toString(max(table_result$"Mean waiting time"))," ]"),
                                      paste("[ ",toString(min(table_result$"Maximum waiting time"))," , ",toString(max(table_result$"Maximum waiting time"))," ]"),
                                      paste("[ ",toString(min(table_result$"Minimum waiting time"))," , ",toString(max(table_result$"Minimum waiting time"))," ]"),
                                      paste("[ ",toString(min(table_result$"Mean download time"))," , ",toString(max(table_result$"Mean download time"))," ]"),
                                      paste("[ ",toString(min(table_result$"Maximum download time"))," , ",toString(max(table_result$"Maximum download time"))," ]"),
                                      paste("[ ",toString(min(table_result$"Minimum download time"))," , ",toString(max(table_result$"Minimum download time"))," ]"))

sd <- c(sd(table_result$"Number of Boats"), 
                                      sd(table_result$"Mean waiting time"), 
                                      sd(table_result$"Maximum waiting time"), 
                                      sd(table_result$"Minimum waiting time"), 
                                      sd(table_result$"Mean download time"), 
                                      sd(table_result$"Maximum download time"), 
                                      sd(table_result$"Minimum download time"))
table_result <- rbind(table_result, range)
table_result <- rbind(table_result, sd)
rownames(table_result) <- c("1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "range", "standard deviation")
