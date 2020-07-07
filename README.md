# A Case Study in Cybersecurity Resource Allocation and Cyber Insurance

This repository contains the code of the case of the study with the following directories:
  
* Appendix: the appendix algorithm implementation
* Attackers: the attacker's problems
* Defender: Median problem
* Impacts: the code of insurable/non-insurable impacts
* Input: all the code needed for the input of the case
* Output: contains the ouput of the Median problem with single or various attackers
* Threats: contains the threats code
* analysis.R: functions needed for the analysis
* main.R: the case main

### Prerequisites
Following packages need to be installed (they will be installed automatically if they are not installed)

```
dplyr 
tidyr
extraDistr
hms
```
* R version 3.3.2 (2016-10-31) (This case has been tested on RStudio Version 1.1.419)

### Running
open main.R
set up workspace where ACaseStudyinCybersecurityResourceAllocationAndCyberInsurance is located
run Input/r_configuration.R 
run Input/input.R
run Input/checkload_input.R
run analysis.R

To load an specific attacker problem:
  - run Attackers/Competitor/competitor.R       (Compeet problem, check this file for further details)
  - run Attackers/Hacktivist/hacktivist.R       (Antonymous problem, check this file for further details)
  - run Attackers/Cybercriminal/cybercriminal.R (Cybegansta problem, check this file for further details)
  - run Attackers/Mr/mr.R                       (Modern Republic problem, check this file for further details)
 
To load the defender problem:
  - run Defender/defender.R                     (Median problem, check this file for further details)
  
### Authors
* Alberto Redondo - *alberto.redondo@icmat.es* - 
* Aitor Couce - *coucevieira@outlook.com* - 
