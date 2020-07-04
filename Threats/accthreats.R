#! Rscript Threats/accthreats.R --

#### ACCIDENTAL THREATS #### 
# --- EMPLOYEE ERROR ----
accThreatEmpError <- function () {
  if (accthreat_employee_error_included == FALSE) {0}
  else if (accthreat_employee_error_included == TRUE) {
    rpois(1,.042) # Poisson(0.06*0.77) = Poison(0.042), here red is included  
  } else {cat("Error in Threats/accthreats.R")}
}
# --- MISCONFIGURATION ERROR ----
accThreatMisconfiguration <- function (secconfig) {
  if (accthreat_misconfiguration_included == FALSE) {0}
  else if (accthreat_misconfiguration_included == TRUE) {
    if (secconfig == 1){
      rpois(1,.04 * 0.5) # Poison(0.04*0.5)
    }else{
      rpois(1,.1) # Poison(0.01)
    }
    
  } else {cat("Error in Threats/accthreats.R")}
}