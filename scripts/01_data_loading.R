
# Script 1 Data Loading

#Creating standard reproducible project directories

dirs <- c("data/raw", "data/processed", "output/tables", "output/figures", "scripts")
sapply(dirs, dir.create, recursive = TRUE, showWarnings = FALSE)

file.create("data/raw/.gitkeep")
file.create("data/processed/.gitkeep")
file.create("output/tables/.gitkeep")
file.create("output/figures/.gitkeep")


# Downloading Raw data files from Compustat and PPAC

# Required Packages

library(tidyverse)
library(here)
library(readxl)

# Loading directly from project directory raw data 

compustat_raw <- read_csv(here("data", "raw", "datarawcompustat_india_quarterly.csv"))
ppac_raw <- read_excel(here("data", "raw", "datarawppac_crude_price.xlsx"))

# View the first few rows of each dataset in the console
head(compustat_raw)
head(ppac_raw)

