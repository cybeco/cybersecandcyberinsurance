#! Rscript hacktivist_simulation_forecast.R --

#### HACKTIVIST FORECAST PROBLEM SIMULATION ----

## ATTACKS ##
# Num DDoS attacks
hacktivist_num_ddos_attacks <- NULL
for (i in 1:H_portfolios_numberof) { # Hacktivist/targatt_hacktivist_ddos
  hacktivist_num_ddos_attacks[i] <- numDDoSAttacks(H_portfolios_table_forecast$H_targdos_decision[i])
}
# DDoS duration
hacktivist_ddos_duration <- NULL
for (i in 1:H_portfolios_numberof) { # Hacktivist/targatt_hacktivist_ddos
  hacktivist_ddos_duration[i] <- H_portfolios_table_forecast$duration_forecast[i]
}

hacktivist_ddos_duration_final <- NULL
for (i in 1:H_portfolios_numberof) {
  hacktivist_ddos_duration_final[i] <- cloudReduction(H_portfolios_table_forecast$cloud[i],
                                                      hacktivist_ddos_duration[i])
}

## IMPACTS ##
# DDoS gain per number of hours
hacktivist_gain_ddos <- NULL
for (i in 1:H_portfolios_numberof) { # Hacktivist/hacktivist_impacts
  hacktivist_gain_ddos[i] <- ddosUnavailabilityGainHacktivist(H_portfolios_table_forecast$H_targdos_decision[i],
                                                              hacktivist_ddos_duration_final[i])
}
# Hacktivist detection
hacktivist_detected <- NULL
for (i in 1:H_portfolios_numberof) { # Hacktivist/hacktivist_detection
  hacktivist_detected[i] <- detectionHacktivist(H_portfolios_table_forecast$H_targdos_decision[i])
}
# Detection cost
hacktivist_detection_cost <- NULL
for (i in 1:H_portfolios_numberof) { # Hacktivist/hacktivist_detection
  hacktivist_detection_cost[i] <- detectionCost(hacktivist_detected[i])
}
# Implementation cost
hacktivist_implementation_cost <- NULL
for (i in 1:H_portfolios_numberof) { # Hacktivist/hacktivist_impacts
  hacktivist_implementation_cost[i] <- implementationCostHacktivist(H_portfolios_table_forecast$H_targdos_decision[i],
                                                                    hacktivist_num_ddos_attacks[i],
                                                                    hacktivist_ddos_duration_final[i])
}

## UTILITY ## 
# Utility money
hacktivist_utility_money <- NULL
for (i in 1:H_portfolios_numberof) { # Hacktivist/hacktivist_utility
  hacktivist_utility_money[i] <- utilityMoneyHacktivist(hacktivist_gain_ddos[i],
                                                        hacktivist_detection_cost[i],
                                                        hacktivist_implementation_cost[i])
}
# Utility
hacktivist_utility <- NULL
for (i in 1:H_portfolios_numberof) { # Hacktivist/hacktivist_utility
  hacktivist_utility[i] <- utilityHacktivist(hacktivist_utility_money[i])
}

# Final simulation table
H_portfolio_simulation_forecast <- data.frame(H_portfolios_table_forecast,
                                              hacktivist_num_ddos_attacks,
                                              hacktivist_ddos_duration,
                                              hacktivist_ddos_duration_final,
                                              hacktivist_gain_ddos,
                                              hacktivist_detection_cost,
                                              hacktivist_implementation_cost,
                                              hacktivist_utility_money,
                                              hacktivist_utility)