#! Rscript Impacts/non_insurable_impacts.R --

#### NON INSURABLE IMPACTS ----
# Misconfiguration
impactNonInsurableMisconfiguration <- function(misconfig,secconfig){
  impact_misconfig_physical <- 0
  impact_misconfig_pii <- 0
  impact_misconfig_business_records <- 0
  # Impacts on computers and servers (physical impact)
  if (misconfig == 1){
    if (secconfig == 1){
      impact_misconfig_physical = ((asset_num_computers * 400) + (asset_num_servers * 1200))*0.6 # replacement
    }else{
      impact_misconfig_physical = (asset_num_computers * 400) + (asset_num_servers * 1200)       # replacement
    }
    # Impact PII
    exf_records = round(runif(1,0,total_records_pii)) # [0, ..., 200.000]
    num_records = round(0.1243*exf_records)
    impact_misconfig_pii =  num_records * pii_cost_record
    # Impact business records
    exf_records = round(runif(1,0,total_records_business)) # [0,..., 66.000]
    num_records = round(0.4*exf_records)
    impact_misconfig_business_records =  (num_records * pii_cost_business_record)
  }
  impact_misconfig_physical + impact_misconfig_pii + impact_misconfig_business_records
}

# Computer virus
impactVirusNonInsurable <- function(num_virus_pc){
  impact_virus_in_user <- 0
  impact_virus_pii <- 0
  impact_virus_business_records <- 0
  
  if (num_virus_pc>0){
    # Impact in user
    cost_employee_per_hour = 20 # cost of the employees $/hour
    usage_affected = 28 # hours
    time_loss = runif(1,0,0.05)
    impact_virus_in_user = feature_employees_num * cost_employee_per_hour * usage_affected * time_loss
    # Impact in pii
    exf_records = round(runif(1,0,total_records_pii)) # [0, ..., 200.000]
    num_records = round(0.1243*exf_records)
    impact_virus_pii =  num_records * pii_cost_record
    # Impact in business records
    exf_records = round(runif(1,0,total_records_business)) # [0,..., 66.000]
    num_records = round(0.4*exf_records)
    impact_virus_business_records =  (num_records * pii_cost_business_record)
  }
  impact_virus_in_user + impact_virus_pii + impact_virus_business_records 
}