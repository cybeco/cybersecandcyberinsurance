#! Rscript security_portfolio_options.R --

#### SECURITY CONTROL PORFOLIO NODE, COMPETITOR VERSION ----

# The observation is whether the defender has technical security controls or not.
if (1 %in% techctrl_fwallgways_options |
    1 %in% techctrl_fd_options |
    1 %in% techctrl_ddos_prot_options | 
    1 %in% techctrl_secconfig_options |
    1 %in% techctrl_acctrl_options |
    1 %in% techctrl_malwprot_options | 
    1 %in% proctrl_patchvul_options | 
    1 %in% techctrl_ids_options  
    ) {
  K_security_portfolio_options <- c(1,0) # Cloud protection present

} else if (techctrl_fwallgways_options == 0 &
           techctrl_fd_options == 0 &
           techctrl_ddos_prot_options == 0 &
           techctrl_secconfig_options == 0 &
           techctrl_acctrl_options == 0 &
           techctrl_malwprot_options == 0 &
           proctrl_patchvul_options == 0 &
           techctrl_ids_options == 0
           ) {
  K_security_portfolio_options <- c(0) # Cloud protection not present
} else {
  cat("Error in Competitor/security_portfolio_options.R")
  }
