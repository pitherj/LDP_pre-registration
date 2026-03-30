# Living Data Project: Pre-registration

This repository contains the pre-registration document for the study:

> **Assessing Open Science Practices Among Graduates of the Living Data Project, a Canada-wide Graduate Training Program**


## Project Timeline

| Date | Activity |
|------|----------|
| 2025-10-10 | Project conceived |
| 2026-01-06 | Ethics approval (UBC BREB) |
| 2026-01-13 | Pre-registration initiated |
| 2026-01-13 | README created |
| 2026-03-30 | README last updated |

## Overview

**Research Question:** Are data archives associated with peer-reviewed publications authored by graduates of the Living Data Project (LDP) — who received structured training in open science and FAIR data practices — more FAIR-compliant than those associated with publications from matched control graduates who did not receive such training?

**Study Design:** Paired, matched-groups observational study. 21 LDP student first-authors are each matched one-to-one with a control student-author from the same institution and same publication year. The primary outcome is a FAIR compliance score (0–10) assessed independently by three to five raters (k = 3–5) using a standardized checklist.

**Primary test:** One-sided paired t-test on within-pair differences (LDP minus matched control), α = 0.05. A permutation test (sign-flip) is substituted if normality of paired differences is violated.

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
| Matched pairs | 21 (N = 42 publications: 21 LDP + 21 control) |
| Matching criteria | Same institution; same publication year |
| Raters | k = 3–5 independent raters |
| Outcome | FAIR compliance score (0–10), mean of k raters' scores |
| Primary test | One-sided paired t-test on paired differences; permutation test substituted if normality violated |
| Effect size | Cohen's *d* for paired differences |
| Significance level | α = 0.05, one-sided |
| Random seed | 20260329 |
| IRR measures | ICC (two-way mixed, absolute agreement, average measures) and Krippendorff's α |

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

**AI usage**: Claude Code (Sonnet 4.6) contributed to coding and ensuring computational reproducibility, with oversight by Jason Pither.  

## License

CC-By Attribution 4.0 International

## Contact

Jason Pither (jason [dot] pither <at> ubc [dot] ca)

## Acknowledgements

This work was financially supported by NSERC CREATE and the Canadian Institute for Ecology & Evolution.
