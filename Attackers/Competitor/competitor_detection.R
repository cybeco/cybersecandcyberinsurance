#! Rscript competitor_detection.R --

#### COMPETITOR DETECTION ----
# Check if the attacks is detected
competitorDetection <- function (targdos_result,attacks){
  detected <- 0
  if (detected == 0 & targdos_result == 1){
    attack_detection <- rbinom(1,attacks,.002) # the detection of each attack
    prob_each_attack<- rbern(1,.998) # prob of each attack
    detected <- rbinom(1,attack_detection,prob_each_attack) # competitor detection
  }
  detected
}

# Detection cost (c_d)
detectionCost <- function(detected){
  detection_cost <- 0
  if (detected==1){
    detection_cost = rnorm(1,2430000,400000)
  }
  detection_cost
}
