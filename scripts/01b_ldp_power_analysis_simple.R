library(tidyverse)
library(ordinal)
library(furrr)

# Set up parallel processing
plan(multisession, workers = parallel::detectCores() - 1)

# Simulation parameters
nsims <- 500  # Increase to 1000+ for final analysis

# Set block sd
block_sd_val <- 0.5

#===============================================================================
# SIMPLIFIED MODEL: Program as Fixed Effect (No Institution Random Effect)
# This script uses the same simulation approach as 01_ldp_power_analysis.R
# but fits a simpler model: score ~ group + program (no random effects)
#===============================================================================

#===============================================================================
# FUNCTION 1: Generate score distributions based on target OR
# (Same as in 01_ldp_power_analysis.R)
#===============================================================================

get_score_distributions <- function(target_or) {

  # Define baseline "Other" distribution (heavily concentrated at 0-1)
  other_probs <- c(0.45, 0.35, 0.15, 0.04, 0.01)

  if (target_or <= 1.0) {
    ldp_probs <- other_probs
  } else {
    # Calculate shift intensity based on target OR
    log_or <- log(target_or)

    # Define distributions at key OR values
    if (log_or < 0.4) {
      # Small effect (OR ~ 1.2-1.5)
      ldp_probs <- c(0.25, 0.45, 0.22, 0.06, 0.02)
    } else if (log_or < 0.7) {
      # Moderate effect (OR ~ 1.5-2.0)
      ldp_probs <- c(0.15, 0.45, 0.28, 0.09, 0.03)
    } else if (log_or < 1.0) {
      # Moderate-large effect (OR ~ 2.0-2.7)
      ldp_probs <- c(0.08, 0.42, 0.32, 0.13, 0.05)
    } else {
      # Large effect (OR > 2.7)
      ldp_probs <- c(0.04, 0.35, 0.35, 0.18, 0.08)
    }

    # Interpolate for smooth transitions
    if (log_or < 0.4) {
      weight <- log_or / 0.4
      ldp_probs <- (1 - weight) * other_probs +
        weight * c(0.25, 0.45, 0.22, 0.06, 0.02)
    } else if (log_or < 0.7) {
      weight <- (log_or - 0.4) / (0.7 - 0.4)
      ldp_probs <- (1 - weight) * c(0.25, 0.45, 0.22, 0.06, 0.02) +
        weight * c(0.15, 0.45, 0.28, 0.09, 0.03)
    } else if (log_or < 1.0) {
      weight <- (log_or - 0.7) / (1.0 - 0.7)
      ldp_probs <- (1 - weight) * c(0.15, 0.45, 0.28, 0.09, 0.03) +
        weight * c(0.08, 0.42, 0.32, 0.13, 0.05)
    } else {
      weight <- min(1, (log_or - 1.0) / 0.1)
      ldp_probs <- (1 - weight) * c(0.08, 0.42, 0.32, 0.13, 0.05) +
        weight * c(0.04, 0.35, 0.35, 0.18, 0.08)
    }

    # Ensure probabilities sum to 1
    ldp_probs <- ldp_probs / sum(ldp_probs)
  }

  return(list(ldp_probs = ldp_probs, other_probs = other_probs))
}

#===============================================================================
# FUNCTION 2: Simulate data
# Same structure as complex model, but we won't use institution as random effect
#===============================================================================

simulate_blocked_data <- function(n_institutions,
                                  n_per_group_per_inst,
                                  target_or,
                                  block_sd = block_sd_val) {

  # Get score distributions for this effect size
  probs <- get_score_distributions(target_or)
  ldp_probs <- probs$ldp_probs
  other_probs <- probs$other_probs

  # Create institution structure (will be ignored in model fitting)
  institutions <- tibble(
    institution = paste0("Inst", 1:n_institutions),
    institution_effect = rnorm(n_institutions, 0, block_sd)
  )

  # Generate observations
  data <- institutions %>%
    rowwise() %>%
    mutate(
      obs = list({
        # Create strata for MSc and PhD
        bind_rows(
          # MSc stratum
          tibble(
            career_stage = "MSc",
            group = rep(c("LDP", "Other"), each = n_per_group_per_inst),
            os_score = c(
              sample(0:4, n_per_group_per_inst, replace = TRUE, prob = ldp_probs),
              sample(0:4, n_per_group_per_inst, replace = TRUE, prob = other_probs)
            )
          ),
          # PhD stratum
          tibble(
            career_stage = "PhD",
            group = rep(c("LDP", "Other"), each = n_per_group_per_inst),
            os_score = c(
              sample(0:4, n_per_group_per_inst, replace = TRUE, prob = ldp_probs),
              sample(0:4, n_per_group_per_inst, replace = TRUE, prob = other_probs)
            )
          )
        )
      })
    ) %>%
    ungroup() %>%
    unnest(obs) %>%
    mutate(
      output_id = row_number(),
      stratum = paste(institution, career_stage, sep = "_"),
      os_score_ord = ordered(os_score),
      career_stage = factor(career_stage)  # Ensure it's a factor for model
    ) %>%
    select(output_id, institution, career_stage, stratum, group, os_score, os_score_ord)

  return(data)
}

#===============================================================================
# FUNCTION 3: Fit SIMPLIFIED model and test group effect (ONE-SIDED)
# Model: score ~ group + program (no random effects)
#===============================================================================

fit_and_test_simple <- function(data) {
  tryCatch({
    # Simplified model: program as fixed effect, no institution
    model <- clm(os_score_ord ~ group + career_stage,
                 data = data)

    coefs <- coef(summary(model))
    group_row <- rownames(coefs) == "groupOther"

    if (!any(group_row)) {
      return(list(
        p_value = NA,
        log_or_est = NA,
        or_est = NA,
        converged = FALSE
      ))
    }

    z_stat <- coefs[group_row, "z value"]

    # One-sided p-value
    # H1: LDP > Other (i.e., groupOther coefficient < 0, OR < 1)
    if (z_stat < 0) {
      p_value_one_sided <- pnorm(z_stat)
    } else {
      p_value_one_sided <- 1 - pnorm(z_stat)
    }

    log_or <- coefs[group_row, "Estimate"]
    or <- exp(log_or)

    return(list(
      p_value = p_value_one_sided,
      log_or_est = log_or,
      or_est = or,
      converged = TRUE
    ))
  }, error = function(e) {
    return(list(
      p_value = NA,
      log_or_est = NA,
      or_est = NA,
      converged = FALSE
    ))
  })
}

#===============================================================================
# FUNCTION 4: Calculate power for given scenario (SIMPLIFIED MODEL)
#===============================================================================

calculate_power_simple <- function(n_institutions,
                                   n_per_group_per_inst,
                                   target_or,
                                   n_sims = nsims,
                                   alpha = 0.05,
                                   block_sd = block_sd_val) {

  cat(sprintf("\nRunning SIMPLIFIED power analysis: %d institutions, %d per group, OR = %.2f\n",
              n_institutions, n_per_group_per_inst, target_or))

  results <- future_map_dfr(1:n_sims, function(i) {
    data <- simulate_blocked_data(n_institutions, n_per_group_per_inst,
                                  target_or, block_sd)
    result <- fit_and_test_simple(data)
    tibble(
      sim = i,
      p_value = result$p_value,
      log_or_est = result$log_or_est,
      or_est = result$or_est,
      converged = result$converged
    )
  }, .options = furrr_options(seed = TRUE))

  converged_results <- results %>% filter(converged)

  if (nrow(converged_results) < 0.5 * n_sims) {
    warning(sprintf("Low convergence rate: %d/%d (%.1f%%). Results may be unreliable.",
                    nrow(converged_results), n_sims,
                    100 * nrow(converged_results) / n_sims))
  }

  # Power for one-sided test
  power <- mean(converged_results$p_value < alpha, na.rm = TRUE)
  convergence_rate <- nrow(converged_results) / n_sims

  est_summary <- converged_results %>%
    summarise(
      mean_log_or = mean(log_or_est, na.rm = TRUE),
      mean_or = mean(or_est, na.rm = TRUE),
      sd_log_or = sd(log_or_est, na.rm = TRUE)
    )

  return(list(
    power = power,
    convergence_rate = convergence_rate,
    n_institutions = n_institutions,
    n_per_group_per_inst = n_per_group_per_inst,
    total_n = n_institutions * n_per_group_per_inst * 2 * 2,
    true_or = target_or,
    estimated = est_summary
  ))
}

#===============================================================================
# FUNCTION 5: Find required effect size for 80% power (SIMPLIFIED MODEL)
#===============================================================================

find_required_effect_size_simple <- function(n_institutions,
                                             n_per_group_per_inst,
                                             target_power = 0.80,
                                             n_sims = nsims,
                                             block_sd = block_sd_val) {

  cat(sprintf("\nFinding effect size for 80%% power (simplified): %d institutions, %d per group\n",
              n_institutions, n_per_group_per_inst))

  # Binary search for required OR
  lower <- 1.1
  upper <- 3.0

  while (upper - lower > 0.1) {
    mid <- (lower + upper) / 2
    result <- calculate_power_simple(n_institutions, n_per_group_per_inst,
                                     mid, n_sims, block_sd = block_sd)

    if (result$power < target_power) {
      lower <- mid
    } else {
      upper <- mid
    }
  }

  final_or <- (lower + upper) / 2
  final_result <- calculate_power_simple(n_institutions, n_per_group_per_inst,
                                         final_or, n_sims, block_sd = block_sd)

  return(list(
    required_or = final_or,
    achieved_power = final_result$power,
    n_institutions = n_institutions,
    n_per_group_per_inst = n_per_group_per_inst
  ))
}

#===============================================================================
# USE CASE 1: Calculate power for specific scenarios (SIMPLIFIED MODEL)
#===============================================================================

# Use SAME scenarios as original analysis for comparison
scenarios <- expand_grid(
  n_institutions = c(6, 8, 10),
  n_per_group = c(2, 4, 6),
  or = c(1.2, 1.5, 2.0, 2.5)
)

# Run power analysis with simplified model
power_results_simple <- scenarios %>%
  pmap_dfr(function(n_institutions, n_per_group, or) {
    result <- calculate_power_simple(
      n_institutions = n_institutions,
      n_per_group_per_inst = n_per_group,
      target_or = or,
      n_sims = nsims,
      block_sd = block_sd_val
    )
    tibble(
      n_institutions = result$n_institutions,
      n_per_group_per_inst = result$n_per_group_per_inst,
      total_n = result$total_n,
      true_or = result$true_or,
      power = result$power,
      convergence_rate = result$convergence_rate
    )
  })

# Save results
write_csv(power_results_simple, "data/power_analysis/power_analysis_results_simple.csv")

#===============================================================================
# USE CASE 2: Find required effect size for 80% power (SIMPLIFIED MODEL)
#===============================================================================

design_scenarios <- expand_grid(
  n_institutions = c(6, 8, 10),
  n_per_group = c(2, 4, 6)
)

required_effect_results_simple <- design_scenarios %>%
  pmap_dfr(function(n_institutions, n_per_group) {
    result <- find_required_effect_size_simple(
      n_institutions = n_institutions,
      n_per_group_per_inst = n_per_group,
      target_power = 0.80,
      n_sims = nsims,
      block_sd = block_sd_val
    )
    tibble(
      n_institutions = result$n_institutions,
      n_per_group_per_inst = result$n_per_group_per_inst,
      total_n = result$n_institutions * result$n_per_group_per_inst * 2 * 2,
      required_or = result$required_or,
      achieved_power = result$achieved_power
    )
  })

# Save results
write_csv(required_effect_results_simple, "data/power_analysis/required_effect_sizes_simple.csv")

#===============================================================================
# VISUALIZATIONS: Same structure as original but for simplified model
#===============================================================================

n_inst_vals <- sort(unique(scenarios$n_institutions))
n_per_group_vals <- sort(unique(scenarios$n_per_group))
effect_sizes <- sort(unique(scenarios$or))

n_effects <- length(effect_sizes)
colors_effects <- c("#D55E00", "#009E73", "#E69F00", "#56B4E9", "#CC79A7",
                    "#0072B2", "#F0E442")[1:n_effects]

power_results_simple_with_ci <- power_results_simple %>%
  mutate(
    power_se = sqrt(power * (1 - power) / (convergence_rate * nsims)),
    power_lower = pmax(0, power - 1.96 * power_se),
    power_upper = pmin(1, power + 1.96 * power_se),
    or_label = factor(
      paste0("OR = ", round(true_or, 1)),
      levels = paste0("OR = ", round(sort(unique(true_or)), 1))
    ),
    n_inst_label = factor(
      paste0(n_institutions, " institutions"),
      levels = paste0(sort(unique(n_institutions)), " institutions")
    )
  )

p1 <- power_results_simple_with_ci %>%
  ggplot(aes(x = n_per_group_per_inst, y = power,
             color = or_label, group = or_label)) +
  geom_line(linewidth = 1) +
  geom_point(size = 2) +
  geom_errorbar(aes(ymin = power_lower, ymax = power_upper),
                width = 0.2, alpha = 0.5) +
  geom_hline(yintercept = 0.80, linetype = "dashed", color = "gray50") +
  facet_wrap(~n_inst_label, ncol = 3) +
  scale_y_continuous(limits = c(0, 1), breaks = seq(0, 1, 0.2)) +
  scale_x_continuous(breaks = n_per_group_vals) +
  scale_color_manual(
    values = colors_effects,
    name = "Effect size"
  ) +
  labs(
    title = "Statistical Power (Simplified Model: group + program)",
    subtitle = "No institution random effect - improved convergence",
    x = "Outputs per group per institution (each career stage)",
    y = "Power (1 - β)"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    legend.position = "bottom",
    panel.grid.minor = element_blank(),
    strip.text = element_text(face = "bold")
  )

print(p1)
ggsave("figures/power_curves_simple.png", p1, width = 10, height = 6, dpi = 300)

#===============================================================================
# VISUALIZATION 2: Required effect sizes - SIMPLIFIED MODEL
#===============================================================================

p2 <- required_effect_results_simple %>%
  mutate(
    n_inst_label = factor(
      paste0(n_institutions, " institutions"),
      levels = paste0(sort(unique(n_institutions)), " institutions")
    )
  ) %>%
  ggplot(aes(x = n_per_group_per_inst, y = required_or)) +
  geom_hline(yintercept = 1.0, linetype = "solid", color = "gray50", alpha = 0.6) +
  geom_hline(yintercept = 1.5, linetype = "dotted", color = "gray50", alpha = 0.6) +
  geom_hline(yintercept = 2.0, linetype = "dotted", color = "gray50", alpha = 0.6) +
  geom_line(linewidth = 1, color = "#0072B2") +
  geom_point(size = 2.5, color = "#0072B2") +
  facet_wrap(~n_inst_label, ncol = 3) +
  scale_y_continuous(breaks = seq(1, 3, 0.25)) +
  scale_x_continuous(breaks = n_per_group_vals) +
  annotate("text", x = max(n_per_group_vals) * 0.95, y = 1.5,
           label = "Small-moderate", hjust = 1, size = 2.5, color = "gray30") +
  annotate("text", x = max(n_per_group_vals) * 0.95, y = 2.0,
           label = "Moderate", hjust = 1, size = 2.5, color = "gray30") +
  labs(
    title = "Minimum Detectable Effect for 80% Power (Simplified Model)",
    subtitle = "Model: group + program (no random effects)",
    x = "Outputs per group per institution (each career stage)",
    y = "Required Odds Ratio"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    legend.position = "none",
    panel.grid.minor = element_blank(),
    strip.text = element_text(face = "bold")
  )

print(p2)
ggsave("figures/required_effect_sizes_simple.png", p2, width = 10, height = 6, dpi = 300)

#===============================================================================
# SUMMARY TABLES
#===============================================================================

cat("\n", rep("=", 80), "\n", sep = "")
cat("POWER ANALYSIS SUMMARY - SIMPLIFIED MODEL\n")
cat("Model: score ~ group + program (no random effects)\n")
cat(rep("=", 80), "\n\n", sep = "")

cat("Simulation parameters:\n")
cat("  - Number of simulations per scenario:", nsims, "\n")
cat("  - Institutions tested:", paste(n_inst_vals, collapse = ", "), "\n")
cat("  - Outputs per group tested:", paste(n_per_group_vals, collapse = ", "), "\n")
cat("  - Effect sizes (OR):", paste(round(effect_sizes, 1), collapse = ", "), "\n")
cat("  - Block SD (institutional heterogeneity):", block_sd_val, "\n")
cat("  - Test type: One-sided (H1: OR > 1)\n")
cat("  - Model: Simplified (no institution random effect)\n\n")

# Power table for middle sample size
middle_n <- n_per_group_vals[ceiling(length(n_per_group_vals) / 2)]
power_table <- power_results_simple %>%
  filter(n_per_group_per_inst == middle_n) %>%
  select(n_institutions, total_n, true_or, power, convergence_rate) %>%
  arrange(n_institutions, true_or) %>%
  mutate(
    true_or = sprintf("%.1f", true_or),
    power = sprintf("%.3f", power),
    convergence_rate = sprintf("%.3f", convergence_rate)
  )

cat("Power for n =", middle_n, "per group per institution:\n")
print(power_table, row.names = FALSE)

cat("\n\nRequired effect sizes for 80% power:\n")
required_table <- required_effect_results_simple %>%
  select(n_institutions, n_per_group_per_inst, total_n,
         required_or, achieved_power) %>%
  arrange(n_institutions, n_per_group_per_inst) %>%
  mutate(
    required_or = sprintf("%.2f", required_or),
    achieved_power = sprintf("%.3f", achieved_power)
  )

print(required_table, row.names = FALSE)

cat("\n", rep("=", 80), "\n", sep = "")
cat("COMPARISON NOTE:\n")
cat("Compare convergence rates to original analysis (01_ldp_power_analysis.R)\n")
cat("Simplified model should show dramatically improved convergence rates.\n")
cat(rep("=", 80), "\n", sep = "")

# Return to sequential processing
plan(sequential)
