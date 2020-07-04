#! Rscript mr.R --

#### THE SCRIPT CONFIGURES THE DECISION-MAKING ----
source("Attackers/Mr/security_portfolio_options.R", echo = echoing) # Mr observers if the defender has controls
# Mr decisions
ifelse(tarthreat_dos_included == TRUE,
       targdos_options <- c(1,0),
       targdos_options <-  c(0))
ifelse(tarthreat_social_enginerring_included == TRUE,
       targsocial_enginerring_options <- c(1,0),
       targsocial_enginerring_options <- c(0))

M_decision_portfolios <- expand.grid(M_targdos_decision = targdos_options,
                                     M_targsocial_engineering_decision = targsocial_enginerring_options,
                                     cloud = M_security_portfolio_options)


#### CONFIGURATION OF THE Modern Republic PROBLEM ----
# Number of simulations per decision portfolio
M_portfolio_simsize <- input_portfolio_simsize
M_portfolio_simsize = 50 
cat("Num of simulations per portfolio: ", M_portfolio_simsize, "\n")
# Number of portfolios
M_portfolios_numberof <- portfolioSize(M_decision_portfolios)
cat("Num of portfolios: ", M_portfolios_numberof, "\n")
# Numeration to each of the individual simulations
M_portfolio_num <- portfolioNumeration(M_portfolios_numberof)
cat("Portfolio numeration: ", M_portfolio_num, "\n")
# Table with the individual simulations and their decision portfolio
M_portfolios_table <- portfolioTable(M_portfolio_num, M_decision_portfolios)
cat("Portfolios table: ")
M_portfolios_table

#### FUNCTIONS OF EACH NODE ----
source("Attackers/Mr/targatt_mr_ddos_social_engineering.R", echo = echoing)  # DDoS and malware attacks
source("Attackers/Mr/mr_impacts.R", echo = echoing)                          # Impacts function
source("Attackers/Mr/mr_detection.R", echo = echoing)                        # Detection prob function
source("Attackers/Mr/mr_utility.R", echo = echoing)                          # Utility function

#### THE SCRIPT SOLVES THE MR PROBLEM THROUGH SIMULATION ----

# For each security control observed, we perform an individual simulation to obtain the optimal decision portfolio
# We repeat this process a number of times based on M_security_portfolio_simsize
# The M_optimal_portfolio_sim table contains the optimal portfolio in each individual simulation.
M_all_portfolios <- NULL
M_optimal_portfolio_sim <- NULL
for (j in 1:M_portfolio_simsize) {
  cat("MR simulation: ", j, "\n")
  source("Attackers/Mr/mr_simulation.R", echo = echoing)
  M_all_portfolios <- dplyr::bind_rows(M_all_portfolios, M_portfolio_simulation)
  M_portfolio_simulation <- filter(M_portfolio_simulation,
                                   M_portfolio_simulation$mr_utility_money>=-4400000 &
                                   M_portfolio_simulation$mr_utility_money<8800000)
  M_optimal_portfolio_sim <- dplyr::bind_rows(M_optimal_portfolio_sim,dplyr::slice(M_portfolio_simulation,
                                                                                     which.max(M_portfolio_simulation$mr_utility)))
}
M_optimal_portfolio_sim

# # From all optimal portfolios, MR takes the attack with max expected utility
M_random_optimal_portfolio <- NULL
M_random_optimal_portfolio = dplyr::bind_rows(M_random_optimal_portfolio,
                                              dplyr::slice(M_optimal_portfolio_sim,
                                              which.max(M_optimal_portfolio_sim$mr_utility)))
M_random_optimal_portfolio


# FORECAST
# Mr decisions
for (c in 1:0){
cat("-----------Cloud:", c, "-------------\n")
ifelse(tarthreat_dos_included == TRUE,
       targdos_options <- c(1,0),
       targdos_options <-  c(0))
ifelse(tarthreat_social_enginerring_included == TRUE,
       targsocial_enginerring_options <- c(1,0),
       targsocial_enginerring_options <- c(0))
M_decision_portfolios <- expand.grid(M_targdos_decision = targdos_options,
                                     M_targsocial_engineering_decision = targsocial_enginerring_options,
                                     cloud = c(c))

M_portfolios_numberof <- portfolioSize(M_decision_portfolios)
# Numeration to each of the individual simulations
M_portfolio_num <- portfolioNumeration(M_portfolios_numberof)
# Table with the individual simulations and their decision portfolio
M_portfolios_table <- portfolioTable(M_portfolio_num, M_decision_portfolios)


M_all_portfolios_forecast <- NULL
M_optimal_portfolio_sim_forecast <- NULL
M_portfolio_simsize = 10000+4 
ola = seq(0, 10000, by=1000) # vector to check forecast progression
for (j in 1:M_portfolio_simsize) {
  if (j %in% ola){
    cat("Mr simulation: ", j, "\n")
  }
  source("Attackers/Mr/mr_simulation_forecast.R", echo = echoing)
  M_all_portfolios_forecast <- dplyr::bind_rows(M_all_portfolios_forecast, M_portfolio_simulation_forecast)
  M_portfolio_simulation_forecast <- filter(M_portfolio_simulation_forecast,
                                    M_portfolio_simulation_forecast$mr_utility_money>=-5000000 &
                                       M_portfolio_simulation_forecast$mr_utility_money<10000000) 
  M_optimal_portfolio_sim_forecast <- dplyr::bind_rows(M_optimal_portfolio_sim_forecast,dplyr::slice(M_portfolio_simulation_forecast,
                                                                                   which.max(M_portfolio_simulation_forecast$mr_utility)))
}
M_optimal_portfolio_sim_forecast


# Output forecast results
resultDos = filter(M_optimal_portfolio_sim_forecast,(M_optimal_portfolio_sim_forecast$M_targdos_decision==1 &
                                                    M_optimal_portfolio_sim_forecast$M_targsocial_engineering_decision==0))
probAttackDDoS = round(sum(resultDos$M_targdos_decision)/M_portfolio_simsize, 3)
cat("Prob attack ddos: ", probAttackDDoS, "\n")


resultSocialAttack = filter(M_optimal_portfolio_sim_forecast,M_optimal_portfolio_sim_forecast$M_targdos_decision==0 &
                                                             M_optimal_portfolio_sim_forecast$M_targsocial_engineering_decision==1)
probSocialAttack = round(nrow(resultSocialAttack)/M_portfolio_simsize, 3)
cat("Prob attack social engineering: ", probSocialAttack, "\n")

resultBoth = filter(M_optimal_portfolio_sim_forecast,M_optimal_portfolio_sim_forecast$M_targdos_decision==1 &  
                                                     M_optimal_portfolio_sim_forecast$M_targsocial_engineering_decision==1)

probAttackBoth = round(nrow(resultBoth)/M_portfolio_simsize, 3)
cat("Prob attack both: ", probAttackBoth, "\n")


resultNone = filter(M_optimal_portfolio_sim_forecast,M_optimal_portfolio_sim_forecast$M_targdos_decision==0 &
                                                     M_optimal_portfolio_sim_forecast$M_targsocial_engineering_decision==0)
probAttackNone = round(nrow(resultNone)/M_portfolio_simsize, 3)
cat("Prob attack none: ", probAttackNone, "\n")


}