#! Rscript mr_impacts.R --

# IMPACTS: Modern Republic want to produce DDoS (downtime) and exfiltration

# Market share gain (millions) due to DDoS attack 
getMarketGainDDoSMr <- function (targdos_result,
                                 ddos_duration) { # (l)
  market_gain_ddos <- 0
  if (impacts_to_market_share_included == FALSE) {0}
  else if (impacts_to_market_share_included == TRUE){
    lost_rate <- 0
    market_gain_ddos <- 0
    if (targdos_result == 1) {
      l <- ddos_duration # hours down down
      R <- runif(1,0.0026,0.0042) # uncertainty
      lost_rate <- min(0.5,l*R)
      market_gain_ddos <- (15000000) * lost_rate # (15.000.000/2=7.500.00)--> 50% market
    }
  } else {cat("Error in impacts DDoS")}
  market_gain_ddos
}
# Exfiltrated records gain (dollars per num_exf_records)
exfRecordsGainMr <- function(targexf_result,
                             num_exf_records){
  exfiltrated_records_gain <- 0
  if (impacts_to_records_exposed_included == FALSE) {0}
  else if (impacts_to_records_exposed_included == TRUE){
    if(targexf_result==1){
      gain_per_record = runif(1,0.8*825,1.2*825)
      exfiltrated_records_gain = num_exf_records*gain_per_record
      round(exfiltrated_records_gain)
    }
  } else {cat("Error in mr impact exfiltrated records")}
  exfiltrated_records_gain
}
# Exfiltrated business records gain (dollars per num_exf_records)
exfBusinessRecordsGainMr <- function(targexf_business_result,
                                    num_exf_business_records){
  exfiltrated_business_records_gain <- 0
  if (impacts_to_records_exposed_included == FALSE) {0}
  else if (impacts_to_records_exposed_included == TRUE){
    if(targexf_business_result==1){
      gain_per_business_record = runif(1,0.8*3000,1.2*3000)
      exfiltrated_business_records_gain = num_exf_business_records*gain_per_business_record
      round(exfiltrated_business_records_gain)
    }
  } else {cat("Error in mr impact exfiltrated business records")}
  exfiltrated_business_records_gain
}