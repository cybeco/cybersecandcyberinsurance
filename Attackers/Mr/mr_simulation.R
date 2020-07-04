#! Rscript mr simulation.R --

#### Modern Republic PROBLEM SIMULATION ----

## ATTACKS ##
# DDoS
# Num ddos attacks
mr_num_ddos_attacks <- NULL 
for (i in 1:M_portfolios_numberof) { # Mr/targatt_mr_ddos_malware
  mr_num_ddos_attacks[i] <- numAttacksMr(M_portfolios_table$M_targdos_decision[i])
}
mr_num_ddos_attacks
# DDoS duration
mr_ddos_duration <- NULL
for (i in 1:M_portfolios_numberof) { # Mr/targatt_mr_ddos_malware
  mr_ddos_duration[i] <- ddosDurationMr(M_portfolios_table$M_targdos_decision[i],
                                        mr_num_ddos_attacks[i],
                                        M_portfolios_table$cloud[i])
}
mr_ddos_duration
# Social Enginerring
# Number of exfiltration records
mr_num_records_exf <- NULL
for (i in 1:M_portfolios_numberof) { # Mr/targatt_mr_ddos_social_engineering
  mr_num_records_exf[i] <- exfAttackMr(M_portfolios_table$M_targsocial_engineering_decision[i],
                                       M_portfolios_table$cloud[i])
}
mr_num_records_exf
# Number of exfiltration business records
mr_num_business_records_exf <- NULL
for (i in 1:M_portfolios_numberof) { # Mr/targatt_mr_ddos_social_engineering
  mr_num_business_records_exf[i] <- exfBusinessAttackMr(M_portfolios_table$M_targsocial_engineering_decision[i],
                                                        M_portfolios_table$cloud[i])
}
mr_num_business_records_exf

## IMPACTS ##
# DDoS gain per number of hours
mr_gain_ddos <- NULL
for (i in 1:M_portfolios_numberof) { # Mr/mr_impacts
  mr_gain_ddos[i] <- getMarketGainDDoSMr(M_decision_portfolios$M_targdos_decision[i],
                                         mr_ddos_duration[i])
}
mr_gain_ddos
# Gain of num exfiltration records
mr_gain_exf_records <- NULL
for (i in 1:M_portfolios_numberof) { # Mr/mr_impacts
  mr_gain_exf_records[i] <- exfRecordsGainMr(M_portfolios_table$M_targsocial_engineering_decision[i],
                                             mr_num_records_exf[i])
}
mr_gain_exf_records
# Gain of num exfiltration business records
mr_gain_exf_business_records <- NULL
for (i in 1:M_portfolios_numberof) { # Mr/mr_impacts
  mr_gain_exf_business_records[i] <- exfBusinessRecordsGainMr(M_portfolios_table$M_targsocial_engineering_decision[i],
                                                              mr_num_business_records_exf[i])
}
mr_gain_exf_business_records
# Mr detection
mr_detected <- NULL
for (i in 1:M_portfolios_numberof) { # Mr/mr_detection
  mr_detected[i] <- detectionMr(M_portfolios_table$M_targdos_decision[i],
                                M_portfolios_table$M_targsocial_engineering_decision[i],
                                 mr_num_ddos_attacks[i])
}
mr_detected
# Detection cost
mr_detection_cost <- NULL
for (i in 1:M_portfolios_numberof) { # Mr/mr_detection
  mr_detection_cost[i] <- detectionCostMr(mr_detected[i])
}
mr_detection_cost
## UTILITY ## 
# Utility money
mr_utility_money <- NULL
for (i in 1:M_portfolios_numberof) { # Mr/mr_utility
  mr_utility_money[i] <- utilityMoneyMr(mr_gain_ddos[i],
                                        mr_gain_exf_records[i],
                                        mr_gain_exf_business_records[i],
                                        mr_detection_cost[i])
}
mr_utility_money
# Utility
mr_utility <- NULL
for (i in 1:M_portfolios_numberof) { # Mr/mr_utility
  mr_utility[i] <- utilityMr(mr_utility_money[i])
}
mr_utility
# Final simulation table
M_portfolio_simulation <- data.frame(M_portfolios_table,
                                     mr_num_ddos_attacks,
                                     mr_num_records_exf,
                                     mr_num_business_records_exf,
                                     mr_gain_ddos,
                                     mr_gain_exf_records,
                                     mr_gain_exf_business_records,
                                     mr_detection_cost,
                                     mr_utility_money,
                                     mr_utility)
M_portfolio_simulation
