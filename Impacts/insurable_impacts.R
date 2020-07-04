#! Rscript insurable_impacts.R --

#### INSURABLE IMPACTS ####
# (it affets at non targetted threats(fire,flood,employee error,misconfiguration,virus,ransomware)
# EQUIPMENT
impactEquipment <- function (envthreat_fire,         # simulated in defender_simulation.R
                             envthreat_flood,        # simulated in defender_simulation.R
                             num_computers_infected, # Threats/ntathreats.R (by virus)
                             num_servers_infected,   # Threats/ntathreats.R (by virus)
                             sprk,                   # fire protection
                             fd){                    # flood doors
  imp_equipment_fire = 0
  imp_equipment_flood = 0
  imp_equipment_misconfig = 0
  imp_equipment_virus = 0
  if (impacts_to_equipment_included == FALSE & envthreat_fire == 0 
                                             & envthreat_flood == 0 
                                             & num_computers_infected == 0
                                             & num_servers_infected == 0) {0}
  else if (impacts_to_equipment_included == TRUE) {
    
    # FIRE
    fire_duration <- 0
    if (envthreat_fire >0 & envthreat_flood < 1 & sprk > 0) {
      fire_duration <- rtriang(1,.8,63,10) # Tri(0.8,63,10)
    } else if (envthreat_fire > 0 & envthreat_flood < 1 & sprk < 1) {
      fire_duration <- rgamma(1,.85,.011) # Gamma(0.85,0.011)
    }
    if (fire_duration > 120){ # minutes
        imp_equipment_computers = asset_num_computers * 400 # $400/computer
        imp_equipment_servers = asset_num_servers * 1200    # $1200/server
        imp_equipment_fire = imp_equipment_computers + imp_equipment_servers
    }else if(fire_duration > 0){ # minutes
        imp_equipment_computers = asset_num_computers * 200 # $200/computer repairement
        imp_equipment_servers = asset_num_servers * 200     # $200/server repairement
        imp_equipment_fire = imp_equipment_computers + imp_equipment_servers
    }
    # FLOOD
    imp_equipment_flood <- 0
    if (envthreat_flood == 1 & envthreat_fire == 0 & fd == 1){
        is_repaired = round(rbeta(1,1,0.05)) # yes in the 95% of cases
        if (is_repaired == 1){
          imp_equipment_flood = 200 * (asset_num_computers + asset_num_servers) # $200/device repairement
        }else{
          imp_equipment_flood = (asset_num_computers * 400) + (asset_num_servers * 1200) # replacement
        }
    }else if (envthreat_flood == 1 & envthreat_fire == 0 & fd == 0){
      is_repaired = round(rbeta(1,1,0.30)) # yes in the 70% of cases
      if (is_repaired == 1){
        imp_equipment_flood = 200 * (asset_num_computers + asset_num_servers) # $200/device repairement
      }else{
        imp_equipment_flood = (asset_num_computers * 400) + (asset_num_servers * 1200) # replacement
      }
    }
    # VIRUS
    imp_equipment_virus <- 0 
    if (envthreat_flood == 0 & envthreat_fire == 0 ){
      imp_equipment_virus = (num_computers_infected + num_servers_infected) * 31 # repair 31$/device, two technical hours
    }
    round(imp_equipment_fire + imp_equipment_flood + imp_equipment_virus,2) # money
    }else{cat("Error in Impacts/insurable_impacts equipment")}
}

# AVAILABILITY
impactAvailability <- function(ntathreat_virus,
                               ntathreat_ransomware){
  duration = 0
  imp_avail <- 0 # Dollars
  cost_virus = 0
  cost_ransomware = 0
  cost_ddos = 0
  if (impacts_to_availability_included == FALSE){0}
  else if (impacts_to_availability_included == TRUE){
    # Virus
    if (ntathreat_virus>0){
      duration = mean(rgamma(100,12,.8)) # 15 hours mean
      cost_virus = duration*20
    }
    # Ransomware
    if (ntathreat_ransomware>0){
      duration = mean(rgamma(100,10,1))
      cost_ransomware = duration * 60000 # 60000/hour
    } 
    # DDoS
    duration = mean(rgamma(100,10,1))
    cost_ddos = duration * 60000 # 60000/hour
    
    imp_avail = cost_virus+cost_ransomware+cost_ddos # $
    round(imp_avail,2)
  }
}

# PIIRECORDS
impactPiiRecords <- function(num_employee_errors,
                             ntathreat_ransomware){
  
  if (impacts_to_records_exposed_included == FALSE |
      (accthreat_emperror == 0 & ntathreat_ransomware == 0)) {0}
  else if (impacts_to_records_exposed_included == TRUE) {
    impact_records_exposed_employee <- 0   # return dollars
    impact_records_exposed_ransomware <- 0 # return dollars
    fines = 60000 # dollars
    # Employee error
    if (num_employee_errors > 0) {
      num_errors <- round(num_employee_errors)
      exf_records = round(runif(1,0,total_records_pii)) # [0, ..., 200.000]
      num_records = round(0.1243*exf_records*num_errors)
      if (num_records>11000 & num_errors>=1){
        impact_records_exposed_employee =  (num_records * pii_cost_record) + fines
      }else{
        impact_records_exposed_employee =  num_records * pii_cost_record
      }
    }
    # Ransomware
    if (ntathreat_ransomware > 0) {
      num_errors <- round(num_employee_errors)
      exf_records = round(runif(1,0,total_records_pii)) # [0, ..., 200.000]
      num_records = round(0.4*exf_records*num_errors)
      if (num_records>11000 & num_errors>=1){
        impact_records_exposed_ransomware =  (num_records * pii_cost_record)+fines
      }else{
        impact_records_exposed_ransomware =  num_records * pii_cost_record
      }
    }
    round(impact_records_exposed_employee + impact_records_exposed_ransomware) # $
  } else {cat("Error in insurable_impacts/piirecords")}
}

# BUSINESS INFO
impactBusinessRecords <- function(num_employee_errors,
                                  ntathreat_ransomware){
  if (impacts_to_business_info_included == FALSE | 
      (accthreat_emperror == 0 & ntathreat_ransomware == 0)) {0}
  else if (impacts_to_business_info_included == TRUE){
    impact_business_records_exposed_employee <- 0   # return dollars
    impact_business_records_exposed_ransomware <- 0 # return dollars
    fines = 60000 # dollars
    # Employee error
    if (num_employee_errors > 0) {
      num_errors <- round(num_employee_errors)
      exf_records = round(runif(1,0,total_records_business)) # [0,..., 66.000]
      num_records = round(0.1243*exf_records*num_errors)
      if (num_records>11000 & num_errors>=1){
        impact_business_records_exposed_employee =  (num_records * pii_cost_business_record) + fines
      }else{
        impact_business_records_exposed_employee =  num_records * pii_cost_business_record
      }
    }
    # Ransomware
    if (ntathreat_ransomware > 0) {
      num_errors <- round(num_employee_errors)
      exf_records = round(runif(1,0,total_records_business)) # [0,..., 66.000]
      num_records = round(0.4*exf_records*num_errors)
      if (num_records>11000 & num_errors>=1){
        impact_business_records_exposed_ransomware =  (num_records * pii_cost_business_record) + fines
      }else{
        impact_business_records_exposed_ransomware =  ( num_records * pii_cost_business_record)
      }
    }
    round(impact_business_records_exposed_employee + impact_business_records_exposed_ransomware)
  } else {cat("Error in insurable_impacts/businessrecords")}
}

