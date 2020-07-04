#! Rscript Threats/ntathreats.R --

#### NON-TARGETED THREATS ####
# --- COMPUTER VIRUS (PC) ----
ntaThreatVirusPC <- function (secconfig,
                              malwprot,
                              patchvul,
                              ids) { # ids is new
  num_computers_infected = 0
  fwallgways = 1
  acctrl = 1
  if (ntathreat_virus_included == FALSE) {0}
  else if (ntathreat_virus_included == TRUE) {
          if(fwallgways == 1) {
            comred_coef <- 0.005
          }else{
            comred_coef <- 0.005+0.33
          }
          if(secconfig == 1) {comred_coef <- comred_coef*0.25}
          if(malwprot == 1) {comred_coef <- comred_coef*0.75}
          if(patchvul == 1) {comred_coef <- comred_coef*0.5}
          if(ids == 1) {comred_coef <- comred_coef*0.5}
          num_computers_infected = rbinom(1,300,12*comred_coef) # Binomial(300,12*q1)
          num_computers_infected
        } 
  else {
    cat("Error in Threats/ntathreats computer virus (PC)")
    }
  }
# --- COMPUTER VIRUS (SERVER) ----
ntaThreatVirusServer <- function (secconfig,
                                  malwprot,
                                  patchvul,
                                  ids ) { # ids is new
  num_servers_infected = 0
  fwallgways = 1
  acctrl = 1
  if (ntathreat_virus_included == FALSE) {0}
  else if (ntathreat_virus_included == TRUE) {
          if(fwallgways == 1) {
            comred_coef <- 0.005
          }else{
            comred_coef <- 0.005+0.23
          }
          if(ids == 1) {comred_coef <- comred_coef*0.5} # new
          if(secconfig == 1) {comred_coef <- comred_coef*0.25}
          if(malwprot == 1) {comred_coef <- comred_coef*0.75}
          if(patchvul == 1) {comred_coef <- comred_coef*0.5}
          num_servers_infected = rbinom(1,40,12*comred_coef) # Binomial(300,12*q1)
          num_servers_infected
  } else {
    cat("Error in Threats/ntathreats computer virus (Server)")
  }
}
# --- RANSOMWARE ----
ntaThreatRansomware <- function (ids,
                                 secconfig,
                                 pvm, # patch vulnerability management
                                 malwprot){
  fwallgways = 1 # always implemented
  if (ntathreat_ransomware_included == FALSE) {0}
  else if (ntathreat_ransomware_included == TRUE) {
    comred_coef <- 0.66
      if(fwallgways == 1) {comred_coef <- comred_coef*0.5}
      if(ids == 1) {comred_coef <- comred_coef*0.13}
      if(secconfig == 1) {comred_coef <- comred_coef*0.5}
      if(pvm == 1) {comred_coef <- comred_coef*0.5}
      if(malwprot == 1) {comred_coef <- comred_coef*0.9}
      red_coef <- .34 + comred_coef
      rpois(1,0.0528*red_coef)
  } else {cat("Error in Threats/ntathreats in ransomware")}
}
