#! Rscript insurance_constraint.R --

#### THE SCRIPT CALCULATES THE BUDGET CONSTRAINT ----
# Here we introduce the following constraint:
# Whehter the insurance products require that certain security controls are installed

# quitar los portfolios que no cumplen con lo que el seguro cubre
# if cyber 1
if (cyber1_options == 1){
# D_decision_portfolios <- filter(D_decision_portfolios, fwallgways == 1 & rmp == 1 & ddos_prot ==0 & secconfig==1 & acctrl==1 & malwprot==1 & patchvul==1 & ids==1 & 
#        ins_conventional == 0 & ins_cyber1 == 1 & ins_cyber2 == 0) 
D_decision_portfolios <- filter(D_decision_portfolios,ddos_prot ==0 & 
                                  ins_conventional == 0 & ins_cyber1 == 1 & ins_cyber2 == 0) 
     # en teoría sólo se debe utilizar un sólo seguro y en este caso ddos no está cubierto
}

# if cyber 2 (los portfolios que incluyen ddos protecction los quita)
if (cyber2_options == 1){
#  D_decision_portfolios <- filter(D_decision_portfolios, fwallgways == 1 & rmp == 1 & ddos_prot ==1 & secconfig==1 & acctrl==1 & malwprot==1 & 
#       patchvul==1 & ids==1 & ins_conventional == 0 & ins_cyber1 == 0 & ins_cyber2 == 1) 
D_decision_portfolios <- filter(D_decision_portfolios,
                                ins_conventional == 0 & ins_cyber1 == 0 & ins_cyber2 == 1) 
     # en teoría sólo se debe utilizar un sólo seguro
}


#### DAMAGE INSURANCE CONSTRAINT----
# It requires the installation of the hazard protection measures
# D_decision_portfolios <- filter(D_decision_portfolios, !((hazprot == 0) & ins_damage == 1))

#### DATA INSURANCE CONSTRAINT----
# It requires the installation of the firewalls and gateways, the secure configuration, the access control,
# the malware protection and the patch and vulnerability management
# D_decision_portfolios <- filter(D_decision_portfolios, !((fwallgways == 0 | secconfig == 0 | acctrl == 0 | malwprot == 0 | patchvul == 0) & ins_data == 1))


