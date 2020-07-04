#! Rscript main.R --

#### ARA CYBERSECURITY FRAMEWORK ####
# Set workspace
setwd("/Path/To/CybersecurityResourceAllocationAndCyberInsurance_github/")
# R configuration
cat("Configuring R and loading packages ... \n")
source("Input/r_configuration.R", echo = FALSE)

# Read and check input
cat("Reading the user input ... \n")
source("Input/input.R", echo = echoing)
source("Input/checkload_input.R", echo = echoing)
# Load some functions needed for the analysis
source("analysis.R")

# PROBLEMS
# To load the Competitor (COMPEET) problem (check that file for more detail)
source("Attackers/Competitor/competitor.R", echo = echoing)
# To load the Hacktivist (ANTONYMOUS) problem (check that file for more detail)
source("Attackers/Hacktivist/hacktivist.R", echo = echoing)
# To load the Cybercriminal (CYBEGANSTA) problem (check that file for more detail)
source("Attackers/Cybercriminal/cybercriminal.R", echo = echoing)
# To load the Modern Republic (MR) problem (check that file for more detail)
source("Attackers/Mr/mr.R", echo = echoing)

# To load the Defender (MEDIAN) problem (check that file for more detail)
source("Defender/defender.R", echo = echoing)
