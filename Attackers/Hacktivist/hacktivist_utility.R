#! Rscript Hacktivist/hacktivist_utility.R --

#### HACKTIVIST UTILITY ----
# Utility money
utilityMoneyHacktivist <- function(downtime_ddos_gain,
                                   detection_cost, 
                                   implementation_cost){
 hacktivist_utility_money = 0
 hacktivist_utility_money = downtime_ddos_gain - detection_cost - implementation_cost
 hacktivist_utility_money
}
# Utility
utilityHacktivist <- function(hacktivist_utility_money){
  hacktivist_utility <- 0
  hacktivist_utility = 1-utility_coef_exp*(1+exp(utility_rho*(hacktivist_utility_money)))
  hacktivist_utility
}