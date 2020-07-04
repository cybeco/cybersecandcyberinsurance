#! Rscript competitor_utility.R --

#### COMPETITOR UTILITY ----
# Utility money
competitorUtilityMoney <- function(market_gain, 
                                  detection_cost, 
                                  implementation_cost){
 competitor_utility_money = 0
 competitor_utility_money = market_gain - detection_cost - implementation_cost
 competitor_utility_money
}

# Utility
competitorUtility <- function(competitor_utility_money){
  competitor_utility <- 0
  competitor_utility = 1-utility_coef_exp*(1+exp(utility_rho*(competitor_utility_money)))
  competitor_utility
}