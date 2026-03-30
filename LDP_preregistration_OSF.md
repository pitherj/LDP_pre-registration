# OSF Pre-registration

---

## Metadata

**Title**

Assessing Open Science Practices Among Graduates of the Living Data Project, a Canada-wide Graduate Training Program

**Description**

Despite a growing awareness of low transparency and replicability of research across many scientific disciplines, practices that enhance good research conduct — such as pre-registration and sharing of code and non-sensitive data — remain rare. Insufficient access to suitable training has long been identified as a key barrier. The Living Data Project (LDP), an initiative of the Canadian Institute of Ecology and Evolution funded through Canada's NSERC CREATE program between 2020 and 2026, aims to address this shortfall for graduate students in ecology, evolution, and environmental science (EEE) across Canada.

The LDP offered formal graduate courses to enhance research transparency and replicability, providing four 1-credit, synchronous, online modules each year, each comprising eight 90-minute sessions. Two modules focused specifically on training students in the principles and practices of open science, including pre-registrations, sharing code, and following FAIR principles for open data (doi.org/10.1038/SDATA.2016.18). The two other modules addressed synthesis statistics and scientific collaboration.

To evaluate whether the training provided by the LDP has made a difference, we conduct a quasi-experimental, matched-groups study comparing FAIR compliance scores of research data associated with publications authored by LDP trainees versus matched controls. Controls are graduate students from the same institutions who did not receive LDP training, and who completed theses in EEE.  The latter are identified using a text-based thesis classifier applied to Canadian thesis metadata, with author publications retrieved via the OpenAlex API.

FAIR compliance is assessed by three to five trained raters using a standardized FAIR compliance checklist, producing a composite score (0–10) for each publication. We focus on the first three cohorts of LDP graduates (2020–2022), as these are the most likely to have a sufficient number of published research outputs.

**Contributors**

Jason Pither, Mathew Vis-Dunbar, Sandra Emry, David Hunt, Diane Srivastava

**License**

CC-By Attribution 4.0 International

**Subject**

Social and Behavioral Sciences > Library and Information Science; Life Sciences > Ecology and Evolutionary Biology; Education > Higher Education

**Tags**

open science; FAIR data; Living Data Project; graduate training; matched-groups study; ecology; evolution; environmental science; pre-registration

---

## Study Information

### Hypotheses

The hypothesis is **directional**:

If the LDP training was effective, then the FAIR compliance scores of research data associated with peer-reviewed publications for which LDP trainees were lead (first) author will be higher, on average, compared to those of publications authored by matched control students who did not receive LDP training.

Formally:

- **H₀:** The mean paired difference in FAIR compliance score (LDP minus matched control, within institution) is zero. (δ = 0)
- **Hₐ:** The mean paired difference in FAIR compliance score is positive — LDP publications score higher than their matched controls. (δ > 0)

**Justification for directional hypothesis:** There is no theoretical basis for expecting that structured training in open science practices would decrease the adoption of FAIR data practices below the level observed in a general population of recently graduated EEE students.

---

## Design Plan

### Study Type

Observational Study — Data are collected from study units (published research articles) that are not randomly assigned to a treatment. The "treatment" (LDP training) was received by students as part of their graduate program; group assignment is observational, not randomized.

We use a matched-groups (quasi-experimental) design.

### Blinding

- Raters are not blinded to author identity. Data archives that adhere to FAIR principles will, by design, prominently identify contributors and authors in their metadata; attempting to conceal these identifiers would be both impractical and contrary to the nature of the assessment objects.
- The potential for rater bias introduced by knowledge of author identity is considered minimal, given that the FAIR assessment checklist comprises predominantly binary and ordinal items (e.g., is a data availability statement present? are the data in an open format? is a license provided?) that leave little room for subjective interpretation.
- Raters are partially blinded to group membership (LDP vs. Other); during rating, the raters may recognize names of students who completed the LDP courses. We expect this occurrence to be minimal. 

### Is there any additional blinding in this study?

Raters will be blind to each others' scores during the initial independent rating phase. Scores from all raters (k = 3 to 5) will be collected independently before any inter-rater reliability assessment or adjudication is conducted.

### Study Design

Paired, matched-groups observational study with one binary grouping factor (LDP vs. Other). Each publication is evaluated by three to five independent raters (k = 3–5; exact number confirmed prior to scoring). The unit of analysis is the publication (one per student author), and the unit of inference is the within-institution matched pair.

Matching criteria are: (1) same academic institution and (2) same publication year (the calendar year of the selected qualifying first-author article). A candidate control pool is drawn from EEE graduate students at the same institution with thesis deposit years 2022–2024 (serving as a proxy for graduation year contemporaneous with LDP cohorts). Program level (MSc vs. PhD) is not used as a matching criterion because it is not available for all students.

Within each institution, LDP and control publications are randomly paired one-to-one, constrained to the same publication year. The comparator pool is oversampled at 2 × N_target per institution to ensure year-coverage across all LDP publication years. LDP student-authors without a year-matched comparator are excluded; the number of such exclusions is reported. Complete 1:1 pairing within each year is not guaranteed and depends on comparator availability.

### Randomization

This is an observational study; subjects are not randomly assigned to groups.

However, randomization is used in three places, all using a single pre-specified random seed (**seed = 20260329**):

1. **LDP publication selection:** For each LDP student-author with multiple eligible publications, one is selected at random. The calendar year of the selected publication (Year *Y*) determines which comparator publications are eligible for pairing.

2. **Within-institution, year-matched pairing:** Within each institution, LDP and control authors are randomly paired one-to-one, constrained so that both the LDP publication and the comparator publication are from the same calendar year. Specifically: (a) LDP publications are randomly ordered within each institution; (b) for each LDP publication (year *Y*), one qualifying comparator publication from Year *Y* is selected at random from the oversampled comparator pool. This is the pairing used for the primary hypothesis test.

3. **Exclusion due to insufficient controls:** If an institution has more LDP student-authors than available year-matched comparator publications, the excess LDP observations will be excluded by random selection. If no year-matched comparator is available for a given LDP student-author, that student-author is excluded (see Data Exclusion).

---

## Sampling Plan

### Existing Data

Registration prior to creation of data — As of the date of submission of this pre-registration, the FAIR compliance scores (the primary outcome data) have not yet been collected. The list of publications to be evaluated has been generated, but no FAIR scoring has been conducted. The pre-registration is therefore being submitted prior to any observation of the outcome data.

### Explanation of Existing Data

The publication lists (the inputs to scoring) have been assembled prior to pre-registration as a necessary step in study design (to determine the achievable sample size). However, no FAIR compliance scores have been calculated or observed, and no outcome data has been analyzed. The research team has not examined any open science or FAIR-related characteristics of the identified publications.

### Data Collection Procedures

**Identification of LDP student-authors:**
LDP student-authors are identified from course enrollment records for LDP cohorts 2020–2022. A student is eligible if they are the first author on at least one peer-reviewed research article published in a scholarly journal. Publications are identified using the OpenAlex API, matching student names to author records. Because LDP courses were offered in the fall of each year, a student completing the course in year *Y* could only have applied their training to research initiated after course completion; consequently, the minimum qualifying publication date for each student is January 1 of year *Y* + 1 (e.g., January 1, 2021 for a 2020 cohort student). Each student's enrollment year is recorded in the author roster and used to set their individual publication search cutoff.

**Identification of control student-authors:**
Control student-authors are identified using a text-based machine learning classifier (trained on thesis titles and abstracts) that identifies EEE graduate students from Canadian post-secondary institutions (see associated GitHub repo [here](https://github.com/pitherj/LDP_thesis_classification)). Candidate controls must: (1) be enrolled at an LDP-affiliated institution, (2) have a thesis deposit year within the range 2022–2024, and (3) have at least one first-author peer-reviewed research article published from 2021-01-01 onwards. Controls must not have participated in any LDP course. Program level (MSc or PhD) is recorded where available but is not used as a matching criterion, as it is incomplete across LDP students. To support year-matched pairing (see Publication Selection below), comparator authors are collected at up to 2× the required sample size per institution (i.e., up to 2 × N_target), subject to the number of eligible EEE thesis authors available at each institution. Excess comparators beyond N_target are not used in the primary analysis but provide year-coverage across all publication years represented by LDP students.

**Publication selection:**
For each eligible LDP student-author, one first-author peer-reviewed research article is selected at random (using the pre-specified seed) when multiple eligible publications exist. The calendar year of that selected publication (Year *Y*) is recorded. For the matched comparator at the same institution, one publication from Year *Y* is then selected at random from that comparator's available qualifying publications. This year-matched selection ensures that each LDP–comparator pair is drawn from the same publication year, controlling for temporal changes in journal and publisher requirements for data sharing that could otherwise confound FAIR score comparisons. If a comparator has no qualifying publication in Year *Y*, that LDP student-author is excluded from the analysis (see Data Exclusion). The oversampled comparator pool (2 × N_target per institution) is intended to reduce the incidence of such exclusions.

**FAIR compliance assessment:**
Three to five trained raters (k = 3–5) independently evaluate each selected publication using the standardized FAIR compliance checklist. Raters are not informed of the group membership (LDP vs. Other) of the publications they assess; however, partial unblinding may occur if a rater recognises a student author as an LDP participant. Raters are blind to each other's scores throughout the independent rating phase. Ratings are conducted independently and collected before inter-rater reliability is assessed. Any item-level discrepancies will be noted but will not result in adjudication for the primary analysis (the mean of k raters' scores is used). Adjudicated consensus scores may be used in a sensitivity analysis.

**Inclusion criteria for publications:**
- First-author publication by an eligible student-author
- Peer-reviewed primary research article (not review articles, editorials, or conference proceedings)
- Published on or after January 1 of the year following the student's LDP course enrollment year (e.g., on or after 2021-01-01 for a student enrolled in the 2020 cohort); for controls, published on or after January 1, 2021 (the earliest applicable cutoff)

**Exclusion criteria:**
- Publications without accessible full text (required for FAIR assessment)
- Publications in disciplines clearly outside EEE (based on classification above)

### Sample Size

The sample size is determined by the number of eligible LDP student-authors with at least one qualifying publication surviving all filtering steps. As of pre-registration, **22 unique LDP student first-authors** have at least one qualifying publication after applying all inclusion/exclusion criteria (investigator co-authorship exclusion, title deduplication, primary-research type filter, and title keyword screen).

Of these 22 LDP authors, **21 yielded a matched pair**: one LDP author was excluded because no comparator publication from the same institution and the same calendar year was available in the oversampled comparator pool. The total sample size is therefore **N = 42 publications** (21 LDP + 21 Other), forming **21 matched pairs**. Publications span multiple institutions; the institution-level breakdown is documented in `data/processed_data/private/rater_key.csv`.

### Sample Size Rationale

The sample size is fixed by the number of eligible LDP graduates — it is not under researcher control. The achieved n = 21 pairs is used to evaluate statistical power.

**Power analysis (one-sided paired t-test, α = 0.05, n = 21 pairs):**

Power for the paired t-test depends on the standard deviation of the within-pair differences (σ_D), not the standard deviation of the raw scores. Assuming σ_D ≈ 2.5 (a conservative estimate for a 0–10 bounded score when pairs share institutional context), the study has approximately:
- 80% power to detect a mean paired difference of ≈ 1.42 points (d ≈ 0.57)
- 90% power to detect a mean paired difference of ≈ 1.74 points (d ≈ 0.70)

If the within-pair differences are less variable (e.g., σ_D ≈ 2.0), these thresholds are proportionally smaller (≈ 1.14 and ≈ 1.39 points respectively). Power estimates were obtained using `pwr::pwr.t.test(n = 21, sig.level = 0.05, type = "paired", alternative = "greater")`.

The study is adequately powered to detect moderate-to-large effects (d ≥ 0.57) but is underpowered for small effects (d < 0.4). The detectable effect sizes are considered plausible given the targeted nature of the LDP training; however, the inability to detect smaller effects is acknowledged as a limitation. The permutation test (sign-flip on paired differences) has power approaching that of the paired t-test under normality, so these estimates are approximately applicable to the backup test as well.

### Stopping Rule

Not applicable. The sample is fully determined by the eligible pool of LDP graduates prior to data collection. No sequential stopping rule is needed.

---

## Variables

### Manipulated Variables

Not applicable. This is an observational study. The "treatment" (LDP training) was not assigned by the researchers.

### Measured Variables

**Primary outcome variable — FAIR compliance score:**
A composite integer score ranging from 0 to 10, representing the degree to which the data associated with a publication adheres to FAIR principles (Findable, Accessible, Interoperable, Reusable). Assessed independently by k raters (k = 3–5) using the standardized FAIR compliance checklist. The variable used in primary analysis is the **mean of the k raters' scores** (a continuous value in [0, 10]).

**Primary predictor — Training group:**
Binary categorical variable: LDP (student completed LDP training) vs. Other (matched control without LDP training).

**Pairing variable — Institution:**
Academic institution (7 levels). Used to form within-institution matched pairs. Not included as a covariate in the primary test; institutional balance is achieved by design (equal n per institution in each group).

**Recorded but not used as a matching criterion:**
- Program level (MSc or PhD): recorded where available; not used as a matching criterion due to incomplete availability across the LDP student pool.

**Inter-rater reliability measures (reported but not used in primary analysis):**
- Intraclass correlation coefficient (ICC): two-way mixed model, absolute agreement, average of k raters (k = 3–5)
- Krippendorff's alpha (for ordinal data)

### Indices

**FAIR compliance score (0–10):**

The composite score is the sum of the following component scores, each assessed independently by each rater:

| Component | Items | Scoring | Maximum |
|---|---|---|---|
| Findable | Structured data availability statement with working pointer vs. unstructured statement vs. absent | Ordinal: 2 = structured, 1 = unstructured, 0 = absent (mutually exclusive levels) | 2 |
| Accessible | Data downloadable/recreatable (unrestricted) OR access protocols clearly articulated (restricted) | Binary: 1 = criterion met, 0 = not met | 1 |
| Interoperable | Data provided in open specification format | Binary: 1 = criterion met, 0 = not met | 1 |
| Reusable — file formats identified | File formats clearly identified | Binary: 1 = yes, 0 = no | 1 |
| Reusable — collection protocols | Collection protocols outlined or data source identified | Binary: 1 = yes, 0 = no | 1 |
| Reusable — scripted processing | Data processing is scripted and documented | Binary: 1 = yes, 0 = no | 1 |
| Reusable — variables described | All variables described with names, scales, and ranges | Binary: 1 = yes, 0 = no | 1 |
| Reusable — licensing | Data accompanied by a clearly articulated license | Binary: 1 = yes, 0 = no | 1 |
| **Total** | | | **10** |

**Note on the Findable items:** The two Findable checkboxes in the assessment instrument are treated as mutually exclusive levels of a single dimension rather than as two independent binary items. A structured data availability statement subsumes an unstructured one; the highest applicable level is recorded. This scoring approach preserves the hierarchical quality distinction (structured > unstructured > absent) while contributing a maximum of 2 points to the total, keeping the overall maximum at 10.

The primary analysis uses the **mean of all k raters' component-sum scores** (k = 3–5) as the outcome variable (a continuous value in [0, 10]).

---

## Analysis Plan

### Statistical Models

**Step 0: Inter-rater reliability**

Before hypothesis testing, inter-rater reliability (IRR) will be assessed on the full set of ratings using two complementary measures:

**1. Intraclass Correlation Coefficient (ICC)** — two-way mixed model, absolute agreement, average of k raters (k = 3–5), using `irr::icc()` in R:

```r
library(irr)

# ratings_wide: data frame with one row per publication,
# one column per rater (rater1, ..., raterK), values = FAIR scores
# rater_cols: character vector of rater column names

icc(
  ratings_wide[, rater_cols],
  model = "twoway",    # raters treated as fixed (same k rate all publications)
  type  = "agreement", # absolute agreement (not just consistency)
  unit  = "average"    # reliability of the mean of k raters
)
```

**2. Krippendorff's alpha (ordinal)** — using `tidycomm::test_icr()` in R:

```r
library(tidycomm)

# ratings_long: data frame with columns publication_id, rater_id, fair_score

ratings_long %>%
  test_icr(
    unit_id  = publication_id,
    coder_id = rater_id,
    fair_score,
    levels       = c(fair_score = "ordinal"),  # treat score as ordinal
    kripp_alpha  = TRUE,
    agreement    = TRUE,    # also report simple percent agreement
    fleiss_kappa = TRUE     # also report Fleiss' kappa as supplementary
  )
```

These are reported descriptively. If ICC (average measures) < 0.60, this will be flagged as a limitation and a sensitivity analysis using per-rater scores will be added.

**Primary analysis: One-sided paired t-test on paired differences**

For each matched pair *i*, compute:

```
D_i = fair_score_LDP_i - fair_score_Other_i
```

where `fair_score` is the mean of k raters' scores (k = 3–5).

Because the outcome is the mean of k independent raters' scores (k = 3–5) — rather than a single raw integer rating — the paired differences D_i are quasi-continuous (steps of 1/k) and benefit from within-pair averaging that moves their distribution toward normality. At n = 21 pairs the Central Limit Theorem provides some robustness, though the small sample size means that the permutation sensitivity analysis is especially important. The paired t-test is therefore the preferred primary test: it directly tests the mean difference (which is the quantity of interest) and yields Cohen's *d* as an interpretable effect size. 

**Assumption check (pre-specified):** Before interpreting the result, normality of the paired differences will be assessed using visual inspection (histogram and Q-Q plot). If visual inspection indicates meaningful departure from normality, the permutation test (Sensitivity Analysis 1 below) will be substituted as the primary inferential result.

Test H₀: mean(D) = 0 against Hₐ: mean(D) > 0 at α = 0.05, implemented using `t.test(D, alternative = "greater", mu = 0)` in R.

**Paired differences are computed from one pre-specified random pairing** (within-institution, **seed = 20260329**).

**Effect size:** Cohen's *d* for paired differences, computed as mean(D) / sd(D), with a 95% confidence interval.

**Example R code for primary analysis:**

```r
# Compute paired differences
# 'data' has one row per matched pair; columns: fair_score_LDP, fair_score_Other
D <- data$fair_score_LDP - data$fair_score_Other

# --- Assumption check: normality of paired differences ---

par(mfrow = c(1, 2))
hist(D, main = "Paired differences", xlab = "LDP − Other (mean FAIR score)")
qqnorm(D); qqline(D, col = "red")

# --- Primary analysis: one-sided paired t-test ---
t_result <- t.test(D, alternative = "greater", mu = 0)
t_result

# Effect size: Cohen's d (and 95% CI via non-central t distribution)
library(effectsize)
cohens_d(D, alternative = "greater")

# --- Fallback if normality assumption is violated (Sensitivity Analysis 1) ---
set.seed(20260329)
n_perm <- 1000
obs_mean <- mean(D)
perm_means <- replicate(n_perm, {
  signs <- sample(c(-1, 1), length(D), replace = TRUE)
  mean(D * signs)
})
p_perm <- mean(perm_means >= obs_mean)
cat(sprintf("Permutation p-value (one-sided) = %.4f\n", p_perm))
cat(sprintf("Observed mean paired difference  = %.3f\n", obs_mean))
```

**Sensitivity analyses (pre-specified, reported as supplementary):**

1. **Permutation test on paired differences:** A one-sided permutation test applied to the same paired differences D_i. Under the null hypothesis, the LDP and control labels are exchangeable within each pair; the sign of each D_i is therefore randomly flipped (equivalent to swapping labels within pairs), and the mean of the permuted differences is recorded. The null distribution is constructed from 1000 such permutations (using the pre-specified seed). The p-value is the proportion of permuted mean differences ≥ the observed mean difference. Effect size is reported as the observed mean paired difference. Note: pairs with D_i = 0 contribute 0 to the permuted mean regardless of sign, which is correct — they carry no directional information. This test makes no distributional assumptions beyond exchangeability within pairs, an assumption met by the random within-institution pairing design. It is reported alongside the paired t-test in all cases, and substituted as the primary result if the normality assumption is violated (see above).

2. **Repeated random pairing (robustness check):** Repeat the primary pairing and paired t-test 99 additional times (different random seeds, total = 100 pairings). Report the distribution of test statistics and the proportion of pairings with one-sided p < 0.05. Because the mean of paired differences equals the difference of group means (invariant to specific pairing), variation across pairings reflects sensitivity of the variance estimate — not the location estimate — to arbitrary within-institution pairing choices.

3. **Per-rater analysis:** Repeat the primary paired test using each individual rater's scores (rather than the mean of k raters) to assess robustness to rater effects.

4. **All-publications analysis:** (*Time permitting - this requires evaluating more publications*) Repeat using all available LDP publications (not one-per-student), pairing each LDP publication with a randomly chosen control from the same institution (controls may be re-used if n_LDP > n_Other within an institution). This explores whether publication selection affects the result.

### Transformations

No transformations of the outcome are planned. The `fair_score` variable is the arithmetic mean of k raters' component-sum scores (k = 3–5) and requires no further transformation before computing paired differences.

### Inference Criteria

- **Significance threshold:** α = 0.05, one-sided
- **Primary test:** One-sided paired t-test on paired differences; permutation test substituted if normality assumption is violated
- **Reported statistics:** Mean paired difference with 95% CI; Cohen's *d*; one-sided p-value; permutation test p-value and observed mean paired difference reported alongside as a sensitivity check; distribution of test statistics across 100 random pairings
- **No multiple comparisons correction** is applied to the primary test, as there is a single pre-registered confirmatory hypothesis. Exploratory component-score analyses will be clearly labeled as exploratory and interpreted accordingly.

### Data Exclusion

- Publications without accessible full text will be excluded from FAIR assessment and replaced with the next eligible publication for that student in the same year (if available); if no same-year replacement exists, the student-author is excluded.
- Publications determined to be outside EEE scope after retrieval will be excluded.
- LDP student-authors for whom no year-matched comparator publication is available (after exhausting all available oversampled comparators at their institution) will be excluded. The number of such exclusions and the institutions affected will be reported.
- If, after exclusions, an institution has no matched control publications, the corresponding LDP publications from that institution will be excluded by random selection.
- Outliers in FAIR scores will **not** be excluded; the outcome is bounded (0–10) and extreme values are interpretable.

### Missing Data

- **Missing rater scores:** If one rater is unable to complete assessment for a given publication, the FAIR score for that publication will be computed as the mean of the remaining raters' scores (minimum of two required). If fewer than two rater scores are available for any publication, that publication will be excluded from analysis.
- **Missing institution data:** Publications with missing institution information (required for pairing) will be excluded.
- The number of excluded publications and the reasons for exclusion will be reported.

### Exploratory Analysis

The following analyses are pre-specified as exploratory (not confirmatory). Results will be clearly labeled as exploratory in any report:

1. **FAIR component breakdown:** Separate group comparisons for each of the five FAIR components (Findable, Accessible, Interoperable, Reusable-Documentation, Reusable-Licensing) to identify which aspects of FAIR compliance differ most between groups.

2. **Institution-level subgroup analysis:** Separate group comparisons within the two largest institutions (UBC, McGill) to assess whether the overall result holds within each dominant site.

3. **Score distribution visualization:** Observed FAIR score distributions and paired difference distributions by group.

4. **Rater-level analysis:** Descriptive summary of mean scores by rater to identify any systematic rater tendencies.

### Other

**Pre-registration timing:** This pre-registration is submitted prior to the collection of FAIR compliance scores. The publication lists have been assembled, but no scoring has occurred.

**Ethics:** This study received ethics approval from the UBC Behavioural Research Ethics Board (UBC BREB) on 2026-01-06.

**Deviations:** Any deviations from this pre-registered analysis plan that occur during the study will be documented with justifications in the final manuscript.

**Related work:** The thesis classification pipeline used to identify control authors is described in a [companion repository](https://github.com/pitherj/LDP_thesis_classification). The pipeline uses a text-based machine learning classifier trained on Canadian graduate thesis metadata to identify EEE students, followed by author and publication disambiguation via the OpenAlex API.

