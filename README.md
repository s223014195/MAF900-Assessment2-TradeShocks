# MAF900-Assessment2-TradeShocks
Reproducible workflow evaluating the energy trade shocks and Indian manufacturing margins 

## Executive Summary
This empirical project investigates the firm-level transmission of significant global oil price shocks ($\ge 15\%$ YoY) on Operating Profit Margins ($\Delta\text{OPM}_{\text{YoY}}$) across 100 Indian manufacturing firms. Using Welch's two-sample $t$-test, I evaluate whether firms in high energy-intensity sectors experience greater margin contractions compared to low energy-intensity cohorts during shock quarters.

## Key Empirical Finding
* **Welch $t$-Test Result:** $t = -0.270$, $p = 0.787$ ($df = 953.41$).
* **Conclusion:** There is **no statistically significant difference** in YoY OPM changes between high-energy ($Mean = 40.55\%$) and low-energy ($Mean = 50.55\%$) manufacturing cohorts during major oil price shocks. 
* **Economic Insight:** Indian manufacturing firms demonstrate structural resilience or pass-through pricing capacity, mitigating direct operational margin shocks. This could be due to the alternative mechnaisms, discussed in our proposal.

## Repository Architecture
├── data/                  # Raw & cleaned datasets (Protected via .gitignore)
│   ├── raw/               # Proprietary firm financials
│   └── processed/         # Cleaned panel data with 2016 panel lags
├── scripts/               # Reproducible R execution pipeline
│   ├── scripts/               # Reproducible R execution pipeline
│   ├── 01_data_loading.R
│   ├── 02_data_cleaning.R
│   ├── 03_merging_and_lagging.R
│   ├── 04_sample_filtering.R
│   └── 05_visuals_and_analysis.R  # Welch t-test & patchwork plots
├── output/                # Automated statistical exports & visuals
│   ├── figures/           # Time-series panel plots & boxplots (.png)
│   └── tables/            # Welch t-test formatted summary (.csv)
├── .gitignore             # Configured for empirical data privacy
└── README.md              # Project documentation

## How to Reproduce Analysis
1. Clone the repository: `git clone <repo-url>`
2. Open the RStudio Project (`.Rproj`).
3. Execute `scripts/05_visuals_and_analysis.R` to run the Welch $t$-test and auto-export all figures and tables into `output/`.

## Software & Dependencies
* **R Environment:** `dplyr`, `ggplot2`, `patchwork`, `broom`, `knitr`, `fixest`.