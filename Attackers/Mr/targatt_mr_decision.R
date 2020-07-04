#! Rscript Mr/targatt_mr_decision.R --

#### Modern Republic TARGETED ATTACKS  ####
# DDoS decision
mTargDosDecision <- function () {
  if (thactor_mr_included == FALSE | tarthreat_dos_included == FALSE) {0}
  else if (thactor_mr_included == TRUE & tarthreat_dos_included == TRUE) {
    M_random_optimal_portfolio$M_targdos_decision
  } else (cat("Error in Attackers/Mr/targatt_mr_decision.R ddos decision"))
}

# Exfiltration records attacks
mTargExfDecision <- function(){
  if (thactor_mr_included == FALSE  | tarthreat_dataexf_included == FALSE) {0}
  else if (thactor_mr_included == TRUE  & tarthreat_dataexf_included == TRUE) {
    M_random_optimal_portfolio$M_targexf_decision
  }else (cat("Error in Mr/targatt_mr_decision.R exfiltration decision "))
  
}

# Exfiltration business records attacks
mTargExfBusinessDecision <- function(){
  if (thactor_mr_included == FALSE  | tarthreat_dataexf_business_included == FALSE) {0}
  else if (thactor_mr_included == TRUE  & tarthreat_dataexf_business_included == TRUE) {
    M_random_optimal_portfolio$M_targexf_business_decision
  }else (cat("Error in Mr/targatt_mr_decision.R exfiltration business decision "))
  
}


