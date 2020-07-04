#! Rscript analysis.R --

#### DEFINITION OF FUNCTIONS NEEDED IN THE SIMULATION ----
# Number of decision portfolios for a given combination of decisions
portfolioSize <- function(combinations) {
   porfolio_size <- dim(combinations)[1]
}
# Generates a numeration for the decision portfolio
portfolioNumeration <- function(portfolio_size) {
   portfolio_num <- c(1:portfolio_size)
}
# Generates a table with all the decision portfolios numbered
portfolioTable <- function(portfolio_num, combinations) {
   data.frame(portfolio_num, combinations)
}

#### GENERATION OF SOME INFORMATION FOR THE ANALYSIS ----
# Estimation of total number of pii records
total_records_pii <- asset_pii_num_records
cat("TotalRecords pii: ", total_records_pii, "\n")
# Estimation of total number of business records
total_records_business <- asset_pii_num_records_business
cat("TotalRecords business: ", total_records_business, "\n")

pii_cost_record <- 825 # value per PII record stolen 
pii_cost_business_record <- 3000 # value per business record stolen
cost_hour_unavailability <- 60000 # value per hour unavailability