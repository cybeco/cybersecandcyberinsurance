#! Rscript defender simulation.R --

#### DEFENDER PROBLEM SIMULATION ----
# Nodes should be in order so that predecesors are calculated first

# THREATS
envthreat_fire <- NULL
for (i in 1:years) {
  envthreat_fire[i] <- envThreatFire() # Threats/envthreats.R
}
envthreat_fire

envthreat_flood <- NULL
for (i in 1:years) {
  envthreat_flood[i] <- envThreatFlood(D_portfolios_table$fd[i]) # Threats/envthreats.R
}
envthreat_flood

accthreat_emperror <- NULL
for (i in 1:years) {
  accthreat_emperror[i] <- accThreatEmpError() # Threats/accthreats.R
}
accthreat_emperror

accthreat_misconf <- NULL
for (i in 1:years) {
  accthreat_misconf[i] <- accThreatMisconfiguration(D_portfolios_table$secconfig[i]) # Threats/accthreats.R
}
accthreat_misconf

ntathreat_virus_pc <- NULL
for (i in 1:years) {
  ntathreat_virus_pc[i] <- ntaThreatVirusPC(D_portfolios_table[p,]$secconfig,# Threats/ntathreats.R
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

# ATTACKERS DECISIONS
# Compeet
K_optimal_per_year <- NULL
if (D_portfolios_table$compeet_attack[1]==1){
# Competitor decisions
ifelse(tarthreat_dos_included == TRUE,
       targdos_options <- c(1,0),
       targdos_options <-  c(0))
K_decision_portfolios <- expand.grid(K_targdos_decision = targdos_options,
                                     cloud = D_portfolios_table[p,]$ddos_prot) # Competitor/security_portfolio_options.R

K_decision_portfolios
#### CONFIGURATION OF THE COMPETITOR PROBLEM ----
# Number of simulations per decision portfolio
K_portfolio_simsize <- input_portfolio_simsize
K_portfolio_simsize = 5 # check this
# Number of portfolios
K_portfolios_numberof <- portfolioSize(K_decision_portfolios)
# Numeration to each of the individual simulations
K_portfolio_num <- portfolioNumeration(K_portfolios_numberof)
# Table with the individual simulations and their decision portfolio
K_portfolios_table <- portfolioTable(K_portfolio_num, K_decision_portfolios)


for (i in 1:years){
    K_all_portfolios <- NULL
    K_optimal_portfolio_sim <- NULL
    for (j in 1:K_portfolio_simsize) { # veces que simulamos el portfolio del atacante
      # j=1
      # cat("Competitor simulation: ", j, "\n")
      source("Attackers/Competitor/competitor_simulation.R", echo = echoing) # generate K_portfolio_simulation
      K_all_portfolios <- dplyr::bind_rows(K_all_portfolios, K_portfolio_simulation) # all portfolios
      K_portfolio_simulation <- filter(K_portfolio_simulation,
                                       K_portfolio_simulation$comp_utility_money >=-3200000 & # c_*
                                       K_portfolio_simulation$comp_utility_money < 6100000) # c^*  filter
      K_portfolio_simulation
      K_optimal_portfolio_sim <- dplyr::bind_rows(K_optimal_portfolio_sim,dplyr::slice(K_portfolio_simulation,which.max(K_portfolio_simulation$comp_utility)))
    }
    K_optimal_portfolio_sim
    K_optimal_per_year <- dplyr::bind_rows(K_optimal_per_year, # best per year
                                           dplyr::slice(K_optimal_portfolio_sim,which.max(K_optimal_portfolio_sim$comp_utility)))
  
  }
K_optimal_per_year
}    


# Antonymous
H_optimal_per_year <- NULL
if (D_portfolios_table$antonymous_attack[1]==1){ # simulate Antonymous attacker (n defender portfolios)
# Hacktivists decisions
ifelse(tarthreat_dos_included == TRUE,
       targdos_options <- c(1,0),
       targdos_options <-  c(0))
H_decision_portfolios <- expand.grid(H_targdos_decision = targdos_options,
                                     cloud = D_portfolios_table[p,]$ddos_prot) # security_portfolio_options.R
H_decision_portfolios

#### CONFIGURATION OF THE HACKTIVIST PROBLEM ----
# Number of simulations per decision portfolio
H_portfolio_simsize <- input_portfolio_simsize
H_portfolio_simsize = 5 # check this
# cat("Num of simulations per portfolio: ", H_portfolio_simsize)
# Number of portfolios
H_portfolios_numberof <- portfolioSize(H_decision_portfolios)
# cat("Num of portfolios: ", H_portfolios_numberof)
# Numeration to each of the individual simulations
H_portfolio_num <- portfolioNumeration(H_portfolios_numberof)
# cat("Portfolio numeration: ", H_portfolio_num)
# Table with the individual simulations and their decision portfolio
H_portfolios_table <- portfolioTable(H_portfolio_num, H_decision_portfolios)
# cat("Portfolios table: ")
H_portfolios_table

for (i in 1:years){
    H_all_portfolios <- NULL
    H_optimal_portfolio_sim <- NULL
    for (j in 1:H_portfolio_simsize){ # number of simulations (each simulation generate a optimal portfolio (from all posibles))
      # cat("Hacktivist simulation: ", j, "\n")
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
      
  }
H_optimal_per_year  
}


# Cybeganta
CY_optimal_per_year <- NULL
if (D_portfolios_table$cybegansta_attack[1]==1){
  
  ifelse(tarthreat_social_enginerring_included == TRUE,
         targsocial_enginerring_options <- c(1,0),
         targsocial_enginerring_options <- c(0))
  
  CY_decision_portfolios <- expand.grid(CY_targsocial_engineering_decision = targsocial_enginerring_options)
  CY_decision_portfolios
  
  #### CONFIGURATION OF THE CYBERCRIMINAL PROBLEM ----
  # Number of simulations per decision portfolio
  CY_portfolio_simsize <- input_portfolio_simsize
  CY_portfolio_simsize = 5 # check this
  # cat("Num of simulations per portfolio: ", CY_portfolio_simsize)
  # Number of portfolios
  CY_portfolios_numberof <- portfolioSize(CY_decision_portfolios)
  # cat("Num of portfolios: ", CY_portfolios_numberof)
  # Numeration to each of the individual simulations
  CY_portfolio_num <- portfolioNumeration(CY_portfolios_numberof)
  # cat("Portfolio numeration: ", CY_portfolio_num)
  # Table with the individual simulations and their decision portfolio
  CY_portfolios_table <- portfolioTable(CY_portfolio_num, CY_decision_portfolios)
  # cat("Portfolios table: ")
  CY_portfolios_table
  
  for (i in 1:years){
    CY_all_portfolios_forecast <- NULL
    CY_optimal_portfolio_sim_forecast <- NULL
    CY_portfolio_simsize = 5
    for (j in 1:CY_portfolio_simsize) {
      source("Attackers/Cybercriminal/cybercriminal_simulation_forecast.R", echo = echoing)
      CY_all_portfolios_forecast <- dplyr::bind_rows(CY_all_portfolios_forecast, CY_portfolio_simulation_forecast) # all portfolios generated
      CY_portfolio_simulation_forecast <- filter(CY_portfolio_simulation_forecast, # this filter needs some simulation
                                                 CY_portfolio_simulation_forecast$cybercriminal_utility_money>=-12000000 & # temporal
                                                   CY_portfolio_simulation_forecast$cybercriminal_utility_money<24000000)# filter between (-1.300.000,2.600.000)
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
  ifelse(tarthreat_dos_included == TRUE,
         targdos_options <- c(1,0),
         targdos_options <-  c(0))
  ifelse(tarthreat_social_enginerring_included == TRUE,
         targsocial_enginerring_options <- c(1,0),
         targsocial_enginerring_options <- c(0))
  M_decision_portfolios <- expand.grid(M_targdos_decision = targdos_options,
                                       M_targsocial_engineering_decision = targsocial_enginerring_options,
                                       cloud = D_portfolios_table[p,]$ddos_prot)
  
  M_portfolios_numberof <- portfolioSize(M_decision_portfolios)
  # Numeration to each of the individual simulations
  M_portfolio_num <- portfolioNumeration(M_portfolios_numberof)
  # Table with the individual simulations and their decision portfolio
  M_portfolios_table <- portfolioTable(M_portfolio_num, M_decision_portfolios)
  M_portfolios_table
  
  for (i in 1:years){
    M_all_portfolios_forecast <- NULL
    M_optimal_portfolio_sim_forecast <- NULL
    M_portfolio_simsize = 3
    for (j in 1:M_portfolio_simsize) {
      
      source("Attackers/Mr/mr_simulation_forecast.R", echo = echoing)
      M_all_portfolios_forecast <- dplyr::bind_rows(M_all_portfolios_forecast, M_portfolio_simulation_forecast) # all portfolios generated
      M_portfolio_simulation_forecast <- filter(M_portfolio_simulation_forecast,
                                                M_portfolio_simulation_forecast$mr_utility_money>=-5000000 &
                                                  M_portfolio_simulation_forecast$mr_utility_money<10000000) # filter (paper -4400000, 8800000)
      M_optimal_portfolio_sim_forecast <- dplyr::bind_rows(M_optimal_portfolio_sim_forecast,dplyr::slice(M_portfolio_simulation_forecast,
                                                                                                         which.max(M_portfolio_simulation_forecast$mr_utility)))
      # write.csv(M_all_portfolios_forecast,"Output/Mr/mrPortfoliosOneSimulation.csv")
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
                                                  # H_optimal_per_year$H_targdos_decision[i])
                                                  # D_portfolios_table$antonymous_attack[i])
                                                  
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
# cat("Cost controls: ", cost_controls, "\n")

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
    aggr_market_share[i] <- aggregationMarketShare(K_optimal_per_year$K_targdos_decision[i],
                                                 K_optimal_per_year$comp_market_gain[i])
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
    aggr_availability_hacktivist[i] =H_optimal_per_year$hacktivist_gain_ddos[i]

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
                                                            ins_impact_equipment[i], # cost equipment accidental
                                                            ins_impact_pii_records[i], # cost exfiltrated records (accidental threats-->employee,malware,accidenhit)
                                                            aggr_market_share[i], # cost market_share (Competitor) 
                                                            aggr_availability[i], # cost availability (Hacktivist, Mr)
                                                            aggr_exfiltration_pii[i], # cost exfiltrated records (Cybercriminal, Mr)
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
                                    ins_impact_equipment[i], # d, accidental
                                    cov_equipment[i], # equipment coverage reduction
                                    aggr_market_share[i], # market_share aggregation cost (Compeet)
                                    aggr_availability[i], # availability aggregation cost (Hacktivist, Mr)
                                    # ins_impact_availability[i], # time of unavailability in hours (d_t)
                                    cov_availability[i], # downtime coverage reductiok
                                    aggr_exfiltration_pii[i], # exfiltrated records aggregation (Cybegansta, Mr)
                                    aggr_exfiltration_business[i], # exfiltrated business aggregation (Cybegansta, Mr)
                                    ins_impact_pii_records[i], # cost exfiltrated records (accidental threats-->employee,malware,accidenhit)
                                    # business_records = 100, # num of exfiltrated business records (n_i)
                                    cost_controls[i], # c_s
                                    cost_insurance[i], # c_i
                                    # fines=60000, # f --> not needed, its included in ins_impact_pii_records
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
                                     #K_optimal_per_year$K_targdos_decision, # Compeet decision de atacar
                                     # H_optimal_per_year$H_targdos_decision, # Hacktivist decision de atacar
                                     # CY_optimal_per_year$CY_targsocial_engineering_decision, # cybegansta decision de atacar
                                     # Mr_optimal_per_year$M_targdos_decision, # Mr decision atacar ddos
                                     # Mr_optimal_per_year$M_targsocial_engineering_decision, # Mr decision atacar social engineering
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




#   aggr_exfiltration_business[i] <- aggregationBusinessRecords(D_portfolios_table$cybegansta_attack[i],
#                                                               D_portfolios_table$mr_attack[i],
#                                                               CY_random_optimal_portfolio$cybercriminal_gain_exf_business_records,
#                                                               M_random_optimal_portfolio$mr_gain_exf_business_records)
# 

#   aggr_exfiltration_pii[i] <- aggregationPiiRecords(D_portfolios_table$cybegansta_attack[i],
#                                                     D_portfolios_table$mr_attack[i],
#                                                     CY_random_optimal_portfolio$cybercriminal_gain_exf_records,
#                                                     M_random_optimal_portfolio$mr_gain_exf_records)

# aggr_availability[i] <- aggregationAvailability(D_portfolios_table$antonymous_attack[i],
#                                                 D_portfolios_table$mr_attack[i],
#                                                 H_random_optimal_portfolio$hacktivist_gain_ddos,
#                                                 M_random_optimal_portfolio$mr_gain_ddos)

######################################################################################################################################


#  K_portfolio_simsize = 1
#  K_random_optimal_portfolio <- NULL # es el que maximiza su utilidad esperada cuando va a attackar (por el momento)
#  for (i in 1:D_portfolios_numberof) {
#    K_all_portfolios <- NULL
#    K_optimal_portfolio_sim <- NULL
#    for (j in 1:K_portfolio_simsize) {
#      # cat("Competitor simulation: ", j, "\n")
#      source("Attackers/Competitor/competitor_simulation.R", echo = echoing) # generate K_portfolio_simulation
#      K_all_portfolios <- dplyr::bind_rows(K_all_portfolios, K_portfolio_simulation) # all portfolios
#      K_portfolio_simulation <- filter(K_portfolio_simulation,
#                                     K_portfolio_simulation$comp_utility_money >=-2500000 & # c_*
#                                       K_portfolio_simulation$comp_utility_money < 5000000) # c^*  filter
#      K_portfolio_simulation
#      K_optimal_portfolio_sim <- dplyr::bind_rows(K_optimal_portfolio_sim,dplyr::slice(K_portfolio_simulation,which.max(K_portfolio_simulation$comp_utility)))
#    }
#    K_random_optimal_portfolio = dplyr::bind_rows(K_random_optimal_portfolio,dplyr::slice(K_optimal_portfolio_sim,which.max(K_optimal_portfolio_sim$comp_utility)))
#    K_random_optimal_portfolio
# }

# H_random_optimal_portfolio <- NULL # es el que maximiza su utilidad esperada cuando va a attackar (por el momento)
# H_portfolio_simsize = 1
# for (i in 1:D_portfolios_numberof) {
#   H_all_portfolios <- NULL
#   H_optimal_portfolio_sim <- NULL
#   for (j in 1:H_portfolio_simsize){ # number of simulations (each simulation generate a optimal portfolio (from all posibles))
#     # cat("Hacktivist simulation: ", j, "\n")
#     source("Attackers/Hacktivist/Hacktivist_simulation.R", echo = echoing) # se genera H_portfolio_simulation
#     H_all_portfolios <- dplyr::bind_rows(H_all_portfolios,H_portfolio_simulation) # Here we have all portfolios
#     H_portfolio_simulation <- filter(H_portfolio_simulation,
#                                    H_portfolio_simulation$hacktivist_utility_money >= -1300000 & # c_*
#                                      H_portfolio_simulation$hacktivist_utility_money < 2600000 ) # c^*
#     H_optimal_portfolio_sim <- dplyr::bind_rows(H_optimal_portfolio_sim,dplyr::slice(H_portfolio_simulation, 
#                                                                                    which.max(H_portfolio_simulation$hacktivist_utility)))
#   }
#   H_random_optimal_portfolio = dplyr::bind_rows(H_random_optimal_portfolio, dplyr::slice(H_optimal_portfolio_sim,which.max(H_optimal_portfolio_sim$hacktivist_utility)))
#   H_random_optimal_portfolio
# }

# CY_random_optimal_portfolio <- NULL
# CY_portfolio_simsize = 1
# for (i in 1:D_portfolios_numberof) {
#   CY_all_portfolios <- NULL
#   CY_optimal_portfolio_sim <- NULL
#   for (j in 1:CY_portfolio_simsize) {
#     # cat("Simulation Cybercriminals: ", j, "\n")
#     source("Attackers/Cybercriminal/cybercriminal_simulation.R", echo = echoing)
#     CY_all_portfolios <- dplyr::bind_rows(CY_all_portfolios, CY_portfolio_simulation) # all portfolios generated
#     CY_portfolio_simulation <- filter(CY_portfolio_simulation, # this filter needs some simulation
#                                       CY_portfolio_simulation$cybercriminal_utility_money>=-12000000 & # temporal
#                                         CY_portfolio_simulation$cybercriminal_utility_money<24000000)    # filter between (-1.300.000,2.600.000)
#     CY_optimal_portfolio_sim <- dplyr::bind_rows(CY_optimal_portfolio_sim,dplyr::slice(CY_portfolio_simulation,
#                                                                                        which.max(CY_portfolio_simulation$cybercriminal_utility)))
#   }
#   CY_random_optimal_portfolio = dplyr::bind_rows(CY_random_optimal_portfolio,
#                                                  dplyr::slice(CY_optimal_portfolio_sim,which.max(CY_optimal_portfolio_sim$cybercriminal_utility)))
#   CY_random_optimal_portfolio
#   }

# M_random_optimal_portfolio <- NULL
# M_portfolio_simsize = 1
# for (i in 1:D_portfolios_numberof) {
#   M_all_portfolios <- NULL
#   M_optimal_portfolio_sim <- NULL
#   for (j in 1:M_portfolio_simsize) {
#     # cat("MR simulation: ", j, "\n")
#     source("Attackers/Mr/mr_simulation.R", echo = echoing)
#     M_all_portfolios <- dplyr::bind_rows(M_all_portfolios, M_portfolio_simulation) # all portfolios generated
#     M_portfolio_simulation <- filter(M_portfolio_simulation,
#                                      M_portfolio_simulation$mr_utility_money>=-5000000 &
#                                        M_portfolio_simulation$mr_utility_money<10000000) # filter
#     M_optimal_portfolio_sim <- dplyr::bind_rows(M_optimal_portfolio_sim,dplyr::slice(M_portfolio_simulation,
#                                                                                      which.max(M_portfolio_simulation$mr_utility)))
#   }
#   M_random_optimal_portfolio = dplyr::bind_rows(M_random_optimal_portfolio,
#                                                 dplyr::slice(M_optimal_portfolio_sim,
#                                                              which.max(M_optimal_portfolio_sim$mr_utility)))
#   M_random_optimal_portfolio
# }


# Competitor (DDoS attack decision)
# K_targdos_decision <- NULL
# for (i in 1:D_portfolios_numberof) { # Competitor/targatt_competitor_decision 
#   K_targdos_decision[i] <-  kTargDosDecision()
# }
# # cat("Competitor DDoS attack decision: ", K_targdos_decision, "\n")
# 
# # Hacktivist (DDoS downtime attack decision)
# H_targdos_decision <- NULL
# for (i in 1:D_portfolios_numberof) { # Hacktivist/targatt_competitor_decision 
#   H_targdos_decision[i] <-  hTargDosDecision()
# }
# 
# # Cybercriminals (exf records and exf business records attacks)
# CY_tarexf_decision <- NULL
# for (i in 1:D_portfolios_numberof) { # Cybercriminal/targatt_cybercriminal_decision
#   CY_tarexf_decision[i] <- cyTargExfDecision()
# }
# CY_tarexf_business_decision <- NULL
# for (i in 1:D_portfolios_numberof) { # Cybercriminal/targatt_cybercriminal_decision
#   CY_tarexf_business_decision[i] <- cyTargExfBusinessDecision()
# }
# 
# # Mr (DDoS and Malware attacks)
# M_targdos_decision <- NULL
# for (i in 1:D_portfolios_numberof) { # Mr/targatt_mr_decision
#   M_targdos_decision[i] <- mTargDosDecision()
# }
# M_tarexf_decision <- NULL
# for (i in 1:D_portfolios_numberof) { # Mr/targatt_mr_decision
#   M_tarexf_decision[i] <- mTargExfDecision()
# }
# M_tarexf_business_decision <- NULL
# for (i in 1:D_portfolios_numberof) { # Mr/targatt_mr_decision
#   M_tarexf_business_decision[i] <- mTargExfBusinessDecision()
# }

# Testing removing attackers
# K_random_optimal_portfolio$K_targdos_decision = 1 
# 
# H_random_optimal_portfolio$H_targdos_decision = 0
# 
# CY_random_optimal_portfolio$CY_targexf_decision = 1
# CY_random_optimal_portfolio$CY_targexf_business_decision = 1
#   
# M_random_optimal_portfolio$M_targdos_decision = 0
# M_random_optimal_portfolio$M_targexf_decision = 0
# M_random_optimal_portfolio$M_targexf_business_decision = 0



# attacker_aggre_costs <- attackersAggregationCosts( D_portfolios_table$compeet_attack[]
#                                                     # K_random_optimal_portfolio$K_targdos_decision, 
# #                                                   
# #                                                   H_random_optimal_portfolio$H_targdos_decision,
# #                                                   
# #                                                   
# #                                                   CY_random_optimal_portfolio$CY_targexf_decision,
# #                                                   CY_random_optimal_portfolio$CY_targexf_business_decision,
# #                                                   
# #                                                   M_random_optimal_portfolio$M_targdos_decision,
# #                                                   M_random_optimal_portfolio$M_targexf_decision,
# #                                                   M_random_optimal_portfolio$M_targexf_business_decision,
#   
#                                                   K_random_optimal_portfolio$comp_market_gain, # cost competitor DDoS market share attack
#                                                   H_random_optimal_portfolio$hacktivist_gain_ddos, # cost hacktivist DDoS availability attack
#                                               
#                                                   CY_random_optimal_portfolio$cybercriminal_gain_exf_records, # cost cybercriminal exf records
#                                                   CY_random_optimal_portfolio$cybercriminal_gain_exf_business_records, # cost cybercriminal exf business records
#                                                   
#                                                   M_random_optimal_portfolio$mr_gain_ddos, # cost mr DDoS availability attack
#                                                   M_random_optimal_portfolio$mr_gain_exf_records, # cost mr exf attack
#                                                   M_random_optimal_portfolio$mr_gain_exf_business_records # cost mr exf business attack
#                                                   
# )

