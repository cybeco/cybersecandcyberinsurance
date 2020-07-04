#! Rscript competitor.R --

#### THE SCRIPT CONFIGURES THE DECISION-MAKING ----
source("Attackers/Competitor/security_portfolio_options.R", echo = echoing) # Competitor observers if the defender has controls
# Competitor decisions
ifelse(tarthreat_dos_included == TRUE,
       targdos_options <- c(1,0),
       targdos_options <-  c(0))
K_decision_portfolios <- expand.grid(K_targdos_decision = targdos_options,
                                     cloud = K_security_portfolio_options) # Competitor/security_portfolio_options.R

K_decision_portfolios
#### CONFIGURATION OF THE COMPETITOR PROBLEM ----
# Number of simulations per decision portfolio
K_portfolio_simsize <- input_portfolio_simsize
K_portfolio_simsize = 100
cat("Num of simulations per portfolio: ", K_portfolio_simsize)
# Number of portfolios
K_portfolios_numberof <- portfolioSize(K_decision_portfolios)
cat("Num of portfolios: ", K_portfolios_numberof)
# Numeration to each of the individual simulations
K_portfolio_num <- portfolioNumeration(K_portfolios_numberof)
cat("Portfolio numeration: ", K_portfolio_num)
# Table with the individual simulations and their decision portfolio
K_portfolios_table <- portfolioTable(K_portfolio_num, K_decision_portfolios)
cat("Portfolios table: ")
K_portfolios_table

#### FUNCTIONS OF EACH NODE ----
source("Attackers/Competitor/targatt_competitor_ddos.R", echo = echoing)    # DDoS attacks and attack duration
source("Attackers/Competitor/competitor_impacts.R", echo = echoing)         # Impacts function
source("Attackers/Competitor/competitor_detection.R", echo = echoing)       # Detection prob function
source("Attackers/Competitor/competitor_utility.R", echo = echoing)         # Utility function

#### THE SCRIPT SOLVES THE COMPETITOR PROBLEM THROUGH SIMULATION ----

# Simulation:
# For each security control observed, we obtain the optimal decision portfolio of the competitor
# We repeat this process a number of times based on the size of the simulation defined 
# by the user [K_security_portfolio_simsize]. The K_optimal_portfolio_sim table contains 
# the optimal portfolio in each individual simulation.
K_all_portfolios <- NULL
K_optimal_portfolio_sim <- NULL
for (j in 1:K_portfolio_simsize) {
  cat("Competitor simulation: ", j, "\n")
    source("Attackers/Competitor/competitor_simulation.R", echo = echoing) # generate K_portfolio_simulation
    K_all_portfolios <- dplyr::bind_rows(K_all_portfolios, K_portfolio_simulation) # all portfolios
    K_portfolio_simulation <- filter(K_portfolio_simulation,
                                     K_portfolio_simulation$comp_utility_money >=-2500000 & # c_*
                                     K_portfolio_simulation$comp_utility_money < 5000000) # c^*  filter
    K_portfolio_simulation
    K_optimal_portfolio_sim <- dplyr::bind_rows(K_optimal_portfolio_sim,dplyr::slice(K_portfolio_simulation,which.max(K_portfolio_simulation$comp_utility)))
}
K_optimal_portfolio_sim

# From all optimal portfolios, the competitor take the attack with max expected utility
K_random_optimal_portfolio <- NULL
K_random_optimal_portfolio = dplyr::bind_rows(K_random_optimal_portfolio,
                                              dplyr::slice(K_optimal_portfolio_sim,
                                                           which.max(K_optimal_portfolio_sim$comp_utility)))
K_random_optimal_portfolio


# FORECAST
for (lola in 0:2){
totalProbCloud = 0
totalProbNoCloud = 0
for (c in 1:0){
cat("-----------Cloud:", c, "-------------\n")
ifelse(tarthreat_dos_included == TRUE,
       targdos_options <- c(1,0),
       targdos_options <-  c(0))
# duration_forecast <- c(0,120,240,360,480)
duration_forecast = seq(0, 30, by=1)
K_decision_portfolios_forecast <- expand.grid(K_targdos_decision = targdos_options,
                                     cloud = c(c),
                                     duration_forecast = duration_forecast) # result of Competitor observation

K_decision_portfolios_forecast

K_portfolios_numberof <- portfolioSize(K_decision_portfolios_forecast)
K_portfolio_num <- portfolioNumeration(K_portfolios_numberof)
K_portfolios_table_forecast <- portfolioTable(K_portfolio_num, K_decision_portfolios_forecast)


K_all_portfolios_forecast <- NULL
K_portfolio_simulation_forecast <- NULL
K_optimal_portfolio_sim_forecast <- NULL
K_portfolio_simsize = 10000+31
forecast = 1

ola = seq(0, 10000, by=1000) # vector to check problem progression
for (j in 1:K_portfolio_simsize) {
  if (j %in% ola){
    cat("Competitor simulation forecast: ", j, "\n")
  }
  source("Attackers/Competitor/competitor_simulation_forecast.R", echo = echoing) # generate K_portfolio_simulation
  K_all_portfolios_forecast <- dplyr::bind_rows(K_all_portfolios_forecast, K_portfolio_simulation_forecast) # all portfolios
  K_portfolio_simulation_forecast <- filter(K_portfolio_simulation_forecast,
                                          K_portfolio_simulation_forecast$comp_utility_money >=-3200000 & # c_* 
                                          K_portfolio_simulation_forecast$comp_utility_money < 6100000)   # c^*
  
  K_optimal_portfolio_sim_forecast <- dplyr::bind_rows(K_optimal_portfolio_sim_forecast,
                                      dplyr::slice(K_portfolio_simulation_forecast,
                                      which.max(K_portfolio_simulation_forecast$comp_utility))) # maximizing expected utility
}
K_optimal_portfolio_sim_forecast 


# Output forecast results
for (p in duration_forecast){
if (c==1){
  resultCloud = filter(K_optimal_portfolio_sim_forecast, K_optimal_portfolio_sim_forecast$duration_forecast==p &  
                                                         K_optimal_portfolio_sim_forecast$cloud==1)
  resultCloud
  probCloud = round(sum(resultCloud$K_targdos_decision==1)/K_portfolio_simsize,3)
  cat("Duration:", p, " Prob attack with cloud: ", probCloud, "\n")
  totalProbCloud = totalProbCloud + probCloud
}
if(c==0){
  resultNoCloud = filter(K_optimal_portfolio_sim_forecast, K_optimal_portfolio_sim_forecast$duration_forecast==p &  
                                                           K_optimal_portfolio_sim_forecast$cloud==0)
  resultNoCloud
  probNoCloud = round(sum(resultNoCloud$K_targdos_decision==1)/K_portfolio_simsize,3)
  cat("Duration:", p, "Prob attack No cloud:", probNoCloud, "\n")
  totalProbNoCloud = totalProbNoCloud + probNoCloud
}
}

}

cat("Total prob cloud:", totalProbCloud, "\n")
cat("Total prob no cloud:", totalProbNoCloud, "\n")
}