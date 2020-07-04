#! Rscript competitor simulation.R --

#### COMPETITOR PROBLEM SIMULATION ----
# Num DDoS attacks
comp_num_ddos_attacks <- NULL
for (i in 1:K_portfolios_numberof) { # Competitor/targatt_competitor_ddos
  comp_num_ddos_attacks[i] <- numDDoSAttacks(K_portfolios_table_forecast$K_targdos_decision[i])
}
comp_num_ddos_attacks
# DDoS duration per attack
comp_ddos_duration <- NULL
for (i in 1:K_portfolios_numberof) { # Competitor/targatt_competitor_ddos
  comp_ddos_duration[i] <- K_portfolios_table_forecast$duration_forecast[i]
}
comp_ddos_duration

comp_ddos_duration_final <- NULL 
for (i in 1:K_portfolios_numberof) { #  Competitor/targatt_competitor_ddos
  comp_ddos_duration_final[i] <- cloudReduction(K_portfolios_table_forecast$cloud[i],
                                                comp_ddos_duration[i])
}
comp_ddos_duration_final

# Market gain depending of DDoS attacks
comp_market_gain <- NULL
for (i in 1:K_portfolios_numberof) { # Competitor/competitor_impacts
  comp_market_gain[i] <- getMarketGain(K_portfolios_table_forecast$K_targdos_decision[i],
                                       comp_ddos_duration_final[i])
}
# Implementation cost
comp_implementation_cost <- NULL
for (i in 1:K_portfolios_numberof) { # Competitor/competitor_impacts
  comp_implementation_cost[i] <- implementationCost(K_portfolios_table_forecast$K_targdos_decision[i],
                                                    comp_num_ddos_attacks[i],
                                                    comp_ddos_duration_final[i])
}
# Competitor detection
comp_detected <- NULL
for (i in 1:K_portfolios_numberof) { # Competitor/competitor_detection
  comp_detected[i] <- competitorDetection(K_portfolios_table_forecast$K_targdos_decision[i],
                                          comp_num_ddos_attacks[i])
}
# Detection cost
comp_detection_cost <- NULL
for (i in 1:K_portfolios_numberof) { # Competitor/competitor_detection
  comp_detection_cost[i] <- detectionCost(comp_detected[i])
}

# Utility money
comp_utility_money <- NULL
for (i in 1:K_portfolios_numberof) { # Competitor/competitor_utility
  comp_utility_money[i] <- competitorUtilityMoney(comp_market_gain[i],
                                                  comp_detection_cost[i],
                                                  comp_implementation_cost[i])
}
# Utility
comp_utility <- NULL
for (i in 1:K_portfolios_numberof) { # Competitor/competitor_utility
  comp_utility[i] <- competitorUtility(comp_utility_money[i])
}

# Final simulation table
K_portfolio_simulation_forecast <- data.frame(K_portfolios_table_forecast,
                                              comp_num_ddos_attacks,
                                              comp_ddos_duration,
                                              comp_ddos_duration_final,
                                              comp_market_gain,
                                              comp_implementation_cost,
                                              comp_detection_cost,
                                              comp_utility_money,
                                              comp_utility)