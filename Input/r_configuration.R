#! Rscript r_configuration.R --
#### R CONFIGURATION #### 
# Specify the packages needed
packages <-  c("dplyr","tidyr","extraDistr", "hms")
# Install dplyr, tidyr, extraDistr if are not installed
list.of.packages <- c("dplyr", "tidyr", "extraDistr", "hms")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

# The script loads the packages
package.check <- lapply(packages,
                        FUN = function(x) {
                          if (!require(x, character.only = TRUE)) {
                            library(x, character.only = TRUE)
                          }
                        })
rm(packages, package.check)
# Select whether to echo the source code
echoing <- FALSE
# Select whether to turn on/off the warning messages (warn=0-->on,warn=-1-->off)
options(warn=-1)
# Check analysis time
input_analysis_time <- TRUE

