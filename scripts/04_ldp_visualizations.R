library(emmeans)
library(ggplot2)

# Fit your model
model <- clmm(os_score_ord ~ group + (1|stratum), data = data, nAGQ = 1)

#===============================================================================
# 1. ESTIMATED MARGINAL PROBABILITIES FOR EACH SCORE
#===============================================================================

# Get predicted probabilities for each outcome level
emm <- emmeans(model, ~ group, mode = "prob")

# Extract and format for plotting
emm_df <- as.data.frame(emm) %>%
  as_tibble() %>%
  mutate(
    os_score = as.numeric(gsub("prob\\.", "", cut)) - 1  # Extract score from "prob.0", "prob.1", etc.
  )

# Plot probability distributions
p_probs <- ggplot(emm_df, aes(x = os_score, y = prob, fill = group)) +
  geom_col(position = "dodge", alpha = 0.8) +
  geom_errorbar(aes(ymin = asymp.LCL, ymax = asymp.UCL),
                position = position_dodge(width = 0.9), width = 0.2) +
  scale_fill_manual(
    values = c("A" = "#0072B2", "B" = "#D55E00"),
    labels = c("Group A (trained)", "Group B (control)")
  ) +
  scale_x_continuous(breaks = 0:4) +
  scale_y_continuous(labels = scales::percent_format()) +
  labs(
    x = "Open Science Score",
    y = "Predicted Probability",
    fill = NULL
  ) +
  theme_minimal(base_size = 12) +
  theme(legend.position = "bottom")

print(p_probs)
ggsave("model_predicted_probabilities.png", p_probs, width = 8, height = 5, dpi = 300)

#===============================================================================
# 2. CUMULATIVE PROBABILITIES (P(Y ≥ k))
#===============================================================================

# Get cumulative probabilities
emm_cum <- emmeans(model, ~ group, mode = "cum.prob")

emm_cum_df <- as.data.frame(emm_cum) %>%
  as_tibble() %>%
  mutate(
    threshold = as.numeric(gsub("cum.prob\\.", "", cut))
  )

# Plot cumulative probabilities
p_cum <- ggplot(emm_cum_df, aes(x = threshold, y = cum.prob, 
                                color = group, group = group)) +
  geom_line(linewidth = 1) +
  geom_point(size = 3) +
  geom_errorbar(aes(ymin = asymp.LCL, ymax = asymp.UCL), width = 0.1) +
  scale_color_manual(
    values = c("A" = "#0072B2", "B" = "#D55E00"),
    labels = c("Group A (trained)", "Group B (control)")
  ) +
  scale_x_continuous(breaks = 0:4) +
  scale_y_continuous(labels = scales::percent_format()) +
  labs(
    x = "Open Science Score Threshold",
    y = "P(Score ≥ Threshold)",
    color = NULL
  ) +
  theme_minimal(base_size = 12) +
  theme(legend.position = "bottom")

print(p_cum)
ggsave("model_cumulative_probabilities.png", p_cum, width = 8, height = 5, dpi = 300)

#===============================================================================
# 3. MEAN SCORE (LINEAR PREDICTOR SCALE)
#===============================================================================

# Get estimated marginal means on linear predictor scale
emm_linear <- emmeans(model, ~ group, mode = "linear.predictor")

# Convert to data frame and plot
emm_linear_df <- as.data.frame(emm_linear) %>%
  as_tibble()

p_linear <- ggplot(emm_linear_df, aes(x = group, y = emmean)) +
  geom_point(size = 4, color = "#0072B2") +
  geom_errorbar(aes(ymin = asymp.LCL, ymax = asymp.UCL), width = 0.1) +
  labs(
    x = "Group",
    y = "Linear Predictor (log-odds scale)",
    caption = "Error bars show 95% confidence intervals"
  ) +
  theme_minimal(base_size = 12)

print(p_linear)
ggsave("model_linear_predictor.png", p_linear, width = 6, height = 5, dpi = 300)

#===============================================================================
# 4. PAIRWISE CONTRASTS (ODDS RATIO)
#===============================================================================

# Get odds ratio for group comparison
contrast_result <- pairs(emm_linear, reverse = TRUE)
contrast_df <- as.data.frame(contrast_result) %>%
  as_tibble() %>%
  mutate(odds_ratio = exp(estimate),
         or_lower = exp(estimate - 1.96 * SE),
         or_upper = exp(estimate + 1.96 * SE))

cat("\nGroup Comparison (Odds Ratio):\n")
print(contrast_df %>% 
        select(contrast, odds_ratio, or_lower, or_upper, p.value))

# Visualize odds ratio
p_or <- ggplot(contrast_df, aes(x = contrast, y = odds_ratio)) +
  geom_point(size = 4, color = "#0072B2") +
  geom_errorbar(aes(ymin = or_lower, ymax = or_upper), width = 0.1) +
  geom_hline(yintercept = 1, linetype = "dashed", color = "red") +
  coord_flip() +
  labs(
    x = NULL,
    y = "Odds Ratio (Group A vs Group B)",
    caption = "Error bars show 95% confidence intervals. Dashed line at OR = 1 (no effect)"
  ) +
  theme_minimal(base_size = 12)

print(p_or)
ggsave("model_odds_ratio.png", p_or, width = 6, height = 4, dpi = 300)

#===============================================================================
# 5. EXPECTED MEAN SCORE (on probability scale)
#===============================================================================

# Calculate expected score (weighted average across categories)
emm_probs <- as.data.frame(emmeans(model, ~ group, mode = "prob"))

expected_scores <- emm_probs %>%
  as_tibble() %>%
  mutate(score = as.numeric(gsub("prob\\.", "", cut)) - 1) %>%
  group_by(group) %>%
  summarise(
    expected_score = sum(prob * score),
    # Approximate SE using delta method (simplified)
    .groups = "drop"
  )

cat("\nExpected Mean Scores:\n")
print(expected_scores)