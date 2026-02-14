library(ordinal)
library(tidyverse)

#===============================================================================
# ONE-SIDED HYPOTHESIS TEST IMPLEMENTATION
#===============================================================================

# Fit model
model <- clmm(os_score_ord ~ group + (1|stratum), data = data, nAGQ = 1)

# Extract coefficient table
coef_table <- coef(summary(model))
group_effect <- coef_table["groupB", ]

# Extract key statistics
log_or_estimate <- group_effect["Estimate"]
se_log_or <- group_effect["Std. Error"]
z_statistic <- group_effect["z value"]
p_value_two_sided <- group_effect["Pr(>|z|)"]

# Calculate one-sided p-value
# In clmm, groupB is the reference coding, so:
# - Negative coefficient (z < 0) means Group A > Group B (our direction of interest)
# - Positive coefficient (z > 0) means Group A < Group B (wrong direction)

if (z_statistic < 0) {
  # Evidence in the expected direction (Group A > Group B)
  p_value_one_sided <- pnorm(z_statistic)  # Left tail
} else {
  # Evidence in the wrong direction
  p_value_one_sided <- 1 - pnorm(z_statistic)  # Right tail (will be > 0.5)
}

# Calculate odds ratio and confidence interval
or_estimate <- exp(log_or_estimate)

# One-sided 95% confidence interval: OR > lower_bound
# For one-sided test, use 1.645 instead of 1.96 (corresponds to alpha = 0.05)
or_lower_one_sided <- exp(log_or_estimate - 1.645 * se_log_or)

#===============================================================================
# Report Results
#===============================================================================

cat("\n", rep("=", 80), "\n", sep = "")
cat("ONE-SIDED HYPOTHESIS TEST RESULTS\n")
cat(rep("=", 80), "\n\n", sep = "")

cat("Model: clmm(os_score_ord ~ group + (1|stratum))\n\n")

cat("Hypotheses:\n")
cat("  H0: OR ≤ 1 (training has no positive effect)\n")
cat("  H1: OR > 1 (training increases open science scores)\n")
cat("  Alpha: 0.05 (one-sided)\n\n")

cat("Test Statistics:\n")
cat("  Log-OR estimate:", round(log_or_estimate, 4), "\n")
cat("  Standard Error:", round(se_log_or, 4), "\n")
cat("  z-statistic:", round(z_statistic, 4), "\n")
cat("  p-value (one-sided):", round(p_value_one_sided, 4), "\n\n")

cat("Effect Size:\n")
cat("  Odds Ratio (OR):", round(or_estimate, 3), "\n")
cat("  95% CI (one-sided): OR >", round(or_lower_one_sided, 3), "\n\n")

# Interpretation
cat("Interpretation:\n")
if (p_value_one_sided < 0.05) {
  if (z_statistic < 0) {
    cat("  REJECT H0: Significant evidence that training increases open science scores\n")
    cat("  Trained researchers have", round(or_estimate, 2), 
        "times the odds of achieving higher scores\n")
    cat("  compared to control researchers (one-sided p =", round(p_value_one_sided, 4), ")\n")
  } else {
    cat("  DO NOT REJECT H0: Effect is in the wrong direction (p =", 
        round(p_value_one_sided, 4), ")\n")
    cat("  No evidence that training improves scores\n")
  }
} else {
  cat("  DO NOT REJECT H0: Insufficient evidence that training increases scores\n")
  cat("  (one-sided p =", round(p_value_one_sided, 4), ")\n")
}

cat("\n", rep("=", 80), "\n\n", sep = "")

#===============================================================================
# Additional Model Information
#===============================================================================

cat("Full Model Summary:\n")
print(summary(model))

#===============================================================================
# Assumption Checks (using built-in functions)
#===============================================================================

cat("\n\nASSUMPTION CHECKS:\n")
cat(rep("=", 80), "\n\n", sep = "")

# Proportional odds test
cat("1. Proportional Odds Assumption:\n")
nominal_result <- nominal_test(model)
print(nominal_result)
cat("\n")

if (nominal_result$p.value < 0.05) {
  cat("  WARNING: Proportional odds assumption may be violated\n\n")
} else {
  cat("  ✓ Proportional odds assumption is reasonable\n\n")
}

# Scale effects test
cat("2. Scale Effects (Variance Heterogeneity):\n")
scale_result <- scale_test(model)
print(scale_result)
cat("\n")

if (scale_result$p.value < 0.05) {
  cat("  WARNING: Groups may have different residual variance\n\n")
} else {
  cat("  ✓ No evidence of scale effects\n\n")
}

# Random effects
cat("3. Random Effects Summary:\n")
ranef_sd <- sqrt(as.numeric(VarCorr(model)$stratum))
cat("  Stratum SD:", round(ranef_sd, 3), "\n")
cat("  Number of strata:", nrow(ranef(model)$stratum), "\n\n")

#===============================================================================
# Create Results Table for Publication
#===============================================================================

results_table <- tibble(
  Parameter = c("Log-Odds Ratio", "Odds Ratio", "95% CI (one-sided)", 
                "z-statistic", "p-value (one-sided)"),
  Value = c(
    sprintf("%.3f (SE = %.3f)", log_or_estimate, se_log_or),
    sprintf("%.3f", or_estimate),
    sprintf("OR > %.3f", or_lower_one_sided),
    sprintf("%.3f", z_statistic),
    sprintf("%.4f", p_value_one_sided)
  )
)

cat("\n\nResults Summary Table:\n")
print(results_table, row.names = FALSE)

cat("\n", rep("=", 80), "\n", sep = "")