#! Rscript Threats/envthreats.R --

#### ENVIRONMENTAL THREATS #### 
#  ---- FIRE ----
envThreatFire <- function () {
  if (envthreat_fire_included == FALSE) {0}
  else if (envthreat_fire_included == TRUE) {
    rpois(1,.022) # Poison(0.022)
  } 
  else {
    cat("Error in Threats/envthreats.R fire")}
}

# ---- FLOOD ----
envThreatFlood <- function (fd) {
  if (envthreat_flood_included == FALSE) {0}
  else if (envthreat_flood_included == TRUE) {
      if (fd == 1){ # flood doors implemented
        rpois(1,.044) # Poison(0.44)
      }else{
        rpois(1,.44) # Poison(0.044)
      }
  } 
  else {
    cat("Error in Threats/envthreats.R flood")}
}