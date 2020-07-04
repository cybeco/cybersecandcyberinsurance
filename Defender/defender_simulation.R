#! Rscript defender simulation.R --

#### DEFENDER PROBLEM SIMULATION ----

# THREATS
envthreat_fire <- NULL
for (i in 1:years) {
  envthreat_fire[i] <- envThreatFire() # Threats/envthreats.R
}
envthreat_fire

envthreat_flood <- NULL
for (i in 1:years) {
  envthreat_flood[i] <- envThreatFlood(D_portfolios_table[p,]$fd) # Threats/envthreats.R
}
envthreat_flood

accthreat_emperror <- NULL
for (i in 1:years) {
  accthreat_emperror[i] <- accThreatEmpError() # Threats/accthreats.R
}
accthreat_emperror

accthreat_misconf <- NULL
for (i in 1:years) {
  accthreat_misconf[i] <- accThreatMisconfiguration(D_portfolios_table[p,]$secconfig) # Threats/accthreats.R
}
accthreat_misconf

ntathreat_virus_pc <- NULL
for (i in 1:years) {
  ntathreat_virus_pc[i] <- ntaThreatVirusPC(D_portfolios_table[p,]$secconfig,        # Threats/ntathreats.R
                                            D_portfolios_table[p,]$malwprot,
                                            D_portfolios_table[p,]$patchvul,
                                            D_portfolios_table[p,]$ids)
}
ntathreat_virus_pc

ntathreat_virus_server <- NULL
for (i in 1:years) {
  ntathreat_virus_server[i] <- ntaThreatVirusServer(D_portfolios_table[p,]$secconfig,# Threats/ntathreats.R
                                                    D_portfolios_table[p,]$malwprot,
                                                    D_portfolios_table[p,]$patchvul,
                                                    D_portfolios_table[p,]$ids)
}
ntathreat_virus_server

ntathreat_ransomware <- NULL
for (i in 1:years) {
  ntathreat_ransomware[i] <- ntaThreatRansomware(D_portfolios_table[p,]$ids, # Threats/ntathreats.R
                                                 D_portfolios_table[p,]$secconfig,
                                                 D_portfolios_table[p,]$patchvul,
                                                 D_portfolios_table[p,]$malwprot)
}
ntathreat_ransomware

# ATTACKERS
# Compeet
K_optimal_per_year <- NULL
attack_vector_compeet = rep(0, years)
if (D_portfolios_table$compeet_attack[1]==1){
  
  if (D_portfolios_table[p,]$ddos_prot==1){
    attack_vector_compeet = rbinom(years,1,0.73) # generate the attacks based on Compeet prob for x years (when cloud==1)
  }else{
    attack_vector_compeet = rbinom(years,1,0.26) # generate the attacks based on Compeet prob for x years (no cloud)
  }

  for (i in 1:years){
    targdos_options <- attack_vector_compeet[i]
    K_decision_portfolios <- expand.grid(K_targdos_decision = targdos_options,
                                         cloud = D_portfolios_table[p,]$ddos_prot) # Competitor/security_portfolio_options.R

    K_decision_portfolios
    #### CONFIGURATION OF THE COMPETITOR PROBLEM ----
    # Number of simulations per decision portfolio
    K_portfolio_simsize <- input_portfolio_simsize
    K_portfolio_simsize = 5
    # Number of portfolios
    K_portfolios_numberof <- portfolioSize(K_decision_portfolios)
    # Numeration to each of the individual simulations
    K_portfolio_num <- portfolioNumeration(K_portfolios_numberof)
    # Table with the individual simulations and their decision portfolio
    K_portfolios_table <- portfolioTable(K_portfolio_num, K_decision_portfolios)

    K_all_portfolios <- NULL
    K_optimal_portfolio_sim <- NULL
    for (j in 1:K_portfolio_simsize) {
      source("Attackers/Competitor/competitor_simulation.R", echo = echoing) # generate K_portfolio_simulation
      K_all_portfolios <- dplyr::bind_rows(K_all_portfolios, K_portfolio_simulation) # all portfolios
      K_portfolio_simulation <- filter(K_portfolio_simulation,
                                       K_portfolio_simulation$comp_utility_money >=-3200000 & # c_*
                                       K_portfolio_simulation$comp_utility_money < 6100000)   # c^*
      K_portfolio_simulation
      K_optimal_portfolio_sim <- dplyr::bind_rows(K_optimal_portfolio_sim,dplyr::slice(K_portfolio_simulation,which.max(K_portfolio_simulation$comp_utility)))
    }
    K_optimal_portfolio_sim
    K_optimal_per_year <- dplyr::bind_rows(K_optimal_per_year, # best per year
                                           dplyr::slice(K_optimal_portfolio_sim,which.max(K_optimal_portfolio_sim$comp_utility)))
  } # for years
K_optimal_per_year
}    

# Antonymous
H_optimal_per_year <- NULL
attack_vector_anto = rep(0, years)
if (D_portfolios_table$antonymous_attack[1]==1){ # simulate Antonymous attacker (n defender portfolios)
  if (D_portfolios_table[p,]$ddos_prot==1){      # decision to attack or not (attack vector)
    attack_vector_anto = rbinom(years,1,0.73)
  }else{
    attack_vector_anto = rbinom(years,1,0.26)
  }

  for (i in 1:years){
  targdos_options <- attack_vector_anto[i]
  H_decision_portfolios <- expand.grid(H_targdos_decision = targdos_options,
                                       cloud = D_portfolios_table[p,]$ddos_prot) # security_portfolio_options.R

  #### CONFIGURATION OF THE HACKTIVIST PROBLEM ----
  # Number of simulations per decision portfolio
  H_portfolio_simsize <- input_portfolio_simsize
  H_portfolio_simsize = 5
  # Number of portfolios
  H_portfolios_numberof <- portfolioSize(H_decision_portfolios)
  # Numeration to each of the individual simulations
  H_portfolio_num <- portfolioNumeration(H_portfolios_numberof)
  # Table with the individual simulations and their decision portfolio
  H_portfolios_table <- portfolioTable(H_portfolio_num, H_decision_portfolios)
  H_portfolios_table

  H_all_portfolios <- NULL
  H_optimal_portfolio_sim <- NULL
  for (j in 1:H_portfolio_simsize){ # number of simulations (each simulation generate a optimal portfolio (from all posibles))
    source("Attackers/Hacktivist/Hacktivist_simulation.R", echo = echoing) # se genera H_portfolio_simulation
    H_all_portfolios <- dplyr::bind_rows(H_all_portfolios,H_portfolio_simulation) # Here we have all portfolios
    H_portfolio_simulation <- filter(H_portfolio_simulation,
                                     H_portfolio_simulation$hacktivist_utility_money >= -600000 & # c_*
                                     H_portfolio_simulation$hacktivist_utility_money < 1200000 ) # c^*
    H_optimal_portfolio_sim <- dplyr::bind_rows(H_optimal_portfolio_sim,dplyr::slice(H_portfolio_simulation, 
                                                                                       which.max(H_portfolio_simulation$hacktivist_utility)))
  }
  H_optimal_portfolio_sim
  H_optimal_per_year <- dplyr::bind_rows(H_optimal_per_year,
                                         dplyr::slice(H_optimal_portfolio_sim,which.max(H_optimal_portfolio_sim$hacktivist_utility)))
  } # years
H_optimal_per_year  
}

# Cybeganta
CY_optimal_per_year <- NULL
if (D_portfolios_table$cybegansta_attack[1]==1){
  for (i in 1:years){
    attack_decision <- 0
    # attack_decision = rbern(1,0.611)
    if (D_portfolios_table[p,]$ids==1){
        attack_decision = rbern(100,0.005)
    }else{
        attack_decision = rbern(100,0.009)
    }
    targsocial_enginerring_options <- attack_decision
         
    CY_decision_portfolios <- expand.grid(CY_targsocial_engineering_decision = targsocial_enginerring_options)
    CY_decision_portfolios
    #### CONFIGURATION OF THE CYBERCRIMINAL PROBLEM ----
    # Number of simulations per decision portfolio
    CY_portfolio_simsize <- input_portfolio_simsize
    CY_portfolio_simsize = 5
    # Number of portfolios
    CY_portfolios_numberof <- portfolioSize(CY_decision_portfolios)
    # Numeration to each of the individual simulations
    CY_portfolio_num <- portfolioNumeration(CY_portfolios_numberof)
    # Table with the individual simulations and their decision portfolio
    CY_portfolios_table <- portfolioTable(CY_portfolio_num, CY_decision_portfolios)
    CY_portfolios_table
  
    CY_all_portfolios_forecast <- NULL
    CY_optimal_portfolio_sim_forecast <- NULL
    for (j in 1:CY_portfolio_simsize){
      source("Attackers/Cybercriminal/cybercriminal_simulation_forecast.R", echo = echoing)
      CY_all_portfolios_forecast <- dplyr::bind_rows(CY_all_portfolios_forecast, CY_portfolio_simulation_forecast) # all portfolios generated
      CY_portfolio_simulation_forecast <- filter(CY_portfolio_simulation_forecast,
                                                 CY_portfolio_simulation_forecast$cybercriminal_utility_money>=-12000000 & 
                                                 CY_portfolio_simulation_forecast$cybercriminal_utility_money<24000000)
      CY_optimal_portfolio_sim_forecast <- dplyr::bind_rows(CY_optimal_portfolio_sim_forecast,
                                                            dplyr::slice(CY_portfolio_simulation_forecast,
                                                                         which.max(CY_portfolio_simulation_forecast$cybercriminal_utility)))
    }
    CY_optimal_portfolio_sim_forecast
    CY_optimal_per_year <- dplyr::bind_rows(CY_optimal_per_year,
                                            dplyr::slice(CY_optimal_portfolio_sim_forecast, which.max(CY_optimal_portfolio_sim_forecast$cybercriminal_utility)))
  }
CY_optimal_per_year
}

# Mr
Mr_optimal_per_year <- NULL
if (D_portfolios_table$mr_attack[1]==1){
  for (i in 1:years){
    attack_decision_ddos <- 0   # decision to attack through ddos
    attack_decision_social <- 0 # decsion to attack through social attack
    if (D_portfolios_table[p,]$ddos_prot==1){
      attack_decision_ddos = rbern(1,0.757)
      # attack_decision_social = rbern(1,0.192)
    }else{
      attack_decision_ddos = rbern(1,0.883)
      # attack_decision_social = rbern(1,0.085)
    }
    if (D_portfolios_table[p,]$ids==1){
        attack_decision_social = rbern(1,0.05)
     }else{
         attack_decision_social = rbern(1,0.15)
     }

  targdos_options <- attack_decision_ddos
  targsocial_enginerring_options <- attack_decision_social
  M_decision_portfolios <- expand.grid(M_targdos_decision = targdos_options,
                                       M_targsocial_engineering_decision = targsocial_enginerring_options,
                                       cloud = D_portfolios_table[p,]$ddos_prot)
  
  M_portfolios_numberof <- portfolioSize(M_decision_portfolios)
  # Numeration to each of the individual simulations
  M_portfolio_num <- portfolioNumeration(M_portfolios_numberof)
  # Table with the individual simulations and their decision portfolio
  M_portfolios_table <- portfolioTable(M_portfolio_num, M_decision_portfolios)
  M_portfolios_table
  
  M_all_portfolios_forecast <- NULL
  M_optimal_portfolio_sim_forecast <- NULL
  M_portfolio_simsize = 3
  for (j in 1:M_portfolio_simsize) {
      
    source("Attackers/Mr/mr_simulation_forecast.R", echo = echoing)
    M_all_portfolios_forecast <- dplyr::bind_rows(M_all_portfolios_forecast, M_portfolio_simulation_forecast) # all portfolios generated
    M_portfolio_simulation_forecast <- filter(M_portfolio_simulation_forecast,
                                              M_portfolio_simulation_forecast$mr_utility_money>=-5000000 &
                                              M_portfolio_simulation_forecast$mr_utility_money<10000000) 
    M_optimal_portfolio_sim_forecast <- dplyr::bind_rows(M_optimal_portfolio_sim_forecast,dplyr::slice(M_portfolio_simulation_forecast,
                                                                                                         which.max(M_portfolio_simulation_forecast$mr_utility)))
  }
  M_optimal_portfolio_sim_forecast
  Mr_optimal_per_year <- dplyr::bind_rows(Mr_optimal_per_year,
                                          dplyr::slice(M_optimal_portfolio_sim_forecast, which.max(M_optimal_portfolio_sim_forecast$mr_utility)))
  }
Mr_optimal_per_year
}
  

# IMPACTS
# Equipment impact (accidental)
ins_impact_equipment <- NULL
for (i in 1:years) {
  ins_impact_equipment[i] <- impactEquipment(envthreat_fire[i], # Impacs/insurable_impacts
                                             envthreat_flood[i],
                                             ntathreat_virus_pc[i],
                                             ntathreat_virus_server[i],
                                             D_portfolios_table[p,]$sprk_protection,
                                             D_portfolios_table[p,]$fd)
}
ins_impact_equipment

# Equipment impact coverage
cov_equipment <- NULL
for (i in 1:years) {
  cov_equipment[i] <- equipmentCoverage(ins_impact_equipment[i], # Impacts/insurable_impacts_coverage
                                        D_portfolios_table[p,]$ins_conventional,
                                        D_portfolios_table[p,]$ins_cyber1,
                                        D_portfolios_table[p,]$ins_cyber2)
}
cov_equipment

# Availability impact
ins_impact_availability <- NULL
for (i in 1:years) { # Impacts/insurable_impacts
  ins_impact_availability[i] <-impactAvailability(ntathreat_virus_pc[i],
                                                  ntathreat_ransomware[i])
}
ins_impact_availability

# Availability impact coverage
cov_availability <- NULL
for (i in 1:years) { # Impacts/insurable_impacts_coverage
  cov_availability[i] <- availabilityCoverage(ins_impact_availability[i],
                                              D_portfolios_table[p,]$ins_conventional,
                                              D_portfolios_tabl[p,]$ins_cyber1,
                                              D_portfolios_table[p,]$ins_cyber2)
}
cov_availability

# Records impact (include fines)
ins_impact_pii_records <- NULL
for (i in 1:years) { # Impacts/insurable_impacts
  ins_impact_pii_records[i] <- impactPiiRecords(accthreat_emperror[i], # num_employee errors
                                                ntathreat_ransomware[i])
}
ins_impact_pii_records

# Records business impacts (include fines)
ins_impact_business_records <- NULL
for (i in 1:years) { # Impacts/insurable_impacts
  ins_impact_business_records[i] <- impactBusinessRecords(accthreat_emperror[i], # num_employee errors
                                                          ntathreat_ransomware[i])
}
ins_impact_business_records

# NON INSURABLE IMPACTS
# Misconfiguration
non_ins_impact_misconf <- NULL
for (i in 1:years) { # Impacts/non_insurable_impacts
  non_ins_impact_misconf[i] <- impactNonInsurableMisconfiguration(accthreat_misconf[i],
                                                                  D_portfolios_table[p,]$secconfig)
}
non_ins_impact_misconf

# Computer virus
non_ins_impact_virus <- NULL
for (i in 1:years) { # Impacts/non_insurable_impacts
  non_ins_impact_virus[i] <- impactVirusNonInsurable(ntathreat_virus_pc[i])
}
non_ins_impact_virus

# cost_controls
cost_controls <- NULL
for (i in 1:years) { # Impacts/security_insurance_cost
  cost_controls[i] <- securityCost(D_portfolios_table[p,]$sprk_protection,
                                   D_portfolios_table[p,]$fd,
                                   D_portfolios_table[p,]$ddos_prot,
                                   D_portfolios_table[p,]$secconfig,
                                   D_portfolios_table[p,]$malwprot,
                                   D_portfolios_table[p,]$patchvul,
                                   D_portfolios_table[p,]$ids)
}
cost_controls

# cost_insurance
cost_insurance <- NULL
for (i in 1:years) { # Impacts/security_insurance_cost
  cost_insurance[i] <- insuranceCost(D_portfolios_table[p,]$ins_conventional,
                                     D_portfolios_table[p,]$ins_cyber1,
                                     D_portfolios_table[p,]$ins_cyber2)
}
cost_insurance

# Cost controls + insurance
cost_controls_insurance <- cost_controls + cost_insurance
cost_controls_insurance


# ATTACKER AGGREGATION COSTS (market_share,avail,exf_records,exf_business_records)
# Aggregation market share (Competitor)
aggr_market_share <- NULL
for (i in 1:years) { # Defender/defender_utility.R
  aggr_market_share[i] <- 0
  if (D_portfolios_table$compeet_attack[1]==1){
    aggr_market_share[i] = K_optimal_per_year$comp_market_gain[i]
  }
}
aggr_market_share

# Aggregation availability (Hacktivist and Mr)
aggr_availability_hacktivist <- NULL
aggr_availability_mr <- NULL
for (i in 1:years) { # Impacts/defender_utility.R
  aggr_availability_hacktivist[i] <- 0 
  aggr_availability_mr[i] <- 0 
  if(D_portfolios_table$antonymous_attack[1]==1){
    
    aggr_availability_hacktivist[i] = H_optimal_per_year$hacktivist_gain_ddos[i]

  }
  if (D_portfolios_table$mr_attack[1]==1){
    aggr_availability_mr[i] = Mr_optimal_per_year$mr_gain_ddos[i]
    
  }
  
}
aggr_availability= aggr_availability_hacktivist + aggr_availability_mr
aggr_availability

# Aggregation exfiltration pii records (Cybercriminals and Mr)
aggr_exfiltration_pii_cybercriminals <- NULL
aggr_exfiltration_pii_mr <- NULL
for (i in 1:years) { # Impacts/defender_utility.R
  aggr_exfiltration_pii_cybercriminals[i] <- 0
  aggr_exfiltration_pii_mr[i] <- 0
  if (D_portfolios_table$cybegansta_attack[1]==1){
    aggr_exfiltration_pii_cybercriminals[i] = CY_optimal_per_year$cybercriminal_gain_exf_records[i]
  }
  if (D_portfolios_table$mr_attack[1]==1){
    aggr_exfiltration_pii_mr[i] = Mr_optimal_per_year$mr_gain_exf_records[i]
  }
  

}
aggr_exfiltration_pii = aggr_exfiltration_pii_cybercriminals + aggr_exfiltration_pii_mr
aggr_exfiltration_pii

# Aggregation exfiltration business records (cybercriminals and Mr)
aggr_exfiltration_business_cybercriminals <- NULL
aggr_exfiltration_business_mr <- NULL
for (i in 1:years) { # Impacts/defender_utility.R
  aggr_exfiltration_business_cybercriminals[i] <- 0
  aggr_exfiltration_business_mr[i] <- 0
  if (D_portfolios_table$cybegansta_attack[1]==1){
    aggr_exfiltration_business_cybercriminals[i] = CY_optimal_per_year$cybercriminal_gain_exf_business_records[i]
  }
  if (D_portfolios_table$mr_attack[1]==1){
    aggr_exfiltration_business_mr[i] = Mr_optimal_per_year$mr_gain_exf_business_records[i]
  }

}
aggr_exfiltration_business = aggr_exfiltration_business_cybercriminals + aggr_exfiltration_business_mr
aggr_exfiltration_business

# compensation_from_insurance
compensation_from_insurance <- NULL
for (i in 1:years) { # Defender/defender_utility.R
compensation_from_insurance[i] <- compensationFromInsurance(D_portfolios_table[p,]$ins_conventional,
                                                            D_portfolios_table[p,]$ins_cyber1,
                                                            D_portfolios_table[p,]$ins_cyber2,
                                                            ins_impact_equipment[i],       # cost equipment accidental
                                                            ins_impact_pii_records[i],     # cost exfiltrated records (accidental threats-->employee,malware,accidenhit)
                                                            aggr_market_share[i],          # cost market_share (Competitor) 
                                                            aggr_availability[i],          # cost availability (Hacktivist, Mr)
                                                            aggr_exfiltration_pii[i],      # cost exfiltrated records (Cybercriminal, Mr)
                                                            aggr_exfiltration_business[i]) # cost exfiltrated business records (Cybercriminal, Mr)
}
compensation_from_insurance

# DEFENDER COST AND UTILITY
# Defender cost
defender_cost <- NULL # Defender/defender_utility.R
for (i in 1:years) {
  defender_cost[i] <- defenderCosts(D_portfolios_table[p,]$ins_conventional,
                                    D_portfolios_table[p,]$ins_cyber1,
                                    D_portfolios_table[p,]$ins_cyber2,
                                    ins_impact_equipment[i],        # d, accidental
                                    cov_equipment[i],               # equipment coverage reduction
                                    aggr_market_share[i],           # market_share aggregation cost (Compeet)
                                    aggr_availability[i],           # availability aggregation cost (Hacktivist, Mr)
                                    cov_availability[i],            # downtime coverage reductiok
                                    aggr_exfiltration_pii[i],       # exfiltrated records aggregation (Cybegansta, Mr)
                                    aggr_exfiltration_business[i],  # exfiltrated business aggregation (Cybegansta, Mr)
                                    ins_impact_pii_records[i],      # cost exfiltrated records (accidental threats-->employee,malware,accidenhit)
                                    cost_controls[i],               # c_s
                                    cost_insurance[i],              # c_i
                                    compensation_from_insurance[i])
  
  
}
defender_cost

# Defender utility
defender_utility <- NULL
for(i in 1:years){
  defender_utility[i] <- defenderUtility(defender_cost[i])
  
}
defender_utility

# Final simulation table
D_portfolio_simulation <- data.frame(D_portfolios_table[p,],
                                     envthreat_fire,
                                     envthreat_flood, 
                                     accthreat_emperror,
                                     accthreat_misconf,
                                     ntathreat_virus_pc,
                                     ntathreat_virus_server,
                                     ntathreat_ransomware,
                                     ins_impact_equipment,
                                     cov_equipment,
                                     ins_impact_availability,
                                     cov_availability,
                                     cost_controls,
                                     cost_insurance,
                                     cost_controls_insurance,
                                     defender_cost,
                                     defender_utility)
D_portfolio_simulation
