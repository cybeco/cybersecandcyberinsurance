#! Rscript targatt_competitor_ddos.R --


#### COMPETITOR TARGETED ATTACK: DDoS Attack ----
# Simulate num ddos attacks
numDDoSAttacks <- function(targdos_decision){
  num_ddos_attacks <- 0
  if (targdos_decision == 0) {0}
  else{
    num_ddos_attacks = round(rgamma(1,5,1))
  }
  num_ddos_attacks
}
# DDoS duration (l) IN HOURS
ddosDuration <-function(targdos_decision,
                        num_ddos_attacks,
                        cloud){
  ddos_duration <-0
  if (targdos_decision == 0) {0}
  else if (targdos_decision == 1 & num_ddos_attacks>0) {
    for (j in 1:num_ddos_attacks){
      average_duration = runif(1,3.6,4.8) # v
      dispersion = runif(1,0.8,1.2) # v/mu
      individual_attack_duration <- round(rgamma(1,average_duration,dispersion))
      ddos_duration = ddos_duration + individual_attack_duration
    }
    
    if (cloud==1){
      cloud_duration <- 0
      num_attacks_cloud = round(rgamma(1,10,1))
      for (j in 1:num_attacks_cloud){
        average_duration = runif(1,3.6,4.8) # v
        dispersion = runif(1,0.8,1.2) # v/mu
        individual_attack_duration <- round(rgamma(1,average_duration,dispersion))
        cloud_duration = cloud_duration + individual_attack_duration
      }
      ddos_duration = ddos_duration - cloud_duration
      if (ddos_duration<0){ddos_duration <- 0}
    }
  }
  ddos_duration
}

cloudReduction <- function(cloud,ddos_duration){
  ddos_duration <- ddos_duration
  cloud_duration <- 0
  num_attacks_cloud = round(rgamma(1,10,1))
  if (cloud == 0){ddos_duration}
  else{
    if (cloud==1){
      for (j in 1:num_attacks_cloud){
        average_duration = runif(1,3.6,4.8) # v
        dispersion = runif(1,0.8,1.2) # v/mu
        individual_attack_duration <- round(rgamma(1,average_duration,dispersion))
        cloud_duration = cloud_duration + individual_attack_duration
      }
      ddos_duration = ddos_duration - cloud_duration
    }
  }
  if (ddos_duration<0){
    ddos_duration = 0
  }
  ddos_duration
}