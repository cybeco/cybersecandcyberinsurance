# A Case Study in Cybersecurity Resource Allocation and Cyber Insurance

This repository contains the code of the case study with the following directories:
  
* Appendix: Implementation of algorithm in Appendix
* Attackers: Attacker's problems
* Defender: Median problem
* Impacts: Code of insurable/non-insurable impacts
* Input: Code needed for input of the case
* Output: Ouput of Median problem with single or all attackers
* Threats: Contains threats code
* analysis.R: functions needed for analysis
* main.R: main code

### Prerequisites
The following R packages need to be installed (they will be installed automatically if they are not installed)

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


THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
