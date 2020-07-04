#! Rscript Mr/mr_detection.R --

#### MR DETECTION ----
# Check if the attacks is detected
detectionMr <- function (targdos_result,targsocial_result,attacks){
  detected <- 0
  attack_detection <- 0
  if (targdos_result == 1){
    attack_detection <- rbinom(1,attacks,.001) # detection DDoS attack
  }
  if (targsocial_result == 1){
    attack_detection <- rbinom(1,attacks,.0005) # detection social engineering attack
  }
  # cat("attack detection: ",attack_detection, "\n")
  prob_each_attack<- rbern(1,.998) # prob of each attack
  # cat("prob each attack: ", prob_each_attack, "\n")
  detected <- rbinom(1,attack_detection,prob_each_attack) # mr detection
  detected
}

# Detection cost (c_d)
detectionCostMr <- function(detected){
  detection_cost <- 0
  if (detected==1){
    detection_cost = rnorm(1,2430000,400000)
  }
  detection_cost
}