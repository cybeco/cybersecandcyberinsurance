#! Rscript defender_utility.R --

#### DEFENDER COSTS AND UTILITY ----
# Compensation from insurance (conventional, cyber1, cyber2) 
compensationFromInsurance <- function(ins_conventional,
                                      ins_cyber1,
                                      ins_cyber2,
                                      cost_equipment,                   # accidental
                                      cost_records,                     # accidental
                                      total_cost_market_share,          # Competitor
                                      total_cost_availability,          # Hacktivist, Mr
                                      total_cost_exf_records,           # Cybercriminal, Mr
                                      total_cost_exf_business_records){ # Cybercriminal, Mr
  compensation_from_insurance <- 0
  if (ins_conventional == 1){ # conventional covers (equipment(70%))
    compensation_from_insurance = (cost_equipment*0.70)
  }
  if (ins_cyber1 == 1){ # cyber1 covers (mShare(50%), PII(30%),Business records(30%))
    compensation_from_insurance = (total_cost_market_share*0.50)+
                                  (total_cost_exf_records+cost_records*0.30)+
                                  (total_cost_exf_business_records*0.30)
  }
  if (ins_cyber2 == 1){ # cyber2 covers (mShare(50%, Avail(50%), PII(30%), Business records(30%)))
    compensation_from_insurance = (total_cost_market_share*0.50)+
                                  (total_cost_availability*0.50)+
                                  (total_cost_exf_records+cost_records*0.30)+
                                  (total_cost_exf_business_records*0.30)
  }
  compensation_from_insurance
}

# Defender costs
defenderCosts <- function(ins_conventional,      
                          ins_cyber1,
                          ins_cyber2, 
                          equip_damage,                    # d
                          cov_equipment,                   # equipmnte coverage reduction
                          market_share_loss,               # m
                          total_cost_availability,         # Hacktivist and Moneros attacks
                          cov_availability,                # downtime coverage hours reduction
                          total_cost_exf_records,          # Hacktivist and Cybergansters attacks
                          total_cost_exf_business_records, # Cybergansters attacks
                          cost_exf_records,                # cost exfiltrated records (accidental threats)
                          cost_controls,                   # c_s
                          cost_insurance,                  # c_i
                          compensation_from_insurance      # g_i
){
  defender_costs = 0
  if (cov_equipment>0){ 
    equip_damage = cov_equipment
  }
  if (cov_availability>0){
    hours_unavailability = cov_availability
  }
  defender_costs = equip_damage +
                   market_share_loss +
                   total_cost_availability +
                   (total_cost_exf_records + cost_exf_records) +  # attackers + accidental threats (include fines)
                   total_cost_exf_business_records +
                   (cost_controls + cost_insurance) -
                   compensation_from_insurance
  defender_costs = defender_costs/1000000 # convert dollars to million dollars
  defender_costs
}

# Defender utility
defenderUtility <- function(defender_costs){
  defender_utility <- 0
  defender_utility = 0.2083*(1-exp(0.2197*defender_costs))+1
  defender_utility
}