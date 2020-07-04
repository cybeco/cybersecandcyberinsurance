#! Rscript Mr/mr_utility.R --

#### Modern Republic UTILITY ----
# Utility money
utilityMoneyMr <- function(downtime_ddos_gain,
                           exfiltration_records_gain,
                           exfiltration_business_records_gain,
                           detection_cost){
 mr_utility_money = 0
 mr_utility_money = downtime_ddos_gain  + exfiltration_records_gain + exfiltration_business_records_gain
                    - detection_cost
 mr_utility_money
}
# Utility
utilityMr <- function(mr_utility_money){
  mr_utility <- 0
  mr_utility = 1-utility_coef_exp*(1+exp(utility_rho*(mr_utility_money)))
  mr_utility
}