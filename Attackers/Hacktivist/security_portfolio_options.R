#! Rscript Attackers/Hacktivist/security_portfolio_options.R --

#### SECURITY CONTROL PORFOLIO NODE, HACKTIVIST VERSION ----

# The observation is whether the defender has security controls or not.
if (1 %in% techctrl_fwallgways_options |
    1 %in% techctrl_fd_options |
    1 %in% techctrl_ddos_prot_options | 
    1 %in% techctrl_secconfig_options |
    1 %in% techctrl_acctrl_options |
    1 %in% techctrl_malwprot_options | 
    1 %in% proctrl_patchvul_options | 
    1 %in% techctrl_ids_options  
    ) {
  H_security_portfolio_options <- c(1,0)

} else if (techctrl_fwallgways_options == 0 &
           techctrl_fd_options == 0 &
           techctrl_ddos_prot_options == 0 &
           techctrl_secconfig_options == 0 &
           techctrl_acctrl_options == 0 &
           techctrl_malwprot_options == 0 &
           proctrl_patchvul_options == 0 &
           techctrl_ids_options == 0
           ) {
  H_security_portfolio_options <- c(0)
} else {
  cat("Error in Hacktivist/security_portfolio_options")
  }
