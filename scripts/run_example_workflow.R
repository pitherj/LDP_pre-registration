#===============================================================================
# Complete Example Workflow: Simulate Data and Run Full Analysis
# FIXED VERSION: All functions use package:: prefix
#===============================================================================

library(tidyverse)
library(ordinal)
library(emmeans)
library(stringr)

# Create output directory for results
dir.create("data/workflow_results", showWarnings = FALSE)

cat("\n================================\n")
cat("EXAMPLE WORKFLOW\n")
cat("================================\n\n")

#===============================================================================
# STEP 1: Simulate Data
#===============================================================================

cat("Step 1: Simulating example dataset...\n")

source("scripts/00_LDP_simulate_dataset.R")

seed.num <- 29531
set.seed(seed.num)
sim_result <- simulate_example_dataset(
  n_institutions = 8,
  min_ldp_per_inst = 3,
  max_ldp_per_inst = 6,
  equal_msc_phd_split = FALSE,
  target_or = 1.7,
  block_sd = 0.5,
  plot = FALSE,
  seed = seed.num
)

data <- sim_result$data

# Save simulated data
readr::write_csv(data, "data/workflow_results/simulated_data.csv")
saveRDS(data, "data/workflow_results/simulated_data.rds")

cat("  ✓ Data simulated and saved\n")
cat("  - Sample size:", nrow(data), "observations\n")
cat("  - Institutions:", dplyr::n_distinct(data$institution), "\n")
cat("  - Strata:", dplyr::n_distinct(data$stratum), "\n\n")

#===============================================================================
# STEP 2: Fit Model and Test Hypothesis
#===============================================================================

cat("Step 2: Fitting CLMM and testing hypothesis...\n")

# Fit the cumulative link mixed model
model <- ordinal::clmm(
  os_score_ord ~ group + (1|stratum),
  data = data,
  nAGQ = 1
)

# Extract coefficient table
coef_table <- coef(summary(model))
group_effect <- coef_table["groupOther", ]

# Extract statistics
log_or_estimate <- group_effect["Estimate"]
se_log_or <- group_effect["Std. Error"]
z_statistic <- group_effect["z value"]

# Calculate one-sided p-value
if (z_statistic < 0) {
  p_value_one_sided <- stats::pnorm(z_statistic)
} else {
  p_value_one_sided <- 1 - stats::pnorm(z_statistic)
}

# Calculate odds ratio (LDP vs Other)
or_estimate <- exp(-log_or_estimate)

# 95% CI (one-sided): OR > lower_bound
or_lower <- exp(-log_or_estimate - 1.645 * se_log_or)

# Decision
decision <- ifelse(p_value_one_sided < 0.05, "REJECT H₀", "DO NOT REJECT H₀")

# Save model and results
saveRDS(model, "data/workflow_results/fitted_model.rds")

hypothesis_results <- tibble::tibble(
  statistic = c("or_estimate", "or_lower", "p_value_one_sided",
                "z_statistic", "log_or_estimate", "se_log_or", "decision"),
  value = c(or_estimate, or_lower, p_value_one_sided,
            z_statistic, log_or_estimate, se_log_or, decision)
)

readr::write_csv(hypothesis_results, "data/workflow_results/hypothesis_results.csv")

cat("  ✓ Model fitted and hypothesis tested\n")
cat("  - Odds Ratio:", round(or_estimate, 3), "\n")
cat("  - One-sided p-value:", round(p_value_one_sided, 4), "\n")
cat("  - Decision:", decision, "\n\n")

#===============================================================================
# STEP 3: Check Model Assumptions (ROBUST METHOD)
#===============================================================================

cat("Step 3: Checking model assumptions...\n")

# Random effects (always available)
ranef_stratum <- ordinal::ranef(model)$stratum[, 1]
n_strata <- length(ranef_stratum)
ranef_sd <- stats::sd(ranef_stratum)

# Initialize results with NAs
nominal_stat <- NA
nominal_pval <- NA
scale_stat <- NA
scale_pval <- NA

# Try formal tests
cat("  Attempting formal assumption tests...\n")

# Try proportional odds test
tryCatch({
  nom_test <- ordinal::nominal_test(model)
  nominal_stat <- nom_test$statistic
  nominal_pval <- nom_test$p.value
  cat("  ✓ Proportional odds test completed\n")
}, error = function(e) {
  cat("  ✗ Proportional odds test not available\n")
})

# Try scale effects test
tryCatch({
  sc_test <- ordinal::scale_test(model)
  scale_stat <- sc_test$statistic
  scale_pval <- sc_test$p.value
  cat("  ✓ Scale effects test completed\n")
}, error = function(e) {
  cat("  ✗ Scale effects test not available\n")
})

# Alternative assessment: Visual/descriptive checks
cat("  Computing descriptive statistics...\n")

# Variance by group (for scale effects)
group_variances <- data %>%
  dplyr::group_by(group) %>%
  dplyr::summarise(
    mean_score = mean(os_score),
    sd_score = stats::sd(os_score),
    var_score = stats::var(os_score),
    .groups = "drop"
  )

var_ratio <- max(group_variances$var_score) / min(group_variances$var_score)

# Save assumption test results
assumption_results <- tibble::tibble(
  test = c("proportional_odds", "scale_effects", "random_effects",
           "variance_ratio", "group_means"),
  statistic = c(nominal_stat, scale_stat, NA, var_ratio, NA),
  p_value = c(nominal_pval, scale_pval, NA, NA, NA),
  n_strata = c(NA, NA, n_strata, NA, NA),
  ranef_sd = c(NA, NA, ranef_sd, NA, NA),
  ldp_mean = c(NA, NA, NA, NA,
               group_variances$mean_score[group_variances$group == "LDP"]),
  other_mean = c(NA, NA, NA, NA,
                 group_variances$mean_score[group_variances$group == "Other"])
)

readr::write_csv(assumption_results, "data/workflow_results/assumption_results.csv")
readr::write_csv(group_variances, "data/workflow_results/group_variances.csv")

cat("  ✓ Assumptions checked\n")
if (!is.na(nominal_pval)) {
  cat("  - Proportional odds p-value:", round(nominal_pval, 4), "\n")
} else {
  cat("  - Proportional odds: Using visual assessment\n")
}
if (!is.na(scale_pval)) {
  cat("  - Scale effects p-value:", round(scale_pval, 4), "\n")
} else {
  cat("  - Scale effects: Variance ratio =", round(var_ratio, 3), "\n")
}
cat("  - Random effects SD:", round(ranef_sd, 3), "\n")
cat("  - Number of strata:", n_strata, "\n\n")

#===============================================================================
# STEP 4: Create Visualizations
#===============================================================================

cat("Step 4: Creating visualizations...\n")

# Observed distribution
obs_dist <- data %>%
  dplyr::count(group, os_score) %>%
  dplyr::group_by(group) %>%
  dplyr::mutate(proportion = n / sum(n)) %>%
  dplyr::ungroup()

readr::write_csv(obs_dist, "data/workflow_results/observed_distribution.csv")

# Predicted probabilities
# Compute manually from model parameters since predict() doesn't work with clmm
# Get model coefficients and thresholds
model_coef <- coef(model)

# Thresholds (cut points) for the ordinal model
# Format is typically "0|1", "1|2", etc.
threshold_names <- names(model_coef)[stringr::str_detect(names(model_coef), "\\|")]
thresholds <- model_coef[threshold_names]

# Group effect (if Other group, add this to linear predictor)
group_effect <- model_coef["groupOther"]
if (is.na(group_effect)) group_effect <- 0

# Compute predicted probabilities for each group and score level
# Using inverse logit (plogis) of threshold - linear predictor
emm_df <- tibble::tibble(
  group = character(),
  os_score = numeric(),
  prob = numeric()
)

for (g in c("LDP", "Other")) {
  # Linear predictor for this group (LDP is reference, so eta = 0)
  eta <- ifelse(g == "Other", group_effect, 0)

  # Compute cumulative probabilities at each threshold
  cum_probs <- c(0, plogis(thresholds - eta), 1)

  # Category probabilities are differences between cumulative probabilities
  for (j in 1:5) {
    cat_prob <- cum_probs[j + 1] - cum_probs[j]
    emm_df <- dplyr::bind_rows(
      emm_df,
      tibble::tibble(
        group = g,
        os_score = j - 1,  # Scores 0-4
        prob = cat_prob
      )
    )
  }
}

readr::write_csv(emm_df, "data/workflow_results/predicted_probabilities.csv")

# Odds ratio contrast
emm_linear <- emmeans::emmeans(model, ~ group, mode = "linear.predictor")
contrast_result <- pairs(emm_linear, reverse = TRUE)  # pairs() is base R generic

contrast_df <- as.data.frame(contrast_result) %>%
  tibble::as_tibble() %>%
  dplyr::mutate(
    odds_ratio = exp(estimate),
    or_lower = exp(estimate - 1.96 * SE),
    or_upper = exp(estimate + 1.96 * SE)
  )

readr::write_csv(contrast_df, "data/workflow_results/odds_ratio_contrast.csv")

# Random effects for plotting
ranef_df <- tibble::tibble(
  stratum = rownames(ordinal::ranef(model)$stratum),
  random_effect = ranef_stratum
)

readr::write_csv(ranef_df, "data/workflow_results/random_effects.csv")

cat("  ✓ Visualizations data saved\n\n")

#===============================================================================
# STEP 5: SIMPLIFIED MODEL COMPARISON
#===============================================================================

cat("Step 5: Fitting simplified model (program as fixed effect)...\n")

# Fit simplified model: program as fixed effect, no random effects
model_simple <- ordinal::clm(os_score_ord ~ group + career_stage, data = data)

cat("  ✓ Simplified model fitted\n")

# Test hypothesis with simplified model
coefs_simple <- coef(summary(model_simple))
group_row_simple <- rownames(coefs_simple) == "groupOther"

if (any(group_row_simple)) {
  z_stat_simple <- coefs_simple[group_row_simple, "z value"]

  # One-sided p-value
  if (z_stat_simple < 0) {
    p_value_one_sided_simple <- pnorm(z_stat_simple)
  } else {
    p_value_one_sided_simple <- 1 - pnorm(z_stat_simple)
  }

  log_or_simple <- coefs_simple[group_row_simple, "Estimate"]
  se_log_or_simple <- coefs_simple[group_row_simple, "Std. Error"]
  # Negate to report LDP vs Other (OR > 1 means LDP has higher odds)
  or_simple <- exp(-log_or_simple)

  # One-sided 95% CI (lower bound only)
  or_lower_simple <- exp(-log_or_simple - 1.645 * se_log_or_simple)

  # Decision
  decision_simple <- ifelse(p_value_one_sided_simple < 0.05, "Reject H0", "Fail to reject H0")

  # Save simplified model results
  hypothesis_results_simple <- tibble::tibble(
    statistic = c("log_or_estimate", "se_log_or", "z_statistic", "or_estimate",
                  "or_lower", "p_value_one_sided", "decision"),
    value = as.character(c(log_or_simple, se_log_or_simple, z_stat_simple,
                          or_simple, or_lower_simple, p_value_one_sided_simple,
                          decision_simple))
  )

  readr::write_csv(hypothesis_results_simple, "data/workflow_results/hypothesis_results_simple.csv")

  cat("  ✓ Simplified model results saved\n")

  # Load complex model results for comparison
  hyp_results_complex <- readr::read_csv("data/workflow_results/hypothesis_results.csv",
                                         show_col_types = FALSE)
  or_complex <- as.numeric(hyp_results_complex$value[hyp_results_complex$statistic == "or_estimate"])
  p_value_complex <- as.numeric(hyp_results_complex$value[hyp_results_complex$statistic == "p_value_one_sided"])

  # Model comparison
  cat("\n  Model Comparison:\n")
  cat(sprintf("    Complex model OR: %.3f (p = %.4f)\n", or_complex, p_value_complex))
  cat(sprintf("    Simple model OR:  %.3f (p = %.4f)\n", or_simple, p_value_one_sided_simple))
  cat(sprintf("    Difference in OR: %.3f\n", abs(or_complex - or_simple)))

  # AIC comparison (lower is better)
  aic_complex <- AIC(model)
  aic_simple <- AIC(model_simple)
  cat(sprintf("\n    Complex model AIC: %.1f\n", aic_complex))
  cat(sprintf("    Simple model AIC:  %.1f\n", aic_simple))
  cat(sprintf("    AIC difference:    %.1f ", abs(aic_complex - aic_simple)))
  cat(ifelse(aic_simple < aic_complex, "(simple model preferred)\n", "(complex model preferred)\n"))

} else {
  cat("  ✗ Could not extract group effect from simplified model\n")
}

cat("\n")

#===============================================================================
# SUMMARY
#===============================================================================

cat("================================\n")
cat("WORKFLOW COMPLETE\n")
cat("================================\n\n")

cat("Results saved to data/workflow_results/ directory:\n")
cat("  - simulated_data.csv / .rds\n")
cat("  - fitted_model.rds (complex model with random effects)\n")
cat("  - hypothesis_results.csv (complex model)\n")
cat("  - hypothesis_results_simple.csv (simplified model)\n")
cat("  - assumption_results.csv\n")
cat("  - group_variances.csv\n")
cat("  - observed_distribution.csv\n")
cat("  - predicted_probabilities.csv\n")
cat("  - odds_ratio_contrast.csv\n")
cat("  - random_effects.csv\n\n")

# Print interpretation notes
cat("INTERPRETATION NOTES:\n")
cat("=====================\n\n")

if (is.na(nominal_pval)) {
  cat("Proportional Odds:\n")
  cat("  Formal test unavailable. Visual inspection recommended.\n\n")
}

if (is.na(scale_pval)) {
  cat("Scale Effects (Variance Homogeneity):\n")
  cat("  Formal test unavailable. Variance ratio:", round(var_ratio, 3), "\n")
  cat("  Rule of thumb: Ratio < 3.0 suggests homogeneity is reasonable.\n")
  cat("  Current ratio", ifelse(var_ratio < 3, "meets", "exceeds"),
      "this threshold.\n\n")
}

cat("Ready to render the Quarto document.\n\n")
