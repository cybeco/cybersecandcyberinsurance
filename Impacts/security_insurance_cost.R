#! Rscript Impacts/security_insurance_cost.R --

#### COST OF SECURITY CONTROLS AND INSURANCE PRODUCTS ----

securityCost <- function(sprk, # Fire protection
                         fd,   # Flood doors
                         ddos_prot,
                         secconfig,
                         malwprot,
                         patchvul,
                         ids) {
  security_cost <- 0
  if (sprk == 1){
    security_cost <- security_cost + techctrl_sprk_protection_capex
  }
  if (fd == 1){
   security_cost <- security_cost + techctrl_fd_capex
  }
  if (ddos_prot == 1){
   security_cost <- security_cost + techctrl_ddos_prot_capex
  }
  if (secconfig == 1){
    security_cost <- security_cost + techctrl_secconfig_capex
  }
  if (malwprot == 1){
    security_cost <- security_cost + techctrl_malwprot_capex
  }
  if (patchvul == 1){
    security_cost <- security_cost +  proctrl_patchvul_capex
  }
 if (ids == 1){
   security_cost <- security_cost + techctrl_ids_capex
 }
  security_cost
}

insuranceCost <- function(ins_conventional,
                          ins_cyber1,
                          ins_cyber2){
  insurance_cost <- 0
  if (ins_conventional ==1){
    insurance_cost <- insurance_cost + insurance_conventional_price
  }
  if (ins_cyber1 ==1){
    insurance_cost <- insurance_cost + insurance_cyber1_price
  }
  if (ins_cyber2 ==1){
    insurance_cost <- insurance_cost + insurance_cyber2_price
  }
  insurance_cost = insurance_cost
  insurance_cost
}