#! Rscript checkload_input.R --

#### THE SCRIPT CHECKS AND LOADS THE INPUT ----
# For each of the input parameters provided by the Toolbox,
# the script does the following:
# 1 - Check whether the input values have valid values.
# 2 - Load this input as variables in the R environment.
# This is done with the "checkload" functions definded bellow.


#### THE SCRIPT DEFINES FUNCTIONS FOR CHECKING AND LOADING THE INPUT

checkLoadBooleanToLogical <- function(input) {
  ifelse(input %in% c(0,1),
         input,
         stop(substitute(input)," is not valid"))
  if (input == 0) {
    FALSE
  } else if (input == 1 ) {
    TRUE
  } else {
    stop(substitute(input)," cannot be loaded")
  }
}

checkLoadIntegerListToLogical <- function(input, integer_vector, no_value) {
  ifelse(input %in% integer_vector,
         input,
         stop(substitute(input)," is not valid"))
  ifelse(no_value %in% integer_vector,
         no_value,
         stop("error in integer vector or no_value"))
  if (input == no_value) {
    FALSE
  } else if (input %in% integer_vector ) {
    TRUE
  } else {
    stop(substitute(input)," cannot be loaded")
  }
}

checkLoadIntegerListToFactor <- function(input, integer_vector, factor_vector) {
  ifelse(input %in% integer_vector,
         input,
         stop(substitute(input)," is not valid"))
  ifelse(length(factor_vector) == length(integer_vector) &
           ! as.logical(anyDuplicated(integer_vector)) &
           ! as.logical(anyDuplicated(factor_vector)),
         factor_vector[which(integer_vector == input)],
         stop("error in integer vector or factor vector"))
}

checkLoadNonNegInteger <- function(input) {
  ifelse(is.numeric(input) &
           (input %in% c(-1) |
              input >= 0),
         input,
         stop(substitute(input)," is not valid"))
  if(input == -1) {input <- 0}
  floor(input)
}

checkLoadPercentage <- function(input) {
  ifelse(is.numeric(input) &
           (input %in% c(-1) |
              (input >= 0 & input <= 1)),
         input,
         stop(substitute(input)," is not valid"))
  if(input == -1) {input <- 0}
  round(input,4)
}

checkLoadNumeric <- function(input) {
  ifelse(is.numeric(input),
         input,
         stop(substitute(input)," is not valid"))
  input
}

#### THE SCRIPT CHECKS THE INPUT AND LOADS IT IN THE R ENVIRONMENT ----

# expert_mode <- checkLoadBooleanToLogical(input_expert)
exact_statistics <- checkLoadBooleanToLogical(input_exact_statistics)


feature_company_type <- checkLoadIntegerListToFactor(input_company,
                                                     c(1),
                                                     c(1))

# Assets
asset_facilities_included <- checkLoadBooleanToLogical(input_facilities)
asset_facilities_money <- checkLoadNonNegInteger(input_facilities_value)
asset_it_included <- checkLoadBooleanToLogical(input_it_infrastructure)
asset_num_computers <- checkLoadNonNegInteger(input_computers)
asset_num_servers <- checkLoadNonNegInteger(input_servers)
asset_pii_included <- checkLoadBooleanToLogical(input_personal_information)
asset_pii_num_records <- checkLoadNonNegInteger(input_personal_information_records)
asset_pii_num_records_business <- checkLoadNonNegInteger(input_personal_information_records_business)

# Features
feature_turnover_included <- checkLoadBooleanToLogical(input_turnover)
feature_turnover_money <- checkLoadNonNegInteger(input_turnover_value)
feature_employees_included <- checkLoadBooleanToLogical(input_employees)
feature_employees_num <- checkLoadNonNegInteger(input_employees_number)

# Impacts
impacts_to_equipment_included <- checkLoadBooleanToLogical(input_impacts_to_equipment)
impacts_to_market_share_included <- checkLoadBooleanToLogical(input_impacts_to_market_share)
impacts_to_availability_included <- checkLoadBooleanToLogical(input_impacts_to_availability)
impacts_to_records_exposed_included <- checkLoadBooleanToLogical(input_impacts_to_records_exposed)
impacts_to_business_info_included <- checkLoadBooleanToLogical(input_impacts_to_business_info)
impacts_postincident_costs_included <- checkLoadBooleanToLogical(input_recovery)

### NON-INTENTIONAL THREATS ###
# Environmental threats #
# Fire
envthreat_fire_included <- checkLoadBooleanToLogical(input_threat_fire)
# Flood
envthreat_flood_included <- checkLoadBooleanToLogical(input_threat_flood)

# Accidental threats #
# Employee error
accthreat_employee_error_included <- checkLoadBooleanToLogical(input_threat_employee_error)
# Misconfiguration
accthreat_misconfiguration_included <- checkLoadBooleanToLogical(input_threat_misconfiguration)

# Non-targeted threats #
# Computer virus
ntathreat_virus_included <- checkLoadBooleanToLogical(input_nontarg_threat_virus)
# Ransomware
ntathreat_ransomware_included <- checkLoadBooleanToLogical(input_nontarg_threat_ransomware)


### INTENTIONAL THREATS ###
# DDoS
tarthreat_dos_included <- checkLoadBooleanToLogical(input_targ_threat_dos)
# Data maniputation
tarthreat_dataman_included <- checkLoadBooleanToLogical(input_targ_threat_data_manipulation)
# Social engineering attack (include data exfiltration pii and business records)
tarthreat_social_enginerring_included <- checkLoadBooleanToLogical(input_targ_threat_social_engineering)
# Data exfiltration
tarthreat_dataexf_included <- checkLoadBooleanToLogical(input_targ_threat_data_exfiltration)
# Data business exfiltration
tarthreat_dataexf_business_included <- checkLoadBooleanToLogical(input_targ_threat_data_business_exfiltration)
# Targeted malware
tarthreat_malware_included <- checkLoadBooleanToLogical(input_targ_threat_malware)

### ACTORS ###
# Competitor (COMPEET)
thactor_competitor_included <- checkLoadIntegerListToLogical(input_actor_competitor, c(1,4),4)
# Hacktivist (ANTONYMOUS)
thactor_hacktivists_included <- checkLoadIntegerListToLogical(input_actor_hacktivist,c(1,4),4)
# Hacktivist (ANTONYMOUS) likelihood
thactor_hacktivists_likelihood <- checkLoadIntegerListToFactor(input_actor_hacktivist, c(1,4), c(0,1))
# Cybercriminals (CYBEGANSTA)
thactor_cybercriminal_included <- checkLoadIntegerListToLogical(input_actor_cyber_criminal,c(1,4),4)
# Cybercriminals (CYBEGANSTA) likelihood
thactor_cybercriminals_likelihood <- checkLoadIntegerListToFactor(input_actor_cyber_criminal, c(1,4), c(0,1))
# Modern Republic (MR)
thactor_mr_included <- checkLoadIntegerListToLogical(input_actor_mr, c(1,4),4)


checkLoadBooleanToLogical(input_technical_gateways)
checkLoadBooleanToLogical(input_technical_gateways_compliance)
checkLoadBooleanToLogical(input_technical_gateways_implementation)
# Sprk (Fire protection)
techctrl_sprk_protection_options <- if (input_technical_sprk_protection == 1 &
                                   input_technical_sprk_protection_compliance == 1 ) {
  c(1)
} else if (input_technical_sprk_protection == 1 &
           input_technical_sprk_protection_compliance == 0) {
  c(0,1)
} else if (input_technical_sprk_protection == 0 ) {
  c(0)
} else {
  stop("security control input error in sprk protection")
}
# Sprk (Fire protection capex)
techctrl_sprk_protection_capex <- if (input_technical_sprk_protection_implementation == 0 ) {
  checkLoadNonNegInteger(input_technical_sprk_protection_capex)
} else if (input_technical_sprk_protection_implementation == 1 ) {
  0
} else {
  stop("security control input error in sprk protection capex")
}

# Firewall
techctrl_fwallgways_options <- if (input_technical_gateways == 1 &
                                   input_technical_gateways_compliance == 1 ) {
  c(1)
} else if (input_technical_gateways == 1 &
           input_technical_gateways_compliance == 0) {
  c(0,1)
} else if (input_technical_gateways == 0 ) {
  c(0)
} else {
  stop("security control input is not defined correctly")
}
# Firewall capex
techctrl_fwallgways_capex <- if (input_technical_gateways_implementation == 0 ) {
  checkLoadNonNegInteger(input_technical_gateways_capex)
} else if (input_technical_gateways_implementation == 1 ) {
  0
} else {
  stop("security control input is not defined correctly")
}
# Firewall opex 
# techctrl_fwallgways_opex <- checkLoadNonNegInteger(input_technical_gateways_opex) # no sé si se usa

checkLoadBooleanToLogical(input_technical_fd)
checkLoadBooleanToLogical(input_technical_fd_compliance)
checkLoadBooleanToLogical(input_technical_fd_implementation)
# FD (Flood doors)
techctrl_fd_options <- if (input_technical_fd == 1 & input_technical_fd_compliance == 1 ) {
  c(1)
} else if (input_technical_fd == 1 & input_technical_fd_compliance == 0) {
  c(0,1)
} else if (input_technical_fd == 0 ) {
  c(0)
} else {
  stop("security control error fd")
}
# FD (Flood doors) capex
techctrl_fd_capex <- if (input_technical_fd_implementation == 0 ) { 
  checkLoadNonNegInteger(input_technical_fd_capex)
} else if (input_technical_fd_implementation == 1 ) {
  0
} else {
  stop("security control error fd capex")
}

checkLoadBooleanToLogical(input_technical_ddos_prot)
checkLoadBooleanToLogical(input_technical_ddos_prot_compliance)
checkLoadBooleanToLogical(input_technical_ddos_prot_implementation)
# DDoS protection
techctrl_ddos_prot_options <- if (input_technical_ddos_prot == 1 & input_technical_ddos_prot_compliance == 1 ) {
  c(1)
} else if (input_technical_ddos_prot == 1 & input_technical_ddos_prot_compliance == 0) {
  c(0,1)
} else if (input_technical_ddos_prot == 0 ) {
  c(0)
} else {
  stop("security control error ddos_prot")
}
# DDoS protection capex
techctrl_ddos_prot_capex <- if (input_technical_ddos_prot_implementation == 0 ) { 
  checkLoadNonNegInteger(input_technical_ddos_prot_capex)
} else if (input_technical_ddos_prot_implementation == 1 ) {
  0
} else {
  stop("security control error ddos_prot capex")
}

checkLoadBooleanToLogical(input_technical_configuration)
checkLoadBooleanToLogical(input_technical_configuration_compliance)
checkLoadBooleanToLogical(input_technical_configuration_implementation)
# Secconfig
techctrl_secconfig_options <- if (input_technical_configuration == 1 &
                                  input_technical_configuration_compliance == 1 ) {
  c(1)
} else if (input_technical_configuration == 1 &
           input_technical_configuration_compliance == 0) {
  c(0,1)
} else if (input_technical_configuration == 0 ) {
  c(0)
} else {
  stop("security control input error secconfig")
}
# Secconfig capex
techctrl_secconfig_capex <- if (input_technical_configuration_implementation == 0 ) {
  checkLoadNonNegInteger(input_technical_configuration_capex)
} else if (input_technical_configuration_implementation == 1 ) {
  0
} else {
  stop("security control input error secconfig capex")
}
# Secconfig opex
# techctrl_secconfig_opex <- checkLoadNonNegInteger(input_technical_configuration_opex) # no sé si se usa

checkLoadBooleanToLogical(input_technical_access)
checkLoadBooleanToLogical(input_technical_access_compliance)
checkLoadBooleanToLogical(input_technical_access_implementation)
# Access control system (ACS)
techctrl_acctrl_options <- if (input_technical_access == 1 &
                               input_technical_access_compliance == 1 ) {
  c(1)
} else if (input_technical_access == 1 &
           input_technical_access_compliance == 0) {
  c(0,1)
} else if (input_technical_access == 0 ) {
  c(0)
} else {
  stop("security control input error acs")
}
# Access control system (ACS) capex
techctrl_acctrl_capex <- if (input_technical_access_implementation == 0 ) {
  checkLoadNonNegInteger(input_technical_access_capex)
} else if (input_technical_access_implementation == 1 ) {
  0
} else {
  stop("security control input error acs capex")
}
# Access control system (ACS) opex
# techctrl_acctrl_opex <- checkLoadNonNegInteger(input_technical_access_opex) # no sé si se usa

checkLoadBooleanToLogical(input_technical_malware)
checkLoadBooleanToLogical(input_technical_malware_compliance)
checkLoadBooleanToLogical(input_technical_malware_implementation)

# Malware protection
techctrl_malwprot_options <- if (input_technical_malware == 1 & input_technical_malware_compliance == 1 ) {
  c(1)
} else if (input_technical_malware == 1 &
           input_technical_malware_compliance == 0) {
  c(0,1)
} else if (input_technical_malware == 0 ) {
  c(0)
} else {
  stop("security control input error malware")
}
# Malware protection capex
techctrl_malwprot_capex <- if (input_technical_malware_implementation == 0 ) { 
  checkLoadNonNegInteger(input_technical_malware_capex)
} else if (input_technical_malware_implementation == 1 ) {
  0
} else {
  stop("security control input error malware capex")
}
# Malware opex
# techctrl_malwprot_opex <- checkLoadNonNegInteger(input_technical_malware_opex) # no sé si se usa

checkLoadBooleanToLogical(input_non_technical_patch_vulnerability)
checkLoadBooleanToLogical(input_non_technical_patch_vulnerability_compliance)
checkLoadBooleanToLogical(input_non_technical_patch_vulnerability_implementation)
# Patch vulnerability management (PVM)
proctrl_patchvul_options <- if (input_non_technical_patch_vulnerability == 1 &
                                 input_non_technical_patch_vulnerability_compliance == 1 ) {
  c(1)
} else if (input_non_technical_patch_vulnerability == 1 &
           input_non_technical_patch_vulnerability_compliance == 0) {
  c(0,1)
} else if (input_non_technical_patch_vulnerability == 0 ) {
  c(0)
} else {
  stop("security control input is not defined correctly")
}
# Patch vulnerability management (PVM) capex
proctrl_patchvul_capex <- if (input_non_technical_patch_vulnerability_implementation == 0 ) {
  checkLoadNonNegInteger(input_non_technical_patch_vulnerability_capex)
} else if (input_non_technical_patch_vulnerability_implementation == 1 ) {
  0
} else {
  stop("security control input is not defined correctly")
}
# Patch vulnerability management (PVM) opex
# proctrl_patchvul_opex <- checkLoadNonNegInteger(input_non_technical_patch_vulnerability_opex) # no sé si se usa

# checkLoadBooleanToLogical(input_physical_hazard_protection)
# checkLoadBooleanToLogical(input_physical_hazard_protection_compliance)
# checkLoadBooleanToLogical(input_physical_hazard_protection_implementation)

checkLoadBooleanToLogical(input_technical_ids)
checkLoadBooleanToLogical(input_technical_ids_compliance)
checkLoadBooleanToLogical(input_technical_ids_implementation)
# Intrussion Detection System (IDS) 
techctrl_ids_options <- if (input_technical_ids == 1 & input_technical_ids_compliance == 1 ) {
  c(1)
} else if (input_technical_ids == 1 & input_technical_ids_compliance == 0) {
  c(0,1)
} else if (input_technical_ids == 0 ) {
  c(0)
} else {
  stop("security control error ids")
}
# IDS capex
techctrl_ids_capex <- if (input_technical_ids_implementation == 0 ) { 
  checkLoadNonNegInteger(input_technical_ids_capex)
} else if (input_technical_ids_implementation == 1 ) {
  0
} else {
  stop("security control error ids capex")
}

# Insurance products
# Conventional
checkLoadBooleanToLogical(input_insurance_conventional_equipment)
checkLoadBooleanToLogical(input_insurance_conventional_compliance)
checkLoadBooleanToLogical(input_insurance_conventional_implementation)

insurance_conventional_options <- if (input_insurance_conventional_equipment == 1 &&
                                input_insurance_conventional_compliance == 1 ) {
  c(1)
} else if (input_insurance_conventional_equipment == 1 &&
           input_insurance_conventional_compliance == 0) {
  c(0,1)
} else if (input_insurance_conventional_equipment == 0 ) {
  c(0)
} else {
  stop("security control input error conventional insurance")
}
insurance_conventional_price <- checkLoadNonNegInteger(input_insurance_conventional_price)
insurance_conventional_equipment_coverage <- checkLoadPercentage(input_insurance_conventional_equipment_coverage)

# Cyber1
checkLoadBooleanToLogical(input_insurance_cyber1_market_share)
checkLoadBooleanToLogical(input_insurance_cyber1_exfiltration)
checkLoadBooleanToLogical(input_insurance_cyber1_business_info)
checkLoadBooleanToLogical(input_insurance_cyber1_compliance)
checkLoadBooleanToLogical(input_insurance_cyber1_implementation)

insurance_cyber1_options <- if (input_insurance_cyber1_market_share  == 1  &&
                                input_insurance_cyber1_exfiltration  == 1  &&
                                input_insurance_cyber1_business_info == 1  &&
                                input_insurance_cyber1_compliance    == 1 ) {
  c(1)
} else if (input_insurance_cyber1_market_share == 1  &&
           input_insurance_cyber1_exfiltration == 1  &&
           input_insurance_cyber1_business_info == 1 &&
           input_insurance_cyber1_compliance == 0) {
  c(0,1)
} else if (input_insurance_cyber1_market_share == 0  &&
           input_insurance_cyber1_exfiltration == 0  &&
           input_insurance_cyber1_business_info == 0 ) {
  c(0)
} else {
  stop("security control input error cyber1 insurance")
}
insurance_cyber1_price <- checkLoadNonNegInteger(input_insurance_cyber1_price)
insurance_cyber1_market_share_coverage <- checkLoadPercentage(input_insurance_cyber1_market_share_coverage)
insurance_cyber1_exfiltration_coverage <- checkLoadPercentage(input_insurance_cyber1_exfiltration_coverage)
insurance_cyber1_business_info_coverage <- checkLoadPercentage(input_insurance_cyber1_business_info_coverage)

# Cyber2
checkLoadBooleanToLogical(input_insurance_cyber2_market_share)
checkLoadBooleanToLogical(input_insurance_cyber2_availability)
checkLoadBooleanToLogical(input_insurance_cyber2_exfiltration)
checkLoadBooleanToLogical(input_insurance_cyber2_business_info)
checkLoadBooleanToLogical(input_insurance_cyber2_compliance)
checkLoadBooleanToLogical(input_insurance_cyber2_implementation)

insurance_cyber2_options <- if (input_insurance_cyber2_market_share == 1  &&
                                input_insurance_cyber2_availability == 1  &&
                                input_insurance_cyber2_exfiltration == 1  &&
                                input_insurance_cyber2_business_info == 1 &&
                                input_insurance_cyber2_compliance == 1) {
  c(1)
} else if (input_insurance_cyber2_market_share == 1  &&
           input_insurance_cyber2_availability == 1  &&
           input_insurance_cyber2_exfiltration == 1  &&
           input_insurance_cyber2_business_info == 1 &&
           input_insurance_cyber2_compliance == 0) {
  c(0,1)
} else if (input_insurance_cyber2_market_share  == 0  &&
           input_insurance_cyber2_availability  == 0  &&
           input_insurance_cyber2_exfiltration  == 0  &&
           input_insurance_cyber2_business_info == 0) {
  c(0)
} else {
  stop("security control input error cyber2 insurance")
}
insurance_cyber2_price <- checkLoadNonNegInteger(input_insurance_cyber2_price)
insurance_cyber2_market_share_coverage <- checkLoadPercentage(input_insurance_cyber2_market_share_coverage)
insurance_cyber2_availability_coverage <- checkLoadPercentage(input_insurance_cyber2_availability_coverage)
insurance_cyber2_exfiltration_coverage <- checkLoadPercentage(input_insurance_cyber2_exfiltration_coverage)
insurance_cyber2_business_info_coverage <- checkLoadPercentage(input_insurance_cyber2_business_info_coverage)

# Constraint budget 
constraint_budget_included <- checkLoadIntegerListToLogical(input_budget, c(1,3),3)
# Constraint budget type
constraint_budget_type <- checkLoadIntegerListToFactor(input_budget, c(1,3), c(1,3))
# Constraint budget money
constraint_budget_money <- checkLoadNonNegInteger(input_budget_total_value)
# Utility defender rho
# utility_defender_rho <- checkLoadNumeric(input_utility_defender_rho)
# Utility defender coef
# utility_defender_coef_exp <- checkLoadNumeric(input_utility_defender_coef_exp)
utility_rho <- checkLoadNumeric(rho)
utility_coef_exp<- checkLoadNumeric(coef_exp)
# Cybersecurity team hourly rate
cybersecurity_team_hourly_rate <- checkLoadNumeric(input_cybersecurity_team_hourly_rate)
# Fines
fines <- checkLoadNonNegInteger(input_fines)