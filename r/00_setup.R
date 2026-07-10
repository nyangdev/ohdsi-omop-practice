# OHDSI OMOP Practice - Environment Setup
# Purpose :
# - Install and load the minimum R packages required for OHDSI practice
# - Verify that the local R environment is ready

required_packages <- c(
  "remotes",
  "SqlRender",
  "DatabaseConnector"
)

installed_packages <- rownames(installed.packages())

for (package_name in required_packages) {
  if (!package_name %in% installed_packages) {
    install.packages(package_name)
  }
}

# Install Eunomia from GitHub
if (!requireNamespace("Eunomia", quietly = TRUE)) {
  remotes::install_github("OHDSI/Eunomia")
}

library(SqlRender)
library(DatabaseConnector)
library(Eunomia)