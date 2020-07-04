#! Rscript Input/budget_constraint.R --

#### THE SCRIPT CALCULATES THE BUDGET CONSTRAINT ----

if (constraint_budget_included == TRUE & constraint_budget_type == 1) {
  
  source("Impacts/security_insurance_cost.R", echo = echoing)
  controls_cost <- NULL
  insurance_cost  <- NULL
  # Get control and insurance costs depending of the decision portfolios
  for (i in 1:dim(D_decision_portfolios)[1]) {
    controls_cost[i] <- securityCost(D_decision_portfolios$sprk_protection[i],
                                     D_decision_portfolios$fd[i],
                                     D_decision_portfolios$ddos_prot[i],
                                     D_decision_portfolios$secconfig[i],
                                     D_decision_portfolios$malwprot[i],
                                     D_decision_portfolios$patchvul[i],
                                     D_decision_portfolios$ids[i])
    
    insurance_cost[i] <- insuranceCost(D_decision_portfolios$ins_conventional[i], 
                                       D_decision_portfolios$ins_cyber1[i],
                                       D_decision_portfolios$ins_cyber2[i])
    
  }
  # Add the cost of the portfolios to the D_decision_portfolios dataframe
  D_decision_portfolios <- data.frame(D_decision_portfolios, controls_cost = controls_cost)
  # Add the cost of insurance
  D_decision_portfolios <- data.frame(D_decision_portfolios, insurance_cost = insurance_cost)
  # Add the cost of controls + insurance
  D_decision_portfolios <- data.frame(D_decision_portfolios, insu_plus_controls = controls_cost+insurance_cost)
  # Add budget 
  D_decision_portfolios <- data.frame(D_decision_portfolios, budget = constraint_budget_money)
  
  # Filter uncompatibles options
  # Filter the portfolios that are over the budget (controls + insurance > budget,firewall=1 and acs=1)
  D_decision_portfolios <- filter(D_decision_portfolios, insu_plus_controls < constraint_budget_money)
  # Filter insurances (not all insurances chosen)
  D_decision_portfolios <- filter(D_decision_portfolios, ins_conventional<1 | ins_cyber1<1 | ins_cyber2<1)
  # Filter insurances (choose between cyber 1 o cyber 2, both not allow)
  D_decision_portfolios <- filter(D_decision_portfolios, ins_cyber1<1 | ins_cyber2<1)
  # Filter insurances (at least sprk_protection, fd, ddos_prot, secconfig, malwprot, patchvul, ids, ins_conventional, ins_cyber1, ins_cyber2 must be choosen)
  D_decision_portfolios <- filter(D_decision_portfolios, sprk_protection>0 | fd>0 | ddos_prot>0 | secconfig>0 | malwprot>0 | patchvul>0 | ids>0 | ins_conventional>0 | ins_cyber1>0 | ins_cyber2 >0)
  # Remove columns controls, insurance and the sum costs and the budget
  D_decision_portfolios <- select(D_decision_portfolios, - controls_cost, 
                                  -insurance_cost, - insu_plus_controls, - budget)
}