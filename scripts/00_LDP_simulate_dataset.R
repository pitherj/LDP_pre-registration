library(tidyverse)
library(ordinal)

#===============================================================================
# FUNCTION: Simulate Full Dataset for Pre-registration Example
#===============================================================================

simulate_example_dataset <- function(n_institutions = 10,
                                     min_ldp_per_inst = 2,
                                     max_ldp_per_inst = 6,
                                     equal_msc_phd_split = FALSE,
                                     target_or = 1.5,
                                     block_sd = 0.5,
                                     plot = TRUE,
                                     seed = NULL) {
  
  # Set seed for reproducibility if provided
  if (!is.null(seed)) {
    set.seed(seed)
  }
  
  #-----------------------------------------------------------------------------
  # Step 1: Define probability distributions based on target OR
  #-----------------------------------------------------------------------------
  
  # Define baseline "Other" distribution (heavily concentrated at 0-1)
  # Most outputs score 0 or 1, very few above 2
  other_probs <- c(0.45, 0.35, 0.15, 0.04, 0.01)
  
  # Create "LDP" distribution based on target OR
  # Key insight: LDP shifts mass from 0 toward 1-2, with most mass at 1-2
  # Very few LDP outputs should score 0
  
  if (target_or <= 1.0) {
    # No effect or negative effect - same as Other
    ldp_probs <- other_probs
  } else {
    # Base LDP distribution: much less at 0, more at 1-2
    # Start with a distribution centered around scores 1-2
    
    # Calculate shift intensity based on target OR
    log_or <- log(target_or)
    
    if (log_or < 0.4) {
      # Small effect (OR ~ 1.2-1.5): modest shift from 0 to 1
      ldp_probs <- c(0.25, 0.45, 0.22, 0.06, 0.02)
      
    } else if (log_or < 0.7) {
      # Moderate effect (OR ~ 1.5-2.0): clear shift, peaked at 1-2
      ldp_probs <- c(0.15, 0.45, 0.28, 0.09, 0.03)
      
    } else if (log_or < 1.0) {
      # Moderate-large effect (OR ~ 2.0-2.7): strong shift toward 1-2
      ldp_probs <- c(0.08, 0.42, 0.32, 0.13, 0.05)
      
    } else {
      # Large effect (OR > 2.7): very strong shift, some reaching 3-4
      ldp_probs <- c(0.04, 0.35, 0.35, 0.18, 0.08)
    }
    
    # Fine-tune based on exact target OR using linear interpolation
    # This provides smooth transitions between the discrete categories above
    if (log_or < 0.4) {
      # Interpolate between "no effect" and "small"
      weight <- log_or / 0.4
      ldp_probs <- (1 - weight) * other_probs + weight * c(0.25, 0.45, 0.22, 0.06, 0.02)
    } else if (log_or < 0.7) {
      # Interpolate between "small" and "moderate"
      weight <- (log_or - 0.4) / (0.7 - 0.4)
      ldp_probs <- (1 - weight) * c(0.25, 0.45, 0.22, 0.06, 0.02) + 
        weight * c(0.15, 0.45, 0.28, 0.09, 0.03)
    } else if (log_or < 1.0) {
      # Interpolate between "moderate" and "moderate-large"
      weight <- (log_or - 0.7) / (1.0 - 0.7)
      ldp_probs <- (1 - weight) * c(0.15, 0.45, 0.28, 0.09, 0.03) + 
        weight * c(0.08, 0.42, 0.32, 0.13, 0.05)
    } else {
      # Interpolate between "moderate-large" and "large"
      weight <- min(1, (log_or - 1.0) / 0.1)
      ldp_probs <- (1 - weight) * c(0.08, 0.42, 0.32, 0.13, 0.05) + 
        weight * c(0.04, 0.35, 0.35, 0.18, 0.08)
    }
    
    # Ensure probabilities sum to 1 (numerical stability)
    ldp_probs <- ldp_probs / sum(ldp_probs)
  }
  
  #-----------------------------------------------------------------------------
  # Step 2: Generate institution-level structure
  #-----------------------------------------------------------------------------
  
  institutions <- tibble(
    institution = paste0("Inst", 1:n_institutions),
    # Random effect for each institution
    institution_effect = rnorm(n_institutions, 0, block_sd),
    # Number of LDP observations per institution (varies randomly)
    n_ldp = sample(min_ldp_per_inst:max_ldp_per_inst, n_institutions, replace = TRUE)
  )
  
  #-----------------------------------------------------------------------------
  # Step 3: Generate observations for each institution
  #-----------------------------------------------------------------------------
  
  data <- institutions %>%
    rowwise() %>%
    mutate(
      obs = list({
        
        # Determine MSc/PhD split
        if (equal_msc_phd_split) {
          # Equal split (or as close as possible)
          n_msc <- floor(n_ldp / 2)
          n_phd <- n_ldp - n_msc
        } else {
          # Random split (but ensure at least 1 of each if n_ldp >= 2)
          if (n_ldp >= 2) {
            n_msc <- sample(1:(n_ldp - 1), 1)
            n_phd <- n_ldp - n_msc
          } else {
            # If only 1 LDP, randomly assign to MSc or PhD
            n_msc <- sample(0:1, 1)
            n_phd <- 1 - n_msc
          }
        }
        
        # Create LDP observations
        ldp_data <- tibble(
          group = "LDP",
          career_stage = c(rep("MSc", n_msc), rep("PhD", n_phd)),
          os_score = sample(0:4, n_ldp, replace = TRUE, prob = ldp_probs)
        )
        
        # Create matched Other observations (same n and career stage distribution)
        other_data <- tibble(
          group = "Other",
          career_stage = c(rep("MSc", n_msc), rep("PhD", n_phd)),
          os_score = sample(0:4, n_ldp, replace = TRUE, prob = other_probs)
        )
        
        # Combine
        bind_rows(ldp_data, other_data)
      })
    ) %>%
    ungroup() %>%
    select(institution, institution_effect, obs) %>%
    unnest(obs) %>%
    mutate(
      # Create unique output ID
      output_id = row_number(),
      # Create stratum identifier
      stratum = paste(institution, career_stage, sep = "_"),
      # Convert to ordered factor
      os_score_ord = ordered(os_score)
    ) %>%
    select(output_id, institution, career_stage, stratum, group, os_score, os_score_ord)
  
  #-----------------------------------------------------------------------------
  # Step 4: Calculate summary statistics
  #-----------------------------------------------------------------------------
  
  summary_stats <- list(
    n_total = nrow(data),
    n_ldp = sum(data$group == "LDP"),
    n_other = sum(data$group == "Other"),
    n_institutions = n_institutions,
    n_strata = length(unique(data$stratum)),
    mean_ldp = mean(data$os_score[data$group == "LDP"]),
    mean_other = mean(data$os_score[data$group == "Other"]),
    mean_diff = mean(data$os_score[data$group == "LDP"]) - 
      mean(data$os_score[data$group == "Other"]),
    target_or = target_or,
    ldp_probs = ldp_probs,
    other_probs = other_probs
  )
  
  #-----------------------------------------------------------------------------
  # Step 5: Create distribution plot if requested
  #-----------------------------------------------------------------------------
  
  if (plot) {
    
    # Observed distributions
    obs_dist <- data %>%
      count(group, os_score) %>%
      group_by(group) %>%
      mutate(proportion = n / sum(n)) %>%
      ungroup()
    
    # Theoretical distributions
    theory_dist <- tibble(
      group = rep(c("LDP", "Other"), each = 5),
      os_score = rep(0:4, 2),
      proportion = c(ldp_probs, other_probs),
      type = "Theoretical"
    )
    
    obs_dist_labeled <- obs_dist %>%
      mutate(type = "Observed")
    
    combined_dist <- bind_rows(
      obs_dist_labeled %>% select(group, os_score, proportion, type),
      theory_dist
    )
    
    p <- ggplot() +
      # Theoretical distributions (bars)
      geom_col(data = theory_dist,
               aes(x = os_score, y = proportion, fill = group),
               alpha = 0.3, position = position_dodge(width = 0.7), width = 0.6) +
      # Observed distributions (points and lines)
      geom_line(data = obs_dist_labeled,
                aes(x = os_score, y = proportion, color = group, group = group),
                linewidth = 1) +
      geom_point(data = obs_dist_labeled,
                 aes(x = os_score, y = proportion, color = group),
                 size = 3) +
      scale_fill_manual(
        values = c("LDP" = "#0072B2", "Other" = "#D55E00"),
        labels = c("LDP (trained)", "Other (control)")
      ) +
      scale_color_manual(
        values = c("LDP" = "#0072B2", "Other" = "#D55E00"),
        labels = c("LDP (trained)", "Other (control)")
      ) +
      scale_x_continuous(breaks = 0:4) +
      scale_y_continuous(labels = scales::percent_format()) +
      labs(
        title = sprintf("Distribution of Open Science Scores (Target OR = %.2f)", target_or),
        subtitle = sprintf("n = %d LDP, %d Other from %d institutions; Observed mean diff = %.2f",
                           summary_stats$n_ldp, summary_stats$n_other, 
                           n_institutions, summary_stats$mean_diff),
        x = "Open Science Score (0-4)",
        y = "Proportion",
        fill = "Group",
        color = "Group",
        caption = "Bars = theoretical distributions; Lines/points = observed in simulated data"
      ) +
      theme_minimal(base_size = 12) +
      theme(
        legend.position = "bottom",
        panel.grid.minor = element_blank()
      )
    
    print(p)
  }
  
  #-----------------------------------------------------------------------------
  # Step 6: Return data and summary
  #-----------------------------------------------------------------------------
  
  return(list(
    data = data,
    summary = summary_stats
  ))
}

#===============================================================================
# EXAMPLE USAGE
#===============================================================================

# Example 1: Small study with equal MSc/PhD split
ex1 <- simulate_example_dataset(
  n_institutions = 8,
  min_ldp_per_inst = 5,
  max_ldp_per_inst = 10,
  equal_msc_phd_split = FALSE,
  target_or = 1.3,
  plot = TRUE,
  seed = 1234
)

cat("\nExample 1 Summary:\n")
print(ex1$summary)

cat("\nFirst 20 rows:\n")
print(ex1$data, n = 20)

# Example 2: Larger study with random MSc/PhD split and larger effect
ex2 <- simulate_example_dataset(
  n_institutions = 12,
  min_ldp_per_inst = 7,
  max_ldp_per_inst = 13,
  equal_msc_phd_split = FALSE,
  target_or = 2.5,
  plot = TRUE,
  seed = 456
)

cat("\nExample 2 Summary:\n")
print(ex2$summary)

# Example 3: Minimal effect (near null)
ex3 <- simulate_example_dataset(
  n_institutions = 10,
  min_ldp_per_inst = 6,
  max_ldp_per_inst = 10,
  equal_msc_phd_split = FALSE,
  target_or = 1.1,
  plot = TRUE,
  seed = 789
)

cat("\nExample 3 Summary:\n")
print(ex3$summary)

#===============================================================================
# FIT MODEL TO EXAMPLE DATA
#===============================================================================

# Demonstrate how to analyze the simulated data
fit_example_model <- function(sim_result) {
  
  cat("\n", rep("=", 80), "\n", sep = "")
  cat("MODEL FITTING EXAMPLE\n")
  cat(rep("=", 80), "\n\n", sep = "")
  
  data <- sim_result$data
  
  # Fit the model
  model <- clmm(os_score_ord ~ group + (1|stratum), data = data, nAGQ = 1)
  
  # Extract results
  coefs <- coef(summary(model))
  group_row <- rownames(coefs) == "groupOther"
  
  z_stat <- coefs[group_row, "z value"]
  
  # One-sided p-value
  if (z_stat < 0) {
    p_value_one_sided <- pnorm(z_stat)
  } else {
    p_value_one_sided <- 1 - pnorm(z_stat)
  }
  
  log_or <- coefs[group_row, "Estimate"]
  # Flip sign because we want LDP vs Other, not Other vs LDP
  log_or_ldp_vs_other <- -log_or
  or_ldp_vs_other <- exp(log_or_ldp_vs_other)
  
  cat("Target OR:", sim_result$summary$target_or, "\n")
  cat("Estimated OR (LDP vs Other):", round(or_ldp_vs_other, 3), "\n")
  cat("95% CI:", round(exp(-log_or - 1.96 * coefs[group_row, "Std. Error"]), 3), 
      "to", round(exp(-log_or + 1.96 * coefs[group_row, "Std. Error"]), 3), "\n")
  cat("One-sided p-value:", round(p_value_one_sided, 4), "\n")
  cat("Significant at α = 0.05?", ifelse(p_value_one_sided < 0.05, "YES", "NO"), "\n")
  
  cat("\nFull Model Summary:\n")
  print(summary(model))
  
  cat("\n", rep("=", 80), "\n\n", sep = "")
  
  invisible(model)
}

# Fit model to Example 1
model1 <- fit_example_model(ex1)

#===============================================================================
# SAVE EXAMPLE DATASET FOR PRE-REGISTRATION
#===============================================================================

# Save a representative example
write_csv(ex1$data, "data/simulated/example_dataset_for_preregistration.csv")

cat("\nExample dataset saved to: example_dataset_for_preregistration.csv\n")