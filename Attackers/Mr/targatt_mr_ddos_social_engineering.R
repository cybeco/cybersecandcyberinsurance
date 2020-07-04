#! Rscript Mr/targatt_mr_ddos_social_engineering.R --


#### Modern Republic TARGETED ATTACKS ####

# DDoS (aiming at downtime)
# Num attacks (generate num of ddos attacks)
numAttacksMr <- function(targdos_decision){
  num_ddos_attacks <- 0 
  if (targdos_decision==0){0}
  else{
    num_ddos_attacks = round(rgamma(1,20,1))
  }
  num_ddos_attacks
}
# Duration (l) in hours
ddosDurationMr <- function(targdos_decision,
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

# Social engineering (aiming at exfiltrate PII and business records)
# PII records
exfAttackMr <- function (targexf_decision,
                         security_controls_obs) {
  num_records_exf <- 0
  if (targexf_decision == 0){0}
  else if (targexf_decision == 1){
    if (security_controls_obs == 0){
      num_records_exf = round(runif(1,0,200000)*0.1243)
    }else{
      red = runif(1,0.02,0.05)
      num_records_exf = round(rbinom(1,200000,red)) 
    }
    num_records_exf
  } 
  else {cat("Error in Mr/targatt_mr_ddos_social_engineering.R in exfiltration attack")}
}
# Business records
exfBusinessAttackMr <- function (targexf_business_decision,
                                 security_controls_obs) {
  num_records_business_exf <- 0
  if (targexf_business_decision == 0){0}
  else if (targexf_business_decision == 1){
    if (security_controls_obs == 0){
      num_records_business_exf = round(runif(1,0,60000)*0.1243)
    }else{
      red = runif(1,0.02,0.05)
      num_records_business_exf = round(rbinom(1,60000,red))  
    }
    num_records_business_exf
  } 
  else {cat("Error in Mr/targatt_mr_ddos_social_engineering.R in exfiltration business attack")}
}