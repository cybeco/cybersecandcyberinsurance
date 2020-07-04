#! Rscript defender.R --

#### THE SCRIPT CONFIGURES THE DECISION-MAKING ----
z=0 # inicializamos z

z=1 # z=1 (Compeet), z=2 (Antonymous), z=3 (Cybegansta), z=4 (Mr), z=5 (All attackers)
cat("z: ", z, "\n")

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

# Attackers (Which attackers are going to attack) NOTE: it should be in 0 to full simulation 
compeet = 0 
antonymous = 0
cybegansta = 0
mr = 0
if (z==1){
  cat("Simulating Compeet ...\n")
  compeet = 1
}
if (z==2){
  cat("Simulating Antonymous ...\n")
  antonymous = 1
}
if (z==3){
  cat("Simulating Cybegansta...\n")
  cybegansta = 1
}
if (z==4){
  cat("Simulating Mr...\n")
  mr = 1
}
if (z==5){
  cat("Simulating all attackers... \n")
  compeet = 1
  antonymous = 1
  cybegansta = 1
  mr = 1
}

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



#### THE SCRIPT CALCULATES THE BUDGET CONSTRAINT ----
source("Input/budget_constraint.R", echo = echoing) # Budget constraint include the controls and insurance costs

#### THE SCRIPT CONFIGURES THE SIMULATION OF THE HACKTIVISTS PROBLEM ----
# Number of simulations
D_portfolio_simsize <- input_portfolio_simsize
D_portfolio_simsize <- 20
# The scripts defines the number of portfolios
D_portfolios_numberof <- portfolioSize(D_decision_portfolios)
# The script assigns a numeration to each of the individual simulations
D_portfolio_num <- portfolioNumeration(D_portfolios_numberof)
# Table with all factible portfolios
D_portfolios_table <- portfolioTable(D_portfolio_num,D_decision_portfolios)
D_portfolios_table

#### FUNCTION DEFINITIONS TO USE DURING THE PROBLEM SOLVING (defender_simulation) ----
# Threats
source("Threats/envthreats.R", echo = echoing)
source("Threats/accthreats.R", echo = echoing)
source("Threats/ntathreats.R", echo = echoing)
# Impacts
source("Impacts/insurable_impacts.R", echo = echoing)          # Impact generaged depending on threats and controls
source("Impacts/insurable_impacts_coverage.R", echo = echoing) # Impacts get reduced due to the coverage
source("Impacts/non_insurable_impacts.R", echo = echoing)      # Non insurable impacts
source("Impacts/security_insurance_cost.R", echo = echoing)    # Cost of controls and insurance
# Defencer
source("Defender/defender_utility.R", echo = echoing)          # Defender cost and utility


#### PROBLEM-SOLVING ----
# Simulation
# We perform a simulation for the different portfolios of the user case
# to obtain the optimal portfolio of such simulation (which.max(...)).
# We repeat this process a number of simulations (outer FOR loop).
# We calculate the expected utility as a moving average (last assignation).
# The expected portfolio sim table contains the expected utility of each portfolio.
# The fullsim table stores all the simulated data.

years = 100 # Default 100 years, (full simulation 1000 years)
start_time <- Sys.time() # start timer
All_optimal_portfolios <- NULL           # 718 optimal portfolios simulados (simulate each portfolio x years)
for (p in 1:D_portfolios_numberof) {     # 718 portfolios
  cat("Simulating portfolio: ", p, "\n")
  D_portfolio_simulation <- NULL         # simulate each portfolio x years
  D_portfolio_optimal_years <- NULL      # optimal portfolio of x years
  source("Defender/defender_simulation.R", echo = echoing)
  D_portfolio_simulation                 # simulate each portfolio x years
  D_portfolio_simulation[is.na(D_portfolio_simulation)] <- 0 # Remove NA
  D_portfolio_simulation
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
top_n = 5
D_top_5 <- NULL
D_top_5 = All_optimal_portfolios[order(All_optimal_portfolios$defender_utility,decreasing = TRUE),] # order to defender_utility, lower cost top
D_top_5 <- filter(D_top_5, prob_attack_comp>0 | prob_attack_anto>0 | prob_attack_cybe>0 | prob_att_mr_ddos>0 | prob_att_mr_social>0) # obligar a que haya atacado
D_top_5 = top_n(D_top_5,top_n)
D_top_5

end_time <- Sys.time()
totalDuration = end_time - start_time
library(hms)
totalDurationFormated = as.hms(totalDuration)
cat("Duration: ", round(totalDuration,2) , "minutes \n") # Total simulation duration

# Save results in .csv
if (z==1){ # Compeet
  compeetAttackCsv = paste("Output/Median/NewUtilityFunction_v3/top5MedianCompeetAttack",toString(years),"dur",toString(totalDurationFormated),".csv", sep = "_")
  write.csv(D_top_5,compeetAttackCsv)
}
if (z==2){ # Antonymous
  antoAttackCsv =  paste("Output/Median/NewUtilityFunction_v3/top5MedianAntonymousAttack",toString(years),"dur",toString(totalDurationFormated),".csv", sep = "_")
  write.csv(D_top_5,antoAttackCsv)
}
if (z==3){ # Cybegansta
  cybeAttackCsv = paste("Output/Median/NewUtilityFunction_v3/top5MedianCybeAttack",toString(years),"dur",toString(totalDurationFormated),".csv", sep = "_")
  write.csv(D_top_5,cybeAttackCsv)
}
if (z==4){ # Mr
  mrAttackCsv = paste("Output/Median/NewUtilityFunction_v3/top5MedianMrAttack",toString(years),"dur",toString(totalDurationFormated),".csv", sep = "_")
  write.csv(D_top_5,mrAttackCsv)
}

if (z==5){ # All attackers
  allAttackersCsv = paste("Output/Median/NewUtilityFunction_v3/top5AllAttackers",toString(years),"dur",toString(totalDurationFormated),".csv", sep = "_")
  write.csv(D_top_5,allAttackersCsv)
}