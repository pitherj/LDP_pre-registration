---
output:
  pdf_document:
    latex_engine: xelatex
  html_document: default
---
# OSF Pre-registration

---

## Metadata

**Title**

Assessing Open Science Practices Among Graduates of the Living Data Project, a Canada-wide Graduate Training Program

**Description**

Despite a growing awareness of low transparency and replicability of research across many scientific disciplines, practices that enhance good research conduct — such as pre-registration and sharing of code and non-sensitive data — remain rare. Insufficient access to suitable training has long been identified as a key barrier. The Living Data Project (LDP), an initiative of the Canadian Institute of Ecology and Evolution funded through Canada's NSERC CREATE program between 2020 and 2026, aims to address this shortfall for graduate students in ecology, evolution, and environmental science (EEE) across Canada.

The LDP offered formal graduate courses to enhance research transparency and replicability, providing four 1-credit, synchronous, online modules each year, each comprising eight 90-minute sessions. Two modules focused specifically on training students in the principles and practices of open science, including pre-registrations, sharing code, and following FAIR principles for open data (doi.org/10.1038/SDATA.2016.18). The two other modules addressed synthesis statistics and scientific collaboration.

To evaluate whether the training provided by the LDP has made a difference, we conduct a quasi-experimental, matched-groups study comparing FAIR compliance scores of research data associated with publications authored by LDP trainees versus matched controls. Controls are graduate students from the same institutions who did not receive LDP training, and who completed theses in EEE.  The latter are identified using a text-based thesis classifier applied to Canadian thesis metadata, with author publications retrieved via the OpenAlex API.

FAIR compliance is assessed by three to five trained raters using a standardised FAIR compliance checklist, producing a composite score (0–4) for each publication. We focus on the first three cohorts of LDP graduates (2020–2022), as these are the most likely to have a sufficient number of published research outputs.

**Contributors**

- Jason Pither ([0000-0002-7490-6839](https://orcid.org/0000-0002-7490-6839))
- Mathew Vis-Dunbar ([0000-0001-6541-9660](https://orcid.org/0000-0001-6541-9660))
- Sandra Michelle Emry ([0000-0001-6882-2105](https://orcid.org/0000-0001-6882-2105))
- David AGA Hunt ([0000-0002-7771-8569](https://orcid.org/0000-0002-7771-8569))
- Diane Srivastava ([0000-0003-4541-5595](https://orcid.org/0000-0003-4541-5595))

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

- **H~0~:** The mean paired difference in FAIR compliance score (LDP minus matched control, within institution) is zero. (mu~D~ = 0)
- **H~a~:** The mean paired difference in FAIR compliance score is positive — LDP publications score higher than their matched controls. (mu~D~ > 0)

**Justification for directional hypothesis:** There is no theoretical basis for expecting that structured training in open science practices would decrease the adoption of FAIR data practices below the level observed in a general population of recently graduated EEE students.

---

## Design Plan

### Study Type

Observational Study — Data are collected from study units (published research articles) that are not randomly assigned to a treatment. The "treatment" (LDP training) was received by students as part of their graduate program; group assignment is observational, not randomised.

We use a matched-groups (quasi-experimental) design.

### Blinding

- Raters are not blinded to author identity. Data archives that adhere to FAIR principles will, by design, prominently identify contributors and authors in their metadata; attempting to conceal these identifiers would be both impractical and contrary to the nature of the assessment objects.
- The potential for rater bias introduced by knowledge of author identity is considered minimal, given that the FAIR assessment checklist comprises predominantly binary and ordinal items (e.g., is a data availability statement present? are the data in an open format? is a license provided?) that leave little room for subjective interpretation.
- Raters are partially blinded to group membership (LDP vs. Other); during rating, the raters may recognise names of students who completed the LDP courses. We expect this occurrence to be minimal. 

### Is there any additional blinding in this study?

Raters will be blind to each others' scores during the initial independent rating phase. Scores from all raters (k = 3 to 5) will be collected independently before any inter-rater reliability assessment or adjudication is conducted.

### Study Design

Paired, matched-groups observational study with one binary grouping factor (LDP vs. Other). Each publication is evaluated by three to five independent raters (k = 3–5; exact number confirmed prior to scoring). The unit of analysis is the publication (one per student author), and the unit of inference is the within-institution matched pair.

Matching criteria are: (1) same academic institution and (2) same publication year (the calendar year of the selected qualifying first-author article). A candidate control pool is drawn from EEE graduate students at the same institution with thesis deposit years 2022–2024 (serving as a proxy for graduation year contemporaneous with LDP cohorts). Program level (MSc vs. PhD) is not used as a matching criterion because it is not available for all students.

Within each institution, LDP and control publications are randomly paired one-to-one, constrained to the same publication year. The comparator pool is oversampled at 2 × N_target per institution to ensure year-coverage across all LDP publication years. LDP student-authors without a year-matched comparator are excluded; the number of such exclusions is reported. Complete 1:1 pairing within each year is not guaranteed and depends on comparator availability.

### Randomisation

This is an observational study; subjects are not randomly assigned to groups.

However, randomisation is used in three places, all using a single pre-specified random seed (**seed = 20260329**):

1. **LDP publication selection:** For each LDP student-author with multiple eligible publications, one is selected at random. The calendar year of the selected publication (Year *Y*) determines which comparator publications are eligible for pairing.

2. **Within-institution, year-matched pairing:** Within each institution, LDP and control authors are randomly paired one-to-one, constrained so that both the LDP publication and the comparator publication are from the same calendar year. Specifically: (a) LDP publications are randomly ordered within each institution; (b) for each LDP publication (year *Y*), one qualifying comparator publication from Year *Y* is selected at random from the oversampled comparator pool. This is the pairing used for the primary hypothesis test.

3. **Exclusion due to insufficient controls:** If an institution has more LDP student-authors than available year-matched comparator publications, the excess LDP observations will be excluded by random selection. If no year-matched comparator is available for a given LDP student-author, that student-author is excluded (see Data Exclusion).

---

## Sampling Plan

### Existing Data

Registration prior to creation of data — As of the date of submission of this pre-registration, the FAIR compliance scores (the primary outcome data) have not yet been collected. The list of publications to be evaluated has been generated, but no FAIR scoring has been conducted. The pre-registration is therefore being submitted prior to any observation of the outcome data.

### Explanation of Existing Data

The publication lists (the inputs to scoring) have been assembled prior to pre-registration as a necessary step in study design (to determine the achievable sample size and thus requisite time for rater assessments). However, no FAIR compliance scores have been calculated or observed, and no outcome data has been analysed. The research team has not examined any open science or FAIR-related characteristics of the identified publications.

### Data Collection Procedures

**Identification of LDP student-authors:**
LDP student-authors are identified from course enrollment records for LDP cohorts 2020–2022. A student is eligible if they are the first author on at least one peer-reviewed research article published in a scholarly journal. Publications are identified using the OpenAlex API, matching student names to author records. Because LDP courses were offered in the fall of each year, a student completing the course in year *Y* could only have applied their training to research initiated after course completion; consequently, the minimum qualifying publication date for each student is January 1 of year *Y* + 1 (e.g., January 1, 2021 for a 2020 cohort student). Each student's enrollment year is recorded in the author roster and used to set their individual publication search cutoff.

**Identification of control student-authors:**
Control student-authors are identified using a text-based machine learning classifier (trained on thesis titles and abstracts) that identifies EEE graduate students from Canadian post-secondary institutions (see associated GitHub repo [here](https://github.com/pitherj/LDP_thesis_classification)). Candidate controls must: (1) be enrolled at an LDP-affiliated institution, (2) have a thesis deposit year within the range 2022–2024, and (3) have at least one first-author peer-reviewed research article published from 2021-01-01 onwards. Controls must not have participated in any LDP course. Program level (MSc or PhD) is recorded where available but is not used as a matching criterion, as it is incomplete across LDP students. To support year-matched pairing (see Publication Selection below), comparator authors are collected at up to 2× the required sample size per institution (i.e., up to 2 × N_target), subject to the number of eligible EEE thesis authors available at each institution. Excess comparators beyond N_target are not used in the primary analysis but provide year-coverage across all publication years represented by LDP students.

**Publication selection:**
For each eligible LDP student-author, one first-author peer-reviewed research article is selected at random (using the pre-specified seed) when multiple eligible publications exist. The calendar year of that selected publication (Year *Y*) is recorded. For the matched comparator at the same institution, one publication from Year *Y* is then selected at random from that comparator's available qualifying publications. This year-matched selection ensures that each LDP–comparator pair is drawn from the same publication year, controlling for temporal changes in journal and publisher requirements for data sharing that could otherwise confound FAIR score comparisons. If a comparator has no qualifying publication in Year *Y*, that LDP student-author is excluded from the analysis (see Data Exclusion). The oversampled comparator pool (2 × N_target per institution) is intended to reduce the incidence of such exclusions.

**FAIR compliance assessment:**
Three to five trained raters (k = 3–5) independently evaluate each selected publication using the standardised FAIR compliance checklist. Raters are not informed of the group membership (LDP vs. Other) of the publications they assess; however, partial unblinding may occur if a rater recognises a student author as an LDP participant. Raters are blind to each other's scores throughout the independent rating phase. Ratings are conducted independently and collected before inter-rater reliability is assessed. Any item-level discrepancies will be noted but will not result in adjudication for the primary analysis (the mean of k raters' scores is used). Adjudicated consensus scores may be used in a sensitivity analysis.

**Inclusion criteria for publications:**
- First-author publication by an eligible student-author
- Peer-reviewed primary research article (not review articles, editorials, or conference proceedings)
- Published on or after January 1 of the year following the student's LDP course enrollment year (e.g., on or after 2021-01-01 for a student enrolled in the 2020 cohort); for controls, published on or after January 1, 2021 (the earliest applicable cutoff)

**Exclusion criteria:**
- Publications for which full text is either not open-access, or not accessible via subscription to raters (this is not anticipated to be a problem; access required for FAIR assessment)
- Publications in disciplines clearly outside EEE (based on classification above)

### Sample Size

The sample size is determined by the number of eligible LDP student-authors with at least one qualifying publication surviving all filtering steps. As of pre-registration, **22 unique LDP student first-authors** have at least one qualifying publication after applying all inclusion/exclusion criteria (investigator co-authorship exclusion, title deduplication, primary-research type filter, and title keyword screen).

Of these 22 LDP authors, **21 yielded a matched pair**: one LDP author was excluded because no comparator publication from the same institution and the same calendar year was available in the oversampled comparator pool. The total sample size is therefore **N = 42 publications** (21 LDP + 21 Other), forming **21 matched pairs**. Publications span multiple institutions; the institution-level breakdown is documented in `data/processed_data/private/rater_key.csv`.

### Sample Size Rationale

The sample size is fixed by the number of eligible LDP graduates — it is not under researcher control. The achieved n = 21 pairs is used to evaluate statistical power.

**Power analysis (one-sided paired t-test, α = 0.05, n = 21 pairs):**

Power for the paired t-test depends on the standard deviation of the within-pair differences (SD~D~), not the standard deviation of the raw scores. Assuming SD~D~ ≈ 1.0 (a conservative estimate for a 0–4 bounded score when pairs share institutional context), the study has approximately:
- 80% power to detect a mean paired difference of ≈ 0.57 points (Cohen's d ≈ 0.57)
- 90% power to detect a mean paired difference of ≈ 0.70 points (Cohen's d ≈ 0.70)

If the within-pair differences are less variable (e.g., SD~D~ ≈ 0.85), these thresholds are proportionally smaller (≈ 0.48 and ≈ 0.59 points respectively). Power estimates were obtained using `pwr::pwr.t.test(n = 21, sig.level = 0.05, type = "paired", alternative = "greater")`.

The study is adequately powered to detect moderate-to-large effects (Cohen's d ≥ 0.57) but is underpowered for small effects (Cohen's d < 0.4). The detectable effect sizes are considered plausible given the targeted nature of the LDP training; however, the inability to detect smaller effects is acknowledged as a limitation. The permutation test (sign-flip on paired differences) has power approaching that of the paired t-test under normality, so these estimates are approximately applicable to the backup test as well.

### Stopping Rule

Not applicable. The sample is fully determined by the eligible pool of LDP graduates prior to data collection. No sequential stopping rule is needed.

---

## Variables

### Manipulated Variables

Not applicable. This is an observational study. The "treatment" (LDP training) was not assigned by the researchers.

### Measured Variables

**Primary outcome variable — FAIR compliance score:**
A composite score ranging from 0 to 4, representing the degree to which the data associated with a publication adheres to FAIR principles (Findable, Accessible, Interoperable, Reusable). Each of the four FAIR letters contributes a maximum of 1 point; sub-items within Reusable are scored in increments of 0.2, so non-integer values are possible. Assessed independently by k raters (k = 3–5) using the standardised FAIR compliance checklist. The variable used in primary analysis is the **mean of the k raters' scores** (a continuous value in [0, 4]).

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

**FAIR compliance score (0–4):**

The composite score assigns equal maximum weight (1 point) to each of the four FAIR principles. The score is the sum of the following component scores, each assessed independently by each rater:

| FAIR letter | Component | Scoring | Maximum |
|---|---|---|---|
| **Findable** | Data availability statement with working pointer | Structured statement = 1; unstructured statement = 0.5; absent or pointer missing = 0 | 1 |
| **Accessible** | Data downloadable/recreatable (unrestricted) OR access protocols clearly articulated (restricted) | Binary: 1 = criterion met, 0 = not met | 1 |
| **Interoperable** | Data provided in an open-specification format | Binary: 1 = criterion met, 0 = not met | 1 |
| **Reusable** — file formats identified | File formats clearly identified | 0.2 |
| **Reusable** — collection protocols | Collection protocols outlined or data source identified | 0.2 |
| **Reusable** — scripted processing | Data processing is scripted and documented | 0.2 |
| **Reusable** — variables described | All variables fulsomely described | 0.2 |
| **Reusable** — licensing | Publicly sourced license, or bespoke license with lay summary | 0.2 |
| **Total** | | | **4** |

**Notes:**
- The Findable score is a single ordinal dimension (structured > unstructured > absent), not two independent binary items. The highest applicable level is recorded.
- The five Reusable sub-items each contribute 0.2 points, summing to a maximum of 1.0 for the Reusable component. This preserves equal weighting across all four FAIR letters.
- Non-integer total scores are possible (e.g., a publication with an unstructured data availability statement scores 0.5 on Findable).

The primary analysis uses the **mean of all k raters' component-sum scores** (k = 3–5) as the outcome variable (a continuous value in [0, 4]).

---

## FAIR Compliance Checklist

This section reproduces the full FAIR compliance assessment instrument used by raters. Scores are recorded per item and summed to produce the composite FAIR compliance score (0–4) described in the Indices section above.

### Context

#### What Is Being Measured

The goal is evaluation of data attached to a publication for its adherence to FAIR. As such, we start with the premise that the researcher's data management practices are being measured using the categories of FAIR. However, their practices may be limited by external factors beyond their control, so the goal is not to establish if the 'best' practice has been met, but rather that the 'best available' practice has been met.

It is also being assumed here that the FAIR principles are being used for publication findings verification; data re-use in another application is tertiary to this. This then necessarily implies some looser restrictions that include limited time window for continued validation of data, subject matter familiarity with data types and software, norms on the use of certain binary data types, etc.

Some reasonable limitations that might emerge from this then include, for example, that while ostensibly the most interoperable format would be plain text, in some circumstances it may not be viable, such as when memory storage or transfer limitations exist, requiring a smaller, binary representation of the data, i.e. some form of compression. Similarly, ideally access is open and frictionless, however, many data sets have reasonable limitations to access and the researcher should not be penalised for this. However, unless these limitations are described, understanding the rationale for limited access is not possible.

### Rating Guide

#### Findable

The publication is the conduit to the data in this context, so the data need not be independently discoverable of the publication. Findable then requires an explicit statement about the data in the body of the publication. This is best done in a structured way, with **a defined data availability statement as a header**. Less ideal is a statement in passing elsewhere in the publication. In either case, this statement should include a pointer to the actual data (section of paper, file name of supplementary materials, stable identifier (i.e. DOI) to external repository, data steward, etc.). In all cases, the link must correctly redirect the reader. This redirection may lead one to a paywall, data access requirement, or other barrier to access; this is an issue of access not 'findability'.

| Criteria | Score |
| :--- | :--- |
| Includes structured data availability statement with a working pointer. | 1 |
| Includes unstructured data availability statement with a working pointer. | 0.5 |
| No data availability statement is made or working pointer is missing. | 0 |

#### Accessible

Accessibility will depend on whether or not data are reasonably restricted. If data are restricted for any reason, a statement indicating the need for the restrictions should be articulated. If there is no evident need for restricting access, the data should be reasonably expected to be made available without formal request to a data steward. The extra barriers to accessing restricted data are reasonable and imply due diligence on the part of the researcher, and this should not be penalised.

For data that are not restricted access, accessible will be interpreted as the data can be downloaded or recreated programmatically (a script is provided that does not require debugging), and clear instructions are provided for doing so. Additionally, if data are generated, this generation should be operating system agnostic (Linux, Mac, Windows) and should not rely on software behind a paywall. However, hardware limitations may reasonably prevent a laptop or desktop computer from generating the data. Lastly, access in this way may change over time; this evaluation is not measuring how 'future proofed' this access is, only if it can be accessed at the point in time that access is being verified.

For data that are restricted, accessible will be interpreted as clear access protocols being articulated; this may include mediated access or non-access to the data depending on restriction level. In any case, general or specific access considerations should be provided; simply providing contact information for an access request is insufficient. If the author of the paper is not responsible for provisioning access to the data (commercially restricted, legally restricted, culturally restricted, etc.) this is clearly articulated and the source for access is pointed to.

| Criteria | Score |
| :--- | :--- |
| Data are not restricted and downloadable or can be programmatically recreated. | 1 |
| Data are restricted; access protocols are clearly articulated. | 1 |
| Data are not restricted, but cannot be readily downloaded or programmatically recreated. | 0 |
| Data are restricted; no clear access protocols are defined. | 0 |
| Data are restricted; no reasonable argument is provided for the restriction. | 0 |

#### Interoperable

Interoperable implies that data can be used across systems; systems here will be interpreted as both hardware and software. This is enabled through open specification. Thus, any open specification file format will be interpreted as interoperable, whether the file format is proprietary or not. There is no preference for text-based or binary formats.

| Criteria | Score |
| :--- | :--- |
| Data are interoperable (provided in an open specification format). | 1 |
| Data are not interoperable (closed source, closed specification, binary format). | 0 |

#### Reusable

Reusability is characterised by two key aspects: (a) the ability to understand the data; (b) knowledge of how the data may or may not be reused. Both should remove all guesswork and the need to make assumptions about the data.

**A) Data Documentation**

The former is reliant on data documentation that, among other things, establishes the provenance, and hence acts as a marker of trust, in the acquisition and processing of the data. Documentation may be embedded with the data or standalone, and, at a minimum, captures the following.

- Data file formats are clearly identified. These formats do not need to be interoperable.
- Collection protocols are outlined or the source of the data is identified if it is not original data. Data collection protocols should address who collected the data (who is responsible for initial integrity), when and where it was collected (context), and how it was collected (what instruments were used). The 'where' may be reasonably restricted for some data.
- Data processing is documented. For this to maintain the marker of trust this cannot simply be described in accompanying documentation; it should be scripted, and all scripts from initial data ingest to data used for analysis should be provided. These scripts require sufficient documentation to understand their implementation. The scripts are not under direct evaluation; other than being able to clearly describe the processing activities (literate programming, robust commenting), it is not required that they be executable.
- All variables are described; all variable names include descriptions of the variables, are accompanied by relevant scales, ranges, etc., and indicate if they are derived, etc. The focus is on human reusability, not machine reusability, so while metadata standards are preferred in making variables machine interpretable and actionable, this is not required.

| Criteria | Score |
| :--- | :--- |
| File formats are identified. | 0.2 |
| Collection protocols are noted. | 0.2 |
| Includes scripted data processing. | 0.2 |
| Variables are fulsomely described. | 0.2 |

**B) Data Licensing**

The data are accompanied by a clearly articulated license indicating how the data may be re-used, re-distributed, and how it should be accredited. While publicly available licenses are preferred (CC, OSI, GNU, etc.), bespoke licenses with lay interpretations suffice. Again, we are evaluating on human reusability; a lay interpretation allows non-legal experts to properly re-use the data.

| Criteria | Score |
| :--- | :--- |
| A publicly sourced license is attached, or a bespoke license is included with a lay summary. | 0.2 |

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
    levels       = c(fair_score = "interval"),  # interval scale: fractional sub-items make equal spacing assumption reasonable
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

Because the outcome is the mean of k independent raters' scores (k = 3–5) — rather than a single raw rating — the paired differences D_i are quasi-continuous and benefit from within-pair averaging that moves their distribution toward normality. At n = 21 pairs the Central Limit Theorem provides some robustness, though the small sample size means that the permutation sensitivity analysis is especially important. The paired t-test is therefore the preferred primary test: it directly tests the mean difference (which is the quantity of interest) and yields Cohen's *d* as an interpretable effect size. 

**Assumption check (pre-specified):** Before interpreting the result, normality of the paired differences will be assessed using visual inspection (histogram and Q-Q plot). If visual inspection indicates meaningful departure from normality, the permutation test (Sensitivity Analysis 1 below) will be substituted as the primary inferential result.

Test H~0~: mu~D~ = 0 against H~a~: mu~D~ > 0 at α = 0.05, implemented using `t.test(D, alternative = "greater", mu = 0)` in R.

**Paired differences are computed from one pre-specified random pairing** (within-institution, **seed = 20260329**).

**Effect size:** Cohen's *d* for paired differences, computed as mean(D~i~) / SD~D~, with a 95% confidence interval.

**Example R code for primary analysis:**

```r
# Compute paired differences
# 'data' has one row per matched pair; columns: fair_score_LDP, fair_score_Other
D <- data$fair_score_LDP - data$fair_score_Other

# --- Assumption check: normality of paired differences ---

par(mfrow = c(1, 2))
hist(D, main = "Paired differences", xlab = "LDP − Other (mean FAIR score, 0–4 scale)")
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

2. **Repeated random pairing (robustness check):** Addresses the question: *"Is the p-value conclusion sensitive to which specific LDP publication happened to be matched to which specific comparator, within the same institution and year?"* This is distinct from the permutation test, which fixes the pairing and randomises labels; here the labels are fixed and the pairing is randomised. The primary pairing and paired t-test are repeated 99 additional times using different random seeds (total = 100 pairings). The distribution of t-statistics and the proportion of pairings with one-sided p < 0.05 are reported. Because the mean of paired differences equals the difference of group means regardless of how pairs are formed, variation across pairings reflects sensitivity of the variance estimate — not the mean paired difference — to arbitrary within-institution pairing choices.

3. **Per-rater analysis:** Repeat the primary paired test using each individual rater's scores (rather than the mean of k raters) to assess robustness to rater effects.

4. **All-publications analysis:** (*Time permitting - this requires evaluating more publications*) Repeat using all available LDP publications (not one-per-student), pairing each LDP publication with a randomly chosen control from the same institution (controls may be re-used if n_LDP > n_Other within an institution). This explores whether publication selection affects the result.

### Transformations

No transformations of the outcome are planned. The `fair_score` variable is the arithmetic mean of k raters' component-sum scores (k = 3–5) and requires no further transformation before computing paired differences.

### Inference Criteria

- **Significance threshold:** α = 0.05, one-sided
- **Primary test:** One-sided paired t-test on paired differences; permutation test substituted if normality assumption is violated
- **Reported statistics:** Mean paired difference with 95% CI; Cohen's *d*; one-sided p-value; permutation test p-value and observed mean paired difference reported alongside as a sensitivity check; distribution of test statistics across 100 random pairings
- **No multiple comparisons correction** is applied to the primary test, as there is a single pre-registered confirmatory hypothesis. Exploratory component-score analyses will be clearly labelled as exploratory and interpreted accordingly.

### Data Exclusion

- Publications without accessible full text (either via Open Access or subscription) will be excluded from FAIR assessment and replaced with the next eligible publication for that student in the same year (if available); if no same-year replacement exists, the student-author is excluded.
- Publications determined to be outside EEE scope after retrieval will be excluded.
- LDP student-authors for whom no year-matched comparator publication is available (after exhausting all available oversampled comparators at their institution) will be excluded. The number of such exclusions and the institutions affected will be reported.
- If, after exclusions, an institution has no matched control publications, the corresponding LDP publications from that institution will be excluded by random selection.
- Outliers in FAIR scores will **not** be excluded; the outcome is bounded (0–4) and extreme values are interpretable.

### Missing Data

- **Missing rater scores:** If one rater is unable to complete assessment for a given publication, the FAIR score for that publication will be computed as the mean of the remaining raters' scores (minimum of two required). If fewer than two rater scores are available for any publication, that publication will be excluded from analysis.
- **Missing institution data:** Publications with missing institution information (required for pairing) will be excluded.
- The number of excluded publications and the reasons for exclusion will be reported.

### Exploratory Analysis

The following analyses are pre-specified as exploratory (not confirmatory). Results will be clearly labelled as exploratory in any report:

1. **FAIR component breakdown:** Separate group comparisons for each of the four FAIR letter scores (Findable, Accessible, Interoperable, Reusable) and for the two Reusable sub-components (Documentation, Licensing) to identify which aspects of FAIR compliance differ most between groups.

2. **Institution-level subgroup analysis:** Separate group comparisons within the two largest institutions (UBC, McGill) to assess whether the overall result holds within each dominant site.

3. **Score distribution visualisation:** Observed FAIR score distributions and paired difference distributions by group.

4. **Rater-level analysis:** Descriptive summary of mean scores by rater to identify any systematic rater tendencies.

### Other

**Pre-registration timing:** This pre-registration is submitted prior to the collection of FAIR compliance scores. The publication lists have been assembled, but no scoring has occurred.

**Ethics:** This study received ethics approval from the UBC Behavioural Research Ethics Board (UBC BREB) on 2026-01-06.

**Deviations:** Any deviations from this pre-registered analysis plan that occur during the study will be documented with justifications in the final manuscript.

**Related work:** The thesis classification pipeline used to identify control authors is described in a [companion repository](https://github.com/pitherj/LDP_thesis_classification). The pipeline uses a text-based machine learning classifier trained on Canadian graduate thesis metadata to identify EEE students, followed by author and publication disambiguation via the OpenAlex API.

