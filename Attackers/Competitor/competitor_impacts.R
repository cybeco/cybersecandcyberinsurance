#! Rscript competitor_impacts.R --

# IMPACTS: DAMAGE TO Market share

#### IMPACTS: DDoS ----
# Market share gain (m)
getMarketGain <- function (targdos_result,
                           ddos_duration) { # (l)
  market_gain <- 0
  if (impacts_to_market_share_included == FALSE) {0}
  else if (impacts_to_market_share_included == TRUE){
    lost_rate <- 0
    market_gain <- 0
    if (targdos_result == 1) {
      l <- ddos_duration # hours down down
      R <- runif(1,0.0026,0.0042) # uncertainty
      lost_rate <- min(0.5,l*R)
      market_gain <- (15000000) * lost_rate # (15.000.000/2=7.500.00)--> 50% market
    }
    
  } else {cat("Error in competitor impacts DDoS")}
  market_gain
}

# Implementation costs (c_i)
implementationCost <- function(targdos_result, num_attacks, ddos_duration) {
  implementation_cost <- 0
  if (impacts_to_market_share_included == FALSE) {0}
  else if (impacts_to_market_share_included == TRUE){
    if (targdos_result == 1 & num_attacks>0) {
        implementation_cost = implementation_cost + (33*ddos_duration)
    }
  }
  implementation_cost
}