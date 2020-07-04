#! Rscript frontend_input.R --

#### INPUT FROM THE FRONT END USER ----
# This file is where the CYBECO Toolbox provides its input.
# In this case, the front end user is the end user of the CYBECO Toolbox.
# Procedure:
# 1 - The end user provides his input to the CYBECO Toolbox.
# 2 - The CYBECO Toolbox writes that input in this file, in a valid R format.
# 3 - Once launched, the R script reads this file.

## Backend inputs ##
# Number of simulations for each combination of user decisions
input_portfolio_simsize <- 50
input_exact_statistics <- 1 # no sé si es necesario
# Cybersecurity team hourly rate
input_cybersecurity_team_hourly_rate <- 100
# The years to amortize the CAPEX
amortization_years <- 5 # no sé si es necesario
# The hours worked per employee
employee_annual_hours <- 1500 # no sé si es necesario
# Defender utility parameters
# input_utility_defender_rho <- -4.5267*10^(-7)
# input_utility_defender_coef_exp <- 0.066
# Hacktivists utility parameters
# input_utility_hacktivists_rho <- 4.5267*10^(-7)
# input_utility_hacktivists_coef_exp <- 0.066
# Cybercriminals utility parameters
# input_utility_cybercriminals_rho <- 4.5267*10^(-7)
# input_utility_cybercriminals_coef_exp <- 0.066
rho <- -4.5267*10^(-7) # utility rho for defender and attackers
coef_exp <- 0.066 # utility coef_exp for defender and attackers
## Backend inputs ##


# Type of company
input_company <- 1 # no se si es necesario
# Assets
input_facilities <- 1
input_facilities_value <- 1000000
input_it_infrastructure <- 1
input_computers <- 300
input_servers <- 40
input_personal_information <- 1
input_personal_information_records <- 200000
input_personal_information_records_business <- 66000
# Other organisation features
input_turnover <- 1
input_turnover_value <- 2000000
input_employees <- 1
input_employees_number <- 50
# Impacts
input_impacts_to_equipment <- 1
input_impacts_to_market_share <- 1
input_impacts_to_availability <- 1
input_impacts_to_records_exposed <- 1
input_impacts_to_business_info <- 1
input_recovery <- 1

# Threats
# Enviromental
input_threat_fire <- 1
input_threat_flood <- 1
# Accidental
input_threat_employee_error <- 1
input_threat_misconfiguration <- 1
# Non-targeted
input_nontarg_threat_virus <- 1
input_nontarg_threat_ransomware <- 1
input_nontarg_threat_acchit <- 1
# Targeted
input_targ_threat_dos <- 1
input_targ_threat_data_manipulation <- 1
input_targ_threat_social_engineering <- 1
input_targ_threat_data_exfiltration <- 1
input_targ_threat_data_business_exfiltration <- 1
input_targ_threat_malware <- 1
# Actors
input_actor_competitor <- 1
input_actor_hacktivist <- 1 
input_actor_cyber_criminal <- 1
input_actor_mr <- 1

# Security controls
# Sprk (Fire protection)
input_technical_sprk_protection <- 1
input_technical_sprk_protection_compliance <- 1
input_technical_sprk_protection_implementation <- 0
input_technical_sprk_protection_capex <- 600
# Firewall
input_technical_gateways <- 1
input_technical_gateways_compliance <- 1
input_technical_gateways_implementation <- 0
input_technical_gateways_capex <- 5600
# FD (Flood doors)
input_technical_fd <- 1
input_technical_fd_compliance <- 1
input_technical_fd_implementation <- 0
input_technical_fd_capex <- 4800
# DDoS protection
input_technical_ddos_prot <- 1
input_technical_ddos_prot_compliance <- 1
input_technical_ddos_prot_implementation <- 0
input_technical_ddos_prot_capex <- 12000
# Secure configuration (Secconfig)
input_technical_configuration <- 1
input_technical_configuration_compliance <- 1
input_technical_configuration_implementation <- 0
input_technical_configuration_capex <- 1000
# Access control system (ACS)
input_technical_access <- 1
input_technical_access_compliance <- 1
input_technical_access_implementation <- 0
input_technical_access_capex <- 6000
# Malware protection
input_technical_malware <- 1
input_technical_malware_compliance <- 1
input_technical_malware_implementation <- 0
input_technical_malware_capex <- 4000
# Patch vulnerability management (PVM)
input_non_technical_patch_vulnerability <- 1
input_non_technical_patch_vulnerability_compliance <- 1
input_non_technical_patch_vulnerability_implementation <- 0
input_non_technical_patch_vulnerability_capex <- 1600
# Intrussion detection system (IDS)
input_technical_ids <- 1
input_technical_ids_compliance <- 1
input_technical_ids_implementation <- 0
input_technical_ids_capex <- 30000

# Insurance products (sólo uno de ellos se puede tener en cuenta, de momento cyber2)
# Conventional (cover equipment(Comp) (70%))
input_insurance_conventional_equipment <- 1
input_insurance_conventional_compliance <- 1
input_insurance_conventional_implementation <- 0
input_insurance_conventional_price <- 3000
input_insurance_conventional_equipment_coverage <- 0.7
# Cyber1 (cover market_share(50%),exfiltration(30%),business_info(30%))
input_insurance_cyber1_market_share <- 1
input_insurance_cyber1_exfiltration <- 1
input_insurance_cyber1_business_info <- 1
input_insurance_cyber1_compliance <- 1
input_insurance_cyber1_implementation <- 0
input_insurance_cyber1_price <- 7000
input_insurance_cyber1_market_share_coverage <- 0.5
input_insurance_cyber1_exfiltration_coverage <- 0.3
input_insurance_cyber1_business_info_coverage <- 0.3
# Cyber2 (cover market_share(50%),availability(50%),exfiltration(30%),business_info(30%))
input_insurance_cyber2_market_share <- 1
input_insurance_cyber2_availability <- 1
input_insurance_cyber2_exfiltration <- 1
input_insurance_cyber2_business_info <- 1
input_insurance_cyber2_compliance <- 1
input_insurance_cyber2_implementation <- 0
input_insurance_cyber2_price <- 12000
input_insurance_cyber2_market_share_coverage <- 0.5
input_insurance_cyber2_availability_coverage <- 0.5
input_insurance_cyber2_exfiltration_coverage <- 0.3
input_insurance_cyber2_business_info_coverage <- 0.3

# Budget
input_budget <- 1
# input_budget_total_value <- 72000
input_budget_total_value <- 60400 # firewall and acs always included (72000-11600=60400)
# Fines
input_fines <- 60000
