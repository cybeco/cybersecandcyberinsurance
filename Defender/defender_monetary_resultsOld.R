#! Rscript Defender/defender_monetary_results.R --

#### DEFENDER UTILITY ----

# Function that models the defender utility
defenderMonResults <- function(total_monetary_impacts,
                               total_coverage,
                               security_insurance_cost) {
  defender_monetary_results <- (feature_turnover_money - total_monetary_impacts) + 
                               (total_coverage - security_insurance_cost)
  cat("\n Defender monetary results: ", defender_monetary_results)
  defender_monetary_results
}

# d_defenderMonResults <- function(total_monetary_impacts,
#                                total_coverage,
#                                security_insurance_cost) {
#   defender_monetary_results <- feature_turnover_money - total_monetary_impacts + total_coverage - security_insurance_cost
#   defender_monetary_results
# }