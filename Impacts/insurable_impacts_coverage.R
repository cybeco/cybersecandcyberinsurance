#! Rscript Impacts/insurable_impacts_coverage.R --

#### INSURANCE COVERAGE ----
# Equipment
equipmentCoverage <- function (imp_equipment, # cost equipment damage
                               conventional,
                               cyber1,
                               cyber2){
  cov_equipment <- 0
  if(conventional == 0){0}
  else if(conventional == 1){
    cov_equipment <- imp_equipment*0.70
  }
  round(cov_equipment,2)
}
# Market share
marketShareCoverage <- function(imp_market_share, # cost market share damage
                                conventional,
                                cyber1,
                                cyber2){
  cov_market_share <- 0
  if (cyber1 ==0 & cyber2==0){0}
    else if (cyber1 == 1 | cyber2 == 1){
    cov_market_share <- imp_market_share*0.50
    }
  round(cov_market_share,2)
}
# Availability
availabilityCoverage <- function(imp_availability, # cost per availability
                                 conventional,
                                 cyber1,
                                 cyber2){
  cov_availability <- 0
  if (cyber2 == 0){0}
  else if (cyber2 == 1){
    cov_availability <- imp_availability*0.50
  }
  round(cov_availability,2)
}
# Pii records
piiRecordsCoverage <- function(imp_piiRecords, # cost pii records
                               conventional,
                               cyber1,
                               cyber2){
  cov_pii_records <- 0
  if (cyber1 == 0 & cyber2 == 0){0}
  else if(cyber1 == 1 | cyber2 == 1){
    cov_pii_records <- imp_piiRecords*0.30
  }
  round(cov_pii_records,2)
}
# Business info
businessRecordsCoverage <- function(imp_bussines_info, # cost business info
                                    conventional, 
                                    cyber1,
                                    cyber2){
  cov_business_info <- 0
  if (cyber1 == 0 & cyber2 == 0){0}
  else if (cyber1 == 1 | cyber2 == 1){
    cov_business_info <- imp_bussines_info*0.30
  }
  round(cov_business_info,2)
}