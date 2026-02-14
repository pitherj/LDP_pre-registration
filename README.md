# Living Data Project: Pre-registration Analyses

This repository contains the analysis (and associated data and code) for the pre-registration associated with the study "Assessing Open Science Practices Among Graduates of the Living Data Project, a Canada-wide Graduate Training Program".

## Overview

**Research Question:** Does training in open science practices (through the Living Data Project courses) lead to higher open science practice adoption rates in subsequent research publications, compared to researchers without such training?

**Study Design:** Matched-groups observational study using cumulative link mixed models (CLMM) to compare open science indicators in publications.

## Project Structure

```
.
├── LDP_preregistration.qmd       # Main pre-registration document (Quarto)
├── LDP_preregistration.html      # Rendered HTML output
├── _README.md                    # This file
├── scripts/                      # All R analysis scripts
├── data/                         # All data files (with subdirectories)
├── figures/                      # All figure outputs
```

## Key Files

### Main Document

- **`LDP_preregistration.qmd`** - Pre-registration document containing hypotheses, study design, analysis plan, power analysis, and example workflow
- **`LDP_preregistration.html`** - Rendered HTML version of the pre-registration

### R Scripts (`scripts/`)

Analysis scripts are numbered sequentially:

1. **`00_LDP_simulate_dataset.R`** - Functions for generating realistic simulated data
2. **`01_ldp_power_analysis.R`** - Power analysis with mixed effects model (institution × program random effect)
3. **`01b_ldp_power_analysis_simple.R`** - Power analysis with simplified model (program fixed effect only)
4. **`02_ldp_hypothesis_test.R`** - Hypothesis testing using CLMM
5. **`03_ldp_assumptions_check.R`** - Model assumption testing
6. **`04_ldp_visualizations.R`** - Visualization functions
7. **`run_example_workflow.R`** - Complete workflow orchestrator

### Data Files (`data/`)

- **`simulated/`** - Simulated example datasets
- **`power_analysis/`** - Power analysis results and required effect sizes
- **`workflow_results/`** - Complete workflow outputs (fitted models, test results, etc.)

See `data/_DATA-DICTIONARY.md` for detailed descriptions of all data files.

### Figures (`figures/`)

Power analysis visualizations showing:
- Statistical power across sample sizes and effect sizes
- Minimum detectable effects for 80% power
- Example score distributions for different odds ratios

## Getting Started

### Prerequisites

Required R packages:
```r
install.packages(c("tidyverse", "ordinal", "emmeans", "patchwork", "furrr"))
```

### Running the Analysis

#### Option 1: Run everything from fresh start

```r
# 1a. Generate power analysis - mixed effects model (takes ~10-20 minutes)
source("scripts/01_ldp_power_analysis.R")

# 1b. Generate power analysis - simplified model (takes ~10-20 minutes)
source("scripts/01b_ldp_power_analysis_simple.R")

# 2. Run example workflow (takes ~1-2 minutes)
source("scripts/run_example_workflow.R")

# 3. Render pre-registration document
quarto::quarto_render("LDP_preregistration.qmd")
```

#### Option 2: Render with workflow embedded

```r
# Power analyses must be run first (generate figures)
source("scripts/01_ldp_power_analysis.R")
source("scripts/01b_ldp_power_analysis_simple.R")

# Then render - this will run the workflow automatically
quarto::quarto_render("LDP_preregistration.qmd")
```

### Quick Test

To verify everything is working:

```r
# Generate example workflow results only
source("scripts/run_example_workflow.R")

# Render document (uses existing power figures)
quarto::quarto_render("LDP_preregistration.qmd")
```

## Workflow Details

### Power Analysis

**Two power analyses are conducted to compare model complexity vs. convergence:**

#### mixed effects model (`01_ldp_power_analysis.R`)
- **Model:** `score ~ group + (1|stratum)` where stratum = institution × program
- **Institutions:** 6, 8, 10
- **Observations per group:** 2, 4, 6 per institution per career stage
- **Effect sizes:** OR = 1.2, 1.5, 2.0, 2.5
- **Issue:** Low convergence rates (< 0.90) indicate sample sizes insufficient for model complexity

#### Simplified Model (`01b_ldp_power_analysis_simple.R`)
- **Model:** `score ~ group + program` (program as fixed effect, no institution random effect)
- **Same scenarios** as mixed effects model for direct comparison
- **Advantage:** Dramatically improved convergence rates
- **Trade-off:** Does not model institutional heterogeneity

**Simulation details:**
- 500 iterations per scenario
- Runtime: ~10-20 minutes per analysis (parallel processing)

**Outputs:**
- Six PNG figures (3 per model, saved to `figures/`)
- Four CSV files with power estimates (2 per model, saved to `data/power_analysis/`)

### Example Workflow

Demonstrates the complete analysis pipeline with both model approaches:
1. Simulates realistic data with specified effect size
2. Fits cumulative link mixed model (CLMM) with random effects
3. Tests model assumptions (proportional odds, variance homogeneity)
4. Conducts one-sided hypothesis test (mixed effects model)
5. Fits and tests simplified model (program as fixed effect)
6. Creates visualizations of predicted probabilities

The workflow demonstrates both the complex and simplified models, showing that they produce similar treatment effect estimates while the simplified model avoids convergence issues.

**Outputs:** All results saved to `data/workflow_results/` (11 files including both model results)

## Model Specifications

**Statistical model:** Cumulative link mixed model with logit link
```
os_score ~ group + (1|stratum)
```

Where:
- `os_score`: Ordinal response (0-4, count of open science practices)
- `group`: Fixed effect (LDP vs Other)
- `stratum`: Random effect (institution × program level)

**Hypothesis test:** One-sided Wald test at α = 0.05

**Assumption tests:**
- Proportional odds: `ordinal::nominal_test()`
- Variance homogeneity: `ordinal::scale_test()`

## Data Description

The open science score (0-4) counts four practices:
1. Data sharing (repositories)
2. Code sharing (public availability)
3. Preprint sharing
4. Study registration

Based on PLOS Open Science Indicators (excluding protocol sharing).

## Authors

Jason Pither, Mathew Vis-Dunbar, and Diane Srivastava

## License

MIT License

## Citation

[PLACEHOLDER: Add citation information]

## Contact

Jason Pither (jason [dot] pither <at> ubc [dot] ca)

## Acknowledgments

This work was financially supported by NSERC CREATE and the Canadian Institute for Ecology & Evolution.
