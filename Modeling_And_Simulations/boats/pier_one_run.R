library(simmer)
library(magrittr)
library(parallel)

set.seed(132432)
pier <- simmer() %>%
        add_resource("crane", 2)

boat <- trajectory() %>%
    branch(option = function() get_server_count(pier, "crane") + 1, continue = c(T, T, T),
           
      trajectory("Boat Trajectory 1") %>%
        trap("WARNING", 
             handler = trajectory() %>%
             timeout(function(){  (get_attribute(pier, "activity_time1") - now(pier)) * 2  })
          
        ) %>%
        set_attribute("strat_time1", function (){now(pier)}) %>%
        set_attribute("multiplier1", function (){1 / 2}) %>%
        set_attribute("activity_time1", function (){get_attribute(pier, "multiplier1") * 10}) %>%
        seize("crane") %>%
        timeout(function() {get_attribute(pier, "activity_time1")}) %>%
        release("crane") %>%
        log_("finishing trajectory number 1"),
      
      trajectory("Boat Trajectory 2") %>% 
        send("WARNING") %>%
        set_attribute("strat_time2", function (){now(pier)}) %>%
        set_attribute("multiplier2", function (){1}) %>%
        set_attribute("activity_time2", function (){get_attribute(pier, "multiplier2") * 10}) %>%
        seize("crane") %>%
        timeout(function() {get_attribute(pier, "activity_time2")}) %>%
        release("crane") %>%
        log_("finishing trajectory number 2"),
      
      trajectory("Boat Trajectory 3") %>% 
        set_attribute("strat_time3", function (){now(pier)}) %>%
        set_attribute("multiplier3", function (){1}) %>%
        set_attribute("activity_time3", function (){get_attribute(pier, "multiplier3") * 10}) %>%
        seize("crane") %>%
        timeout(function() {get_attribute(pier, "activity_time3")}) %>%
        release("crane") %>%
        log_("finishing trajectory number 3")
  )

pier <-
  simmer("pier") %>%
  add_resource("crane", 2) %>%
  add_generator("boat", boat, function() {c(0, 2, 5, 12, 14, -1)})

pier %>% run(until = 90)
table <-
  pier %>%
  get_mon_arrivals %>%
  dplyr::mutate(waiting_time = end_time - start_time - activity_time)
table

