#===============================================================================
# Assumption Checking for clmm model using built-in ordinal package functions
#===============================================================================

library(tidyverse)
library(ordinal)

# Fit your model
model <- clmm(os_score_ord ~ group + (1|stratum), data = data, nAGQ = 1)

cat("\n", rep("=", 80), "\n")
cat("ASSUMPTION CHECKS FOR ORDINAL MIXED MODEL\n")
cat(rep("=", 80), "\n\n")

#------------------------------------------------------------------------------
# 1. PROPORTIONAL ODDS ASSUMPTION - Using nominal_test()
#------------------------------------------------------------------------------

cat("1. PROPORTIONAL ODDS ASSUMPTION\n")
cat(rep("-", 80), "\n")

# Test if group effect varies across thresholds
nominal_result <- nominal_test(model)

print(nominal_result)

cat("\nInterpretation:\n")
cat("  - Null hypothesis: Proportional odds holds (constant effect across thresholds)\n")
cat("  - If p < 0.05: Evidence against proportional odds\n")
cat("  - If p > 0.05: Proportional odds assumption is reasonable\n\n")

if (nominal_result$p.value < 0.05) {
  cat("WARNING: Proportional odds assumption may be violated (p = ", 
      round(nominal_result$p.value, 4), ")\n")
  cat("Consider: partial proportional odds model or inspect thresholds visually\n\n")
} else {
  cat("✓ Proportional odds assumption appears reasonable (p = ", 
      round(nominal_result$p.value, 4), ")\n\n")
}

#------------------------------------------------------------------------------
# 2. SCALE EFFECTS - Using scale_test()
#------------------------------------------------------------------------------

cat("2. SCALE EFFECTS (Variance Heterogeneity)\n")
cat(rep("-", 80), "\n")

# Test if residual variance differs between groups
scale_result <- scale_test(model)

print(scale_result)

cat("\nInterpretation:\n")
cat("  - Tests whether Group A and B have different residual variability\n")
cat("  - If p < 0.05: Groups differ in variance, not just location\n")
cat("  - If p > 0.05: Homogeneous variance assumption is reasonable\n\n")

if (scale_result$p.value < 0.05) {
  cat("WARNING: Scale effects detected (p = ", 
      round(scale_result$p.value, 4), ")\n")
  cat("Consider: Fit model with scale = ~ group to account for variance differences\n\n")
  
  # Fit model with scale effect
  model_scale <- clmm(os_score_ord ~ group + (1|stratum), 
                      scale = ~ group, 
                      data = data)
  
  cat("Model with scale effect:\n")
  print(summary(model_scale))
  cat("\n")
  
} else {
  cat("✓ No evidence of scale effects (p = ", 
      round(scale_result$p.value, 4), ")\n\n")
}

#------------------------------------------------------------------------------
# 3. RANDOM EFFECTS NORMALITY
#------------------------------------------------------------------------------

cat("3. RANDOM EFFECTS DISTRIBUTION\n")
cat(rep("-", 80), "\n")

ranef_stratum <- ranef(model)$stratum[, 1]
cat("Number of strata:", length(ranef_stratum), "\n")

if (length(ranef_stratum) >= 3) {
  shapiro_test <- shapiro.test(ranef_stratum)
  cat("Shapiro-Wilk test p-value:", round(shapiro_test$p.value, 4), "\n")
  cat("(p > 0.05 suggests normality is reasonable)\n\n")
  
  if (shapiro_test$p.value < 0.05) {
    cat("WARNING: Random effects may not be normally distributed\n")
    cat("With few strata, this may not be critical. Inspect Q-Q plot.\n\n")
  } else {
    cat("✓ Random effects distribution appears reasonable\n\n")
  }
} else {
  cat("Too few strata for formal normality test. Visual inspection recommended.\n\n")
}

# Q-Q plot
ranef_df <- tibble(re = ranef_stratum)

p_qq <- ggplot(ranef_df, aes(sample = re)) +
  stat_qq() +
  stat_qq_line() +
  labs(x = "Theoretical Quantiles", y = "Sample Quantiles") +
  theme_minimal()

print(p_qq)
ggsave("assumption_check_random_effects_qq.png", p_qq, width = 6, height = 5)

# Histogram of random effects
p_hist <- ggplot(ranef_df, aes(x = re)) +
  geom_histogram(bins = min(15, length(ranef_stratum)), 
                 fill = "#0072B2", alpha = 0.7) +
  geom_vline(xintercept = 0, linetype = "dashed", color = "red") +
  labs(x = "Random Effect Estimate", y = "Count") +
  theme_minimal()

print(p_hist)
ggsave("assumption_check_random_effects_hist.png", p_hist, width = 6, height = 5)

#------------------------------------------------------------------------------
# 4. SAMPLE SIZES AND BALANCE
#------------------------------------------------------------------------------

cat("4. SAMPLE SIZES PER STRATUM\n")
cat(rep("-", 80), "\n")

sample_summary <- data %>%
  count(stratum, group) %>%
  pivot_wider(names_from = group, values_from = n, 
              values_fill = 0) %>%
  arrange(stratum)

print(sample_summary)

# Check balance
balance_check <- sample_summary %>%
  mutate(balanced = A == B)

if (all(balance_check$balanced)) {
  cat("\n✓ Perfect balance: All strata have equal n for groups A and B\n\n")
} else {
  cat("\nWARNING: Imbalanced design in some strata:\n")
  print(balance_check %>% filter(!balanced))
  cat("\n")
}

#------------------------------------------------------------------------------
# 5. CONVERGENCE AND FIT
#------------------------------------------------------------------------------

cat("5. MODEL CONVERGENCE AND FIT\n")
cat(rep("-", 80), "\n")

cat("Convergence code:", model$optRes$convergence, "\n")
cat("(0 indicates successful convergence)\n\n")

if (model$optRes$convergence != 0) {
  cat("WARNING: Model did not converge properly\n")
  cat("Consider: different starting values, simplified model, or more data\n\n")
} else {
  cat("✓ Model converged successfully\n\n")
}

# Model summary
cat("Model Summary:\n")
print(summary(model))

#------------------------------------------------------------------------------
# 6. OUTLIER/INFLUENTIAL OBSERVATIONS (Visual check)
#------------------------------------------------------------------------------

cat("\n6. OUTLIER CHECK (Visual)\n")
cat(rep("-", 80), "\n")

# Plot observed vs expected frequencies
observed_freq <- data %>%
  count(group, os_score) %>%
  group_by(group) %>%
  mutate(prop = n / sum(n))

p_observed <- ggplot(observed_freq, aes(x = os_score, y = prop, fill = group)) +
  geom_col(position = "dodge", alpha = 0.7) +
  scale_fill_manual(values = c("A" = "#0072B2", "B" = "#D55E00")) +
  scale_x_continuous(breaks = 0:5) +
  labs(x = "Open Science Score", y = "Proportion", 
       fill = "Group") +
  theme_minimal() +
  theme(legend.position = "bottom")

print(p_observed)
ggsave("assumption_check_observed_distribution.png", p_observed, 
       width = 8, height = 5)

cat("Inspect distribution for unusual patterns or extreme imbalances\n\n")

#------------------------------------------------------------------------------
# SUMMARY
#------------------------------------------------------------------------------

cat(rep("=", 80), "\n")
cat("SUMMARY OF ASSUMPTION CHECKS\n")
cat(rep("=", 80), "\n\n")

cat("Key tests:\n")
cat("  1. Proportional odds: p = ", round(nominal_result$p.value, 4), 
    ifelse(nominal_result$p.value > 0.05, " ✓", " ⚠"), "\n", sep = "")
cat("  2. Scale effects: p = ", round(scale_result$p.value, 4), 
    ifelse(scale_result$p.value > 0.05, " ✓", " ⚠"), "\n", sep = "")
if (length(ranef_stratum) >= 3) {
  cat("  3. Random effects normality: p = ", round(shapiro_test$p.value, 4), 
      ifelse(shapiro_test$p.value > 0.05, " ✓", " ⚠"), "\n", sep = "")
}
cat("  4. Convergence: ", 
    ifelse(model$optRes$convergence == 0, "Success ✓", "Failed ⚠"), "\n", sep = "")
cat("\n")

cat("Recommendations:\n")
if (nominal_result$p.value < 0.05) {
  cat("  - Consider partial proportional odds model\n")
}
if (scale_result$p.value < 0.05) {
  cat("  - Refit with scale = ~ group\n")
}
if (length(ranef_stratum) >= 3 && shapiro_test$p.value < 0.05) {
  cat("  - Check Q-Q plot; with moderate sample size, minor departures are acceptable\n")
}
if (model$optRes$convergence != 0) {
  cat("  - Address convergence issues before interpreting results\n")
}
if (nominal_result$p.value > 0.05 && scale_result$p.value > 0.05 && 
    model$optRes$convergence == 0) {
  cat("  - All key assumptions satisfied. Model appears appropriate.\n")
}

cat("\n", rep("=", 80), "\n")