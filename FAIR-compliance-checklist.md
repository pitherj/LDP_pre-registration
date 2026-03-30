# LDP FAIR Evaluation Guidance

## Context

### What's Being Measured

The goal is evaluation of data attached to a publication for its adherence to FAIR. As such, we start with the premise that the researcher's data management practices are being measured using the categories of FAIR. However, their practices may be limited by external factors beyond their control, so the goal is not to establish if the 'best' practice has been met, but rather that the 'best available' practice has been met.

It is also being assumed here that the FAIR principles are being used for publication findings verification; data re-use in another application is tertiary to this. This then necessarily implies some looser restrictions that include limited time window for continued validation of data, subject matter familiarity with data types and software, norms on the use of certain binary data types, etc.

Some reasonable limitations that might emerge from this then include, for example, that while ostensibly the most interoperable format would be plain text, in some circumstances it may not be viable, such as when memory storage or transfer limitations exist, requiring a smaller, binary representation of the data, i.e. some form of compression. Similarly, ideally access is open and frictionless, however, many data sets have reasonable limitations to access and the researcher should not be penalised for this. However, unless these limitations are described, understanding the rationale for limited access is not possible.

## Guide

### Findable

The publication is the conduit to the data in this context, so the data need not be independently discoverable of the publication. Findable then requires an explicit statement about the data in the body of the publication. This is best done in a structured way, with **a defined data availability statement as a header**. Less ideal is a statement in passing elsewhere in the publication. In either case, this statement should include a pointer to the actual data (section of paper, file name of supplementary materials, stable identifier (i.e. DOI) to external repository, data steward, etc.). In all cases, the link must correctly redirect the reader. This redirection may lead one to a paywall, data access requirement, or other barrier to access; this is an issue of access not 'findability'.

| Criteria | Score |
| :--- | :--- |
| Includes structured data availability statement with a working pointer. | 1 |
| Includes unstructured data availability statement with a working pointer. | 0.5 |
| No data availability statement is made or working pointer is missing. | 0 |

### Accessible

Accessibility will depend on whether or not data are reasonably restricted. If data are restricted for any reason, a statement indicating the need for the restrictions should be articulated. If there is no evident need for restricting access, the data should be reasonably expected to be made available without formal request to a data steward. The extra barriers to accessing restricted data are reasonable and imply dur diligence on the part of the researcher, and this should not be penalised.

For data that are not restricted access, accessible will be interpreted as the data can be downloaded or recreated programmatically (a script is provided that does not require debugging), and clear instructions are provided for doing so. Additionally, if data are generated, this generation should be operating system agnostic (Linux, Mac, Windows) and should not rely on software behind a paywall. However, hardware limitations may reasonably prevent a laptop or desktop computer from generating the data. Lastly, access in this way may change over time; this evaluation is not measuring how 'future proofed' this access is, only if it can be accessed at the point in time that access is being verified.

For data that are restricted, accessible will be interpreted as clear access protocols being articulated; this may include mediated access or non-access to the data depending on restriction level. In any case, general or specific access considerations should be provided; simply providing contact information for an access request is insufficient. If the author of the paper is not responsible for provisioning access to the data (commercially restricted, legally restricted, culturally restricted, etc.) this is clearly articulated and the source for access is pointed to.

| Criteria | Score |
| :--- | :--- |
| Data are not restricted and downloadable or can be programmatically recreated. | 1 |
| Data are restricted; access protocols are clearly articulated. | 1 |
| Data are not restricted, but cannot be readily downloaded or programmatically recreated/ | 0 |
| Data are restricted; no clear access protocols are defined. | 0 |
| Data are restricted; no reasonable argument is provided for the restriction. | 0 |

### Interoperable

Interoperable implies that data can be used across systems; systems here will be interpreted as both hardware and software. This is enabled through open specification. Thus, any open specification file format will be interpreted as interoperable, whether the file format is proprietary or not. There is no preference for text-based or binary formats.

| Criteria | Score |
| :--- | :--- |
| Data are interoperable (provided in an open specification format) | 1 |
| Date are not interoperable (closed source, closed specification, binary format) | 0 |

### Reusable

Reusability is characterised by two key aspects: a) the ability to understand the data; b) knowledge of how the data may or may not be reused. Both should remove all guess work and the need to make assumptions about the data.

The former is reliant on data documentation that, among other things, establishes the provenance, and hence acts as a marker of trust, in the acquisition and processing of the data. Documentation may be embedded with the data or standalone, and, at a minimum captures the following.

A)	Data Documentation

* Data file formats are clearly identified. These formats do not need to be interoperable.
* Collection protocols are outlined or source of the data if it is identified if not original data. Data collection protocols should address who collected the data (who is responsible for initial integrity), when and where it was collected (context), and how it was collected (what instruments were used). The 'where' may be reasonably restricted for some data.
* Data processing is documented. For this to maintain the marker of trust this cannot simply be described in accompanying documentation; it should be scripted, and all scripts from initial data ingest to data used for analysis should be provided. These scripts require sufficient documentation to understand their implementation. The scripts are not under direct evaluation; other than being able to clearly describe the processing activities (literate programming, robust commenting), it is not required that they be executable.
* All variables are described; all variable names include descriptions of the variables, are accompanied by relevant scales, ranges, etc. indicate if they are derived, etc. The focus is on human reusability, not machine reusability, so while metadata standards are preferred in making variables machine interpretable and actionable, this is not required.

| Criteria | Score |
| :--- | :--- |
| File formats are identified. | 0.2 |
| Collection protocols are noted. | 0.2 |
| Includes scripted data processing. | 0.2 |
| Variables are fulsomely described. | 0.2 |

B)	Data Licensing 

The data are accompanied by a clearly articulated license indicating how the data may be re-used, re-distributed, and how it should be accredited. While publicly available licenses are preferred (CC, OSI, GNU, etc.), bespoke licenses with lay interpretations suffice. Again, we are evaluating on human reusability; a lay interpretation allows non-legal experts to properly re-use the data.

| Criteria | Score |
| :--- | :--- |
| A publicly sourced license is attached, or a bespoke license is included with a lay summary. | 0.2 |