#! Rscript defender.R --

#### THE SCRIPT CONFIGURES THE DECISION-MAKING ----
# for (z in 1:6){
  # cat("z: ", z, "\n")
  # if (z==1){
  #   cat("z: ", z, "attack Compeet and Antonymous \n")
  #   attackers = c(1,1,0,0) # attack Compeet and Antonymous
  # }
  # if (z==2){
  #   cat("z: ", z, "attack Compeet and Cybegansta \n")
  #   attackers = c(1,0,1,0) # attack Compeet and Cybegansta
  # }
  # if (z==3){
  #   cat("z: ", z, "attack Compeet and Mr \n")
  #   attackers = c(1,0,0,1) # attack Compeeet and Mr
  # }
  # if (z==4){
  #   cat("z: ", z, "attack Antonymous and Cybegansta \n")
  #   attackers = c(0,1,1,0) # attack Antonymous and Cybegansta
  # }
  # if (z==5){
  #   cat("z: ", z, "attack Antonymous and Mr \n")
  #   attackers = c(0,1,0,1) # attack Antonymous and Mr
  # }
  # if (z==6){
  #   cat("z: ", z, "attack Cybegansta and Mr \n")
  #   attackers = c(0,0,1,1) # attack Cybegansta and Mr
  # }
# CONTROLS (firewall, acs, always included)
sprk_protection_options <- techctrl_sprk_protection_options
fd_options <- techctrl_fd_options
ddos_prot_options <- techctrl_ddos_prot_options
secconfig_options <- techctrl_secconfig_options
malwprot_options <- techctrl_malwprot_options
patchvul_options <- proctrl_patchvul_options
ids_options <- techctrl_ids_options

ifelse(techctrl_sprk_protection_options == TRUE,
       sprk_protection_options <- c(1,0),
       sprk_protection_options <-  c(0))
ifelse(techctrl_fd_options == TRUE,
       fd_options <- c(1,0),
       fd_options <-  c(0))
ifelse(techctrl_ddos_prot_options == TRUE,
       ddos_prot_options <- c(1,0),
       ddos_prot_options <-  c(0))
ifelse(techctrl_secconfig_options == TRUE,
       secconfig_options <- c(1,0),
       secconfig_options <-  c(0))
ifelse(techctrl_malwprot_options == TRUE,
       malwprot_options <- c(1,0),
       malwprot_options <-  c(0))
ifelse(proctrl_patchvul_options == TRUE,
       patchvul_options <- c(1,0),
       patchvul_options <-  c(0))
ifelse(techctrl_ids_options == TRUE,
       ids_options <- c(1,0),
       ids_options <-  c(0))

# INSURANCES
conventional_options <- insurance_conventional_options
cyber1_options <- insurance_cyber1_options
cyber2_options <- insurance_cyber2_options

ifelse(insurance_conventional_options == TRUE,
       conventional_options <- c(1,0),
       conventional_options <-  c(0))
ifelse(insurance_cyber1_options == TRUE,
       cyber1_options <- c(1,0),
       cyber1_options <-  c(0))
ifelse(insurance_cyber2_options == TRUE,
       cyber2_options <- c(1,0),
       cyber2_options <-  c(0))


# Attackers (Which attackers are going to attack)
# compeet = attackers[1] # c(1,0) 
# compeet = c(1,0)
compeet = 1
# antonymous = attackers[2] # c(1,0)
# antonymous = c(1,0)
antonymous = 1
# cybegansta = attackers[3] # c(1,0)
# cybegansta = c(1,0)
cybegansta = 1
# mr = attackers[4]  # c(1,0)
# mr = c(1,0)
mr = 1

# if (z==1){
#   cat("Simulating Compeet ...\n")
#   compeet = 1
# }
# if (z==2){
#   cat("Simulating Antonymous ...\n")
#   antonymous = 1
# }
# if (z==3){
#   cat("Simulating Cybegansta...\n")
#   cybegansta = 1
# }
# if (z==4){
#   cat("Simulating Mr...\n")
#   mr = 1
# }

# Decision portfolio with all the possible combinations of decisions
D_decision_portfolios <- expand.grid(compeet_attack = compeet,
                                     antonymous_attack = antonymous, 
                                     cybegansta_attack = cybegansta,
                                     mr_attack = mr,
                                     sprk_protection = sprk_protection_options,
                                     fd = fd_options,
                                     ddos_prot = ddos_prot_options,
                                     secconfig = secconfig_options,
                                     malwprot = malwprot_options,
                                     patchvul = patchvul_options,
                                     ids = ids_options,
                                     ins_conventional = conventional_options,
                                     ins_cyber1 = cyber1_options,
                                     ins_cyber2 = cyber2_options)
D_decision_portfolios

# Only two attackers at the same  time
D_decision_portfolios <- filter(D_decision_portfolios, compeet_attack+antonymous_attack+cybegansta_attack+mr_attack>=2)
D_decision_portfolios

#### THE SCRIPT CALCULATES THE BUDGET CONSTRAINT ----
source("Input/budget_constraint.R", echo = echoing) # Budget constraint include the controls and insurance costs
# source("Input/insurance_constraint.R", echo = echoing) # Filter portfolios insurance constraint

#### THE SCRIPT CONFIGURES THE SIMULATION OF THE HACKTIVISTS PROBLEM ----
# Number of simulations
D_portfolio_simsize <- input_portfolio_simsize
D_portfolio_simsize <- 20 # reduced to 3 temporal
# cat("Number of sim per portfolio: ", D_portfolio_simsize)
# The scripts defines the number of portfolios
D_portfolios_numberof <- portfolioSize(D_decision_portfolios)
# cat("Number of portfolios: ", D_portfolios_numberof)
# The script assigns a numeration to each of the individual simulations
D_portfolio_num <- portfolioNumeration(D_portfolios_numberof)
# cat("Asign numeration: ", D_portfolio_num)
# Table with all factible portfolios
D_portfolios_table <- portfolioTable(D_portfolio_num,D_decision_portfolios)
D_portfolios_table

#### FUNCTION DEFINITIONS TO USE DURING THE PROBLEM SOLVING (defender_simulation) ----
# Threats
source("Threats/envthreats.R", echo = echoing)
source("Threats/accthreats.R", echo = echoing)
source("Threats/ntathreats.R", echo = echoing)
# Attackers decisions
# source("Attackers/Competitor/targatt_competitor_decision.R", echo = echoing) # si el attacante tiene intención de atacar (K_targdos_decision == 1 )
                                                                             # se simula la decisión final según los controles del defensor
# source("Attackers/Hacktivist/targatt_hacktivist_decision.R", echo = echoing) # get hacktivist decision DDoS attack 
# source("Attackers/Cybercriminal/targatt_cybercriminal_decision.R", echo = echoing) # get cybercriminal decision (Exf records and exf busines records)
# source("Attackers/Mr/targatt_mr_decision.R", echo = echoing) # Get mr DDoS and Social Engineering atttack decision

# Impacts
source("Impacts/insurable_impacts.R", echo = echoing) # Impact generaged depending on threats and controls
source("Impacts/insurable_impacts_coverage.R", echo = echoing) # Impacts get reduced due to the coverage
source("Impacts/non_insurable_impacts.R", echo = echoing) # non insurable impacts
source("Impacts/security_insurance_cost.R", echo = echoing) # Cost of controls and insurance

# Defencer
source("Defender/defender_utility.R", echo = echoing) # defender cost and utility



#### PROBLEM-SOLVING ----
# Simulation
# We perform a simulation (loaded script) for the different portfolios of the user case
# to obtain the optimal portfolio of such simulation (which.max(...)).
# We repeat this process a number of simulations (outer FOR loop).
# We calculate the expected utility as a moving average (last assignation).
# The expected portfolio sim table contains the expected utility of each portfolio.
# The fullsim table stores all the simulated data.

# library(foreach)
# library(doParallel)
# numCores=4

# registerDoParallel(numCores)
years = 100
start_time <- Sys.time() # start chronometer
All_optimal_portfolios <- NULL # 718 optimal portfolios simulados (cada portfolios simulado x years)
for (p in 1:D_portfolios_numberof) { # 718 portfolios

# for (p in 1:20){ # TEMPORAL
# foreach(p=1:20) %dopar% { 
  # p = 9 # TEMPORAL , 9 has ddos_prot
  cat("Simulating portfolio: ", p, "\n")
  D_portfolio_simulation <- NULL # simulación del portfolio x years
  D_portfolio_optimal_years <- NULL # optimal portfolio of x years
  source("Defender/defender_simulation_full.R", echo = echoing)
  D_portfolio_simulation # simulación del portfolio x years
  # Simplify information (overview of 1 portfolios simulated years)
  D_portfolio_optimal_years <- data.frame(prob_attack_comp = sum(K_optimal_per_year$K_targdos_decision)/years,
                                          prob_attack_anto = sum(H_optimal_per_year$H_targdos_decision)/years,
                                          prob_attack_cybe = sum(CY_optimal_per_year$CY_targsocial_engineering_decision)/years,
                                          prob_att_mr_ddos = sum(Mr_optimal_per_year$M_targdos_decision)/years,
                                          prob_att_mr_social = sum(Mr_optimal_per_year$M_targsocial_engineering_decision)/years,
                                          portf_num = p,
                                          sprk = D_portfolios_table[p,]$sprk_protection,
                                          fd = D_portfolios_table[p,]$fd,
                                          ddos_prot = D_portfolios_table[p,]$ddos_prot,
                                          secconfig = D_portfolios_table[p,]$secconfig,
                                          malwprot = D_portfolios_table[p,]$malwprot,
                                          patchvul = D_portfolios_table[p,]$patchvul,
                                          ids = D_portfolios_table[p,]$ids,
                                          conventional = D_portfolios_table[p,]$ins_conventional,
                                          cyber1 = D_portfolios_table[p,]$ins_cyber1,
                                          cyber2 = D_portfolios_table[p,]$ins_cyber2,
                                          cost_controls = D_portfolio_simulation[1,]$cost_controls_insurance,
                                          defender_cost = sum(D_portfolio_simulation$defender_cost)/years,
                                          defender_utility = sum(D_portfolio_simulation$defender_utility)/years)
  D_portfolio_optimal_years
  All_optimal_portfolios <- dplyr::bind_rows(All_optimal_portfolios, D_portfolio_optimal_years)                                  
  All_optimal_portfolios
}

# Get top 5 portfolios
# D_optimal_portfolio_sim <- 
top_n = 5
D_top_5 <- NULL
D_top_5 = All_optimal_portfolios[order(All_optimal_portfolios$defender_cost),] # order to defender_cost, lower cost top
D_top_5 = top_n(D_top_5,top_n)
D_top_5

end_time <- Sys.time()
totalDuration = end_time - start_time
library(hms)
totalDurationFormated = as.hms(totalDuration)
cat("Duration: ", round(totalDuration,2) , "minutes \n")

variousAttackersCsv = paste("Output/Median/NewUtilityFunction/VariousAttackers/top5Median","years",toString(years),"attackers",toString(attackers),"dur",toString(totalDurationFormated),".csv", sep = "_")
write.csv(D_top_5,variousAttackersCsv)

# if (D_portfolios_table$compeet_attack[1]==1){
#   compeetAttackCsv = paste("Output/Median/top5MedianCompeetAttack",toString(years),"dur",toString(totalDurationFormated),".csv", sep = "_")
#   write.csv(D_top_5,compeetAttackCsv)
# }
# if (D_portfolios_table$antonymous_attack[1]==1){
#   antoAttackCsv =  paste("Output/Median/top5MedianAntonymousAttack",toString(years),"dur",toString(totalDurationFormated),".csv", sep = "_")
#   write.csv(D_top_5,antoAttackCsv)
# }
# if (D_portfolios_table$cybegansta_attack[1]==1){
#   cybeAttackCsv = paste("Output/Median/top5MedianCybeAttack",toString(years),"dur",toString(totalDurationFormated),".csv", sep = "_")
#   write.csv(D_top_5,cybeAttackCsv)
# }
# if (D_portfolios_table$mr_attack[1]==1){
#   mrAttackCsv = paste("Output/Median/top5MedianMrAttack",toString(years),"dur",toString(totalDurationFormated),".csv", sep = "_")
#   write.csv(D_top_5,mrAttackCsv)
# }


#  }
###################################################################################################

# FORECAST DIFFERENT ATTACKER ATTACKS
# for (a in 1:7) {
# cat("Full simulation: ", a, "\n")  
# Attackers (Which attackers are going to attack)
# compeet = 0  
# antonymous = 0 
# cybegansta = 1 
# mr = 0 
#   
# # Decision portfolio with all the possible combinations of decisions
# D_decision_portfolios <- expand.grid(compeet_attack = compeet,
#                                        antonymous_attack = antonymous, 
#                                        cybegansta_attack = cybegansta,
#                                        mr_attack = mr,
#                                        sprk_protection = sprk_protection_options,
#                                        fd = fd_options,
#                                        ddos_prot = ddos_prot_options,
#                                        secconfig = secconfig_options,
#                                        malwprot = malwprot_options,
#                                        patchvul = patchvul_options,
#                                        ids = ids_options,
#                                        ins_conventional = conventional_options,
#                                        ins_cyber1 = cyber1_options,
#                                        ins_cyber2 = cyber2_options)
# D_decision_portfolios
# source("Input/budget_constraint.R", echo = echoing) # Budget constraint include the controls and insurance costs
# 
# D_portfolio_simsize <- input_portfolio_simsize
# D_portfolio_simsize <- 100 # reduced to 3 temporal
# # cat("Number of sim per portfolio: ", D_portfolio_simsize)
# # The scripts defines the number of portfolios
# D_portfolios_numberof <- portfolioSize(D_decision_portfolios)
# # cat("Number of portfolios: ", D_portfolios_numberof)
# # The script assigns a numeration to each of the individual simulations
# D_portfolio_num <- portfolioNumeration(D_portfolios_numberof)
# # cat("Asign numeration: ", D_portfolio_num)
# # Table with all factible portfolios
# D_portfolios_table <- portfolioTable(D_portfolio_num,D_decision_portfolios)
# D_portfolios_table

###################################################################################################################################

# start_time <- Sys.time() # start chronometer
# D_fullsim_table <- NULL
# D_optimal_portfolio_sim <- NULL
# D_expected_portfolio_sim <- dplyr::mutate(D_decision_portfolios, cost_insurance, defender_cost = 0, expected_utility = 0)

# for (i in 1:D_portfolio_simsize) {
  # cat('\r',floor(100*i/D_portfolio_simsize), "% of defender problem completed ...")
#   cat("Defender simulation: ", i, "\n")
#   source("Defender/defender_simulation.R", echo = echoing)
#   D_fullsim_table <- dplyr::bind_rows(D_fullsim_table, D_portfolio_simulation) # All simulations
#   D_optimal_portfolio_sim <- dplyr::bind_rows(D_optimal_portfolio_sim,
#                                              dplyr::slice(D_portfolio_simulation,
#                                               which.max(D_portfolio_simulation$defender_utility))) # maximizing expected utility
  
  # Al porfolio experado le sumas la utilidad experada dividido entre el número de portfolios generado
  # cat("\n 1: ", D_expected_portfolio_sim$cost_insurance, "\n")
  # cat("\n 2: ", D_portfolio_simulation$cost_insurance, "\n")
  # D_expected_portfolio_sim$cost_controls_insurance <- D_portfolio_simulation$cost_controls_insurance # add cost insurance
  # D_expected_portfolio_sim$defender_cost <- D_portfolio_simulation$defender_cost # add defender cost
#   D_expected_portfolio_sim$expected_utility <- D_expected_portfolio_sim$expected_utility+ # esta esta a 0 
#                                                  D_portfolio_simulation$defender_utility/D_portfolio_simsize # expected utility div num portfolios
  # D_expected_portfolio_sim$expected_utility <- D_portfolio_simulation$defender_utility
  
# }
# D_optimal_portfolio_sim
# D_optimal_portfolio_sim <- D_optimal_portfolio_sim[order(D_optimal_portfolio_sim$defender_cost),] # order to defender_cost
# D_optimal_portfolio_sim = dplyr::slice(D_optimal_portfolio_sim,
#                           which.max(D_optimal_portfolio_sim$defender_utility))
# D_optimal_portfolio_sim

# Get top 5 portfolios
# top_n = 30
# D_optimal_portfolio_sim = top_n(D_optimal_portfolio_sim,top_n)
# D_optimal_portfolio_sim

# Simplify information
# D_optimal_portfolio_sim <- select(D_optimal_portfolio_sim, # dataframe
#                             compeet_attack, antonymous_attack, cybegansta_attack, mr_attack, # adversary attacks
#                             sprk_protection, fd, ddos_prot, secconfig,malwprot,patchvul,ids, # controls                                                                                                                  
#                             ins_conventional,ins_cyber1, ins_cyber2, # insurance options
#                             cost_controls_insurance, # cost controls + insurance
#                             defender_cost, # expected_cost
#                            defender_utility) # expected utilities
# print(unique(D_optimal_portfolio_sim))

# end_time <- Sys.time()
# cat("Duration: ", end_time - start_time, "minutes \n")





# Max expected from top 5
# D_optimal_portfolio_sim = dplyr::slice(D_optimal_portfolio_sim, which.max(D_optimal_portfolio_sim$defender_utility))
# print(D_optimal_portfolio_sim)
# cat("\n\n")
# }





###############################################################################################################################

# D_top_portfolios <- D_fullsim_table
# D_top_portfolios <- select(D_top_portfolios, # dataframe
#                            compeet_attack, antonymous_attack, cybegansta_attack, mr_attack, # adversary attacks
#                            sprk_protection, fd, ddos_prot, secconfig,malwprot,patchvul,ids, # controls                                                                                                                  
#                            ins_conventional,ins_cyber1, ins_cyber2, # insurance options
#                            cost_controls_insurance, # cost controls + insurance
#                            defender_cost, # expected_cost
#                            defender_utility) # expected utilities
# 
# resultAttackCompeet = filter(D_top_portfolios, D_top_portfolios$compeet_attack==1 &
#                                D_top_portfolios$antonymous_attack == 0 &
#                                D_top_portfolios$cybegansta_attack == 0 &
#                                D_top_portfolios$mr_attack == 0)
# 
# resultAttackCompeet = dplyr::slice(resultAttackCompeet,
#                                    which.max(resultAttackCompeet$defender_utility))
# 
# resultAttackCompeet
# 
# resultAttackAntonymous = filter(D_top_portfolios, D_top_portfolios$compeet_attack==0 &
#                                D_top_portfolios$antonymous_attack == 1 &
#                                D_top_portfolios$cybegansta_attack == 0 &
#                                D_top_portfolios$mr_attack == 0)
# 
# resultAttackAntonymous = dplyr::slice(resultAttackAntonymous,
#                                     which.max(resultAttackAntonymous$defender_utility))
# 
# resultAttackAntonymous
# 
# 
# resultAttackCybegansta = filter(D_top_portfolios, D_top_portfolios$compeet_attack==0 &
#                                   D_top_portfolios$antonymous_attack == 0 &
#                                   D_top_portfolios$cybegansta_attack == 1 &
#                                   D_top_portfolios$mr_attack == 0)
# 
# resultAttackCybegansta = dplyr::slice(resultAttackCybegansta,
#                                       which.max(resultAttackCybegansta$defender_utility))
# 
# resultAttackCybegansta
# 
# resultAttackMr = filter(D_top_portfolios, D_top_portfolios$compeet_attack==0 &
#                                   D_top_portfolios$antonymous_attack == 0 &
#                                   D_top_portfolios$cybegansta_attack == 0 &
#                                   D_top_portfolios$mr_attack == 1)
# 
# resultAttackMr = dplyr::slice(resultAttackMr,
#                               which.max(resultAttackMr$defender_utility))
# 
# resultAttackMr







############################################################################

# D_top_portfolios <- D_fullsim_table[order(D_fullsim_table$defender_cost),]
# D_top_portfolios <- D_expected_portfolio_sim[order(D_expected_portfolio_sim$defender_cost),]
# 
# # Filter to show only num_portfolio, portfolios, Insurance_option, Insurance_cost, Investment, Expected_cost, Expected_utilities
# D_top_portfolios <- select(D_top_portfolios, # dataframe
#                            sprk_protection, fd, ddos_prot, secconfig,malwprot,patchvul,ids, # controls                                                                                                                  
#                            ins_conventional,ins_cyber1, ins_cyber2, # insurance options
#                            cost_controls_insurance, # cost controls + insurance
#                            defender_cost, # expected_cost
#                            expected_utility) # expected utilities
# 
# # Return the top n portfolios
# top_n = 5
# D_top_portfolios = top_n(D_top_portfolios,top_n)
# D_top_portfolios

