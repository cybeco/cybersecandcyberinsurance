#! Rscript competitor simulation.R --

#### COMPETITOR PROBLEM SIMULATION ----
# Num DDoS attacks
comp_num_ddos_attacks <- NULL 
for (i in 1:K_portfolios_numberof) { # Competitor/targatt_competitor_ddos
  comp_num_ddos_attacks[i] <- numDDoSAttacks(K_portfolios_table$K_targdos_decision[i])
}
comp_num_ddos_attacks
# DDoS duration per attack
comp_ddos_duration <- NULL
for (i in 1:K_portfolios_numberof) { # Competitor/targatt_competitor_ddos
  comp_ddos_duration[i] <- ddosDuration(K_portfolios_table$K_targdos_decision[i],
                                        comp_num_ddos_attacks[i],
                                        K_portfolios_table$cloud[i]) # cloud
                                        
}
comp_ddos_duration

comp_ddos_duration_final <- NULL
for (i in 1:K_portfolios_numberof) { #  Competitor/targatt_competitor_ddos
  comp_ddos_duration_final[i] <- cloudReduction(K_portfolios_table$cloud[i],
                                                comp_ddos_duration[i])
}
comp_ddos_duration_final


# Market gain depending of DDoS attacks
comp_market_gain <- NULL
for (i in 1:K_portfolios_numberof) { # Competitor/competitor_impacts
  comp_market_gain[i] <- getMarketGain(K_portfolios_table$K_targdos_decision[i],
                                       comp_ddos_duration_final[i])
}
comp_market_gain
# Implementation cost
comp_implementation_cost <- NULL
for (i in 1:K_portfolios_numberof) { # Competitor/competitor_impacts
  comp_implementation_cost[i] <- implementationCost(K_portfolios_table$K_targdos_decision[i],
                                                    comp_num_ddos_attacks[i],
                                                    comp_ddos_duration_final[i])
}
comp_implementation_cost
# Competitor detection
comp_detected <- NULL
for (i in 1:K_portfolios_numberof) { # Competitor/competitor_detection
  comp_detected[i] <- competitorDetection(K_portfolios_table$K_targdos_decision[i],
                                          comp_num_ddos_attacks[i])
}
comp_detected
# Detection cost
comp_detection_cost <- NULL
for (i in 1:K_portfolios_numberof) { # Competitor/competitor_detection
  comp_detection_cost[i] <- detectionCost(comp_detected[i])
}
comp_detection_cost
# Utility money
comp_utility_money <- NULL
for (i in 1:K_portfolios_numberof) { # Competitor/competitor_utility
  comp_utility_money[i] <- competitorUtilityMoney(comp_market_gain[i],
                                       comp_detection_cost[i],
                                       comp_implementation_cost[i])
}
comp_utility_money
# Utility
comp_utility <- NULL
for (i in 1:K_portfolios_numberof) { # Competitor/competitor_utility
  comp_utility[i] <- competitorUtility(comp_utility_money[i])
}
comp_utility
# Final simulation table
K_portfolio_simulation <- data.frame(K_portfolios_table,
                                     comp_num_ddos_attacks,
                                     comp_ddos_duration,
                                     comp_ddos_duration_final,
                                     comp_market_gain,
                                     comp_implementation_cost,
                                     comp_detection_cost,
                                     comp_utility_money,
                                     comp_utility)
K_portfolio_simulation