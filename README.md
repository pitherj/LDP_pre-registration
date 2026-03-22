# Living Data Project: Pre-registration

This repository contains the pre-registration document for the study:

> **Assessing Open Science Practices Among Graduates of the Living Data Project, a Canada-wide Graduate Training Program**

## Overview

**Research Question:** Are data archives associated with peer-reviewed publications authored by graduates of the Living Data Project (LDP) — who received structured training in open science and FAIR data practices — more FAIR-compliant than those associated with publications from matched control graduates who did not receive such training?

**Study Design:** Paired, matched-groups observational study. Each of 60 LDP student first-authors is matched one-to-one with a control student-author from the same institution. The primary outcome is a FAIR compliance score (0–10) assessed independently by three raters using a standardized checklist.

**Primary test:** One-sided Wilcoxon signed-rank test on within-pair differences (LDP minus matched control), α = 0.05.

## Project Structure

```
.
├── LDP_preregistration_OSF.md      # Pre-registration document (OSF submission version)
├── osf_preregistration_template.md # OSF pre-registration template (reference)
└── README.md                       # This file
```

## Main Document

**`LDP_preregistration_OSF.md`** — The pre-registration document formatted for submission to OSF. Contains the full study description, hypotheses, design plan, sampling plan, variable definitions, FAIR compliance checklist, and analysis plan.

## Study Design Summary

| Feature | Detail |
|---|---|
| Design | Matched-groups observational study |
| Unit of analysis | Publication (one per student-author) |
| Unit of inference | Within-institution matched pair |
| Groups | LDP graduates (n = 60) vs. matched controls (n = 60) |
| Institutions | 7 (majority: UBC n = 33, McGill n = 20) |
| Matching criteria | Same institution; overlapping thesis deposit years (2022–2024) |
| Outcome | FAIR compliance score (0–10), mean of 3 raters |
| Primary test | One-sided paired t-test on paired differences (Wilcoxon signed-rank if normality violated) |
| Effect size | Cohen's *d* (Hodges-Lehmann pseudo-median if Wilcoxon substituted) |
| Significance level | α = 0.05, one-sided |
| IRR measures | ICC (two-way mixed, absolute agreement) and Krippendorff's α |

## FAIR Compliance Checklist (0–10)

| Component | Type | Max |
|---|---|---|
| Findable — data availability statement (structured vs. unstructured vs. absent) | Ordinal (2/1/0) | 2 |
| Accessible — data downloadable or access protocols articulated | Binary | 1 |
| Interoperable — data in open specification format | Binary | 1 |
| Reusable — file formats identified | Binary | 1 |
| Reusable — collection protocols or data source documented | Binary | 1 |
| Reusable — processing is scripted and documented | Binary | 1 |
| Reusable — all variables described | Binary | 1 |
| Reusable — data accompanied by a license | Binary | 1 |
| **Total** | | **10** |

## Blinding

Raters are **not** blinded to author identity. Data archives adhering to FAIR principles prominently identify contributors in their metadata, making author-identity blinding both impractical and contrary to the nature of the assessment objects. Rater bias is minimised by the checklist structure, which is predominantly binary/ordinal and leaves little room for subjective interpretation.

Raters are partially blinded to group membership (LDP vs. Other); during rating, the raters may recognise names of students who completed the LDP courses. We expect this occurrence to be minimal.

Raters are blind to each other's scores throughout the independent rating phase.

## Authors

Jason Pither, Mathew Vis-Dunbar, Sandra Emry, David Hunt, Diane Srivastava

## License

CC-By Attribution 4.0 International

## Contact

Jason Pither (jason [dot] pither <at> ubc [dot] ca)

## Acknowledgements

This work was financially supported by NSERC CREATE and the Canadian Institute for Ecology & Evolution.
