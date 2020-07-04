#! Rscript Hacktivist/hacktivist_detection.R --

#### HACKTIVIST DETECTION ----

# Check if the attacks is detected
detectionHacktivist <- function (targdos_result){
  detected <- 0
  if (targdos_result == 1){
    detected <- rbinom(1,1,.002)
  }
  detected
}

# Detection cost (c_d)
detectionCostHacktivist <- function(detected){
  detection_cost <- 0
  if (detected==1){
    detection_cost = runif(1,300000,450000)
  }
  round(detection_cost)
}