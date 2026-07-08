# OHDSI OMOP Practice

This repository documents my learning and practice process for OHDSI and OMOP CDM.

The goal of this project is to understand how real-world healthcare data can be standardized into the OMOP Common Data Model, connected with standardized vocabularies, and used for reproducible observational research.

I am currently studying OHDSI / OMOP CDM with a focus on healthcare data standardization, vocabulary mapping, cohort definition, and data quality checks.

---

## Background

I have experience in data engineering and data governance, including metadata-driven ETL, heterogeneous database integration, workflow orchestration, and source-to-target data validation.

Through this practice project, I aim to connect my previous ETL and data quality experience with healthcare data science, especially OMOP CDM-based research workflows.

---

## Learning Goals

The main goals of this repository are:

- Understand the core structure of OMOP CDM
- Explore key CDM tables such as `PERSON`, `OBSERVATION_PERIOD`, `VISIT_OCCURRENCE`, `CONDITION_OCCURRENCE`, `DRUG_EXPOSURE`, `MEASUREMENT`, and `CONCEPT`
- Understand the difference between source values, source concepts, and standard concepts
- Practice joining clinical event tables with the `CONCEPT` table
- Understand how concept sets are used to define diseases, drugs, and measurements
- Write a simple rule-based cohort SQL
- Write basic data quality check SQL
- Connect OMOP CDM practice with my previous metadata-driven ETL experience

---

## Current Status

- Completed first-round reading of selected chapters from *The Book of OHDSI Korea*
- Summarized core concepts including OMOP CDM, Vocabulary, ETL, Cohort, Data Quality, and OHDSI tools
- Preparing local R environment for OHDSI package practice
- Planning to use Eunomia sample OMOP CDM data for hands-on SQL practice

---

## Practice Roadmap

### 1. OHDSI / OMOP CDM Learning Summary

Summarize the core concepts from *The Book of OHDSI Korea*.

Topics:

- OMOP CDM structure
- CDM schema vs result schema
- Standardized Vocabulary and Concept
- Source Value, Source Concept, Standard Concept
- ETL process and vocabulary mapping
- Cohort definition
- Data Quality
- OHDSI tools such as ATLAS, SqlRender, DatabaseConnector, ACHILLES, and DataQualityDashboard

---

### 2. Eunomia Sample CDM Setuap

Use Eunomia sample OMOP CDM data to explore actual CDM tables.

Planned tasks:

- Install and load OHDSI R packages
- Connect to Eunomia sample CDM
- Check available CDM tables
- Run basic SQL queries through R

---

### 3. Core CDM Table Exploration

Explore major OMOP CDM tables.

Target tables:

- `PERSON`
- `OBSERVATION_PERIOD`
- `VISIT_OCCURRENCE`
- `CONDITION_OCCURRENCE`
- `DRUG_EXPOSURE`
- `MEASUREMENT`
- `OBSERVATION`
- `CONCEPT`

Planned queries:

- Row count by table
- Patient-level event summary
- Visit, condition, drug, and measurement counts by person

---

### 4. Vocabulary and Concept Practice

Practice how clinical event tables are connected to standardized vocabulary.

Planned queries:

- Join `CONDITION_OCCURRENCE` with `CONCEPT`
- Join `DRUG_EXPOSURE` with `CONCEPT`
- Join `MEASUREMENT` with `CONCEPT`
- Compare `source_value`, `source_concept_id`, and standard `concept_id`
- Identify records with `concept_id = 0`

---

### 5. Simple Concept Set and Cohort SQL

Practice the basic idea of concept sets and rule-based cohort definitions.

Planned tasks:

- Create a simple concept set-like query using selected concept IDs
- Use `CONCEPT_ANCESTOR` to explore descendant concepts
- Define a simple cohort using `subject_id`, `cohort_start_date`, and `cohort_end_date`
- Understand that an OHDSI cohort is a person-period set, not just a list of people

---

### 6. Basic Data Quality Checks

Write simple SQL-based data quality checks before using automated tools.

Planned checks:

- Required column null checks
- `concept_id = 0` checks
- Date plausibility checks
- Orphan `person_id` checks
- Events outside observation period
- Invalid visit reference checks

---

## Repository Structure

```text
ohdsi-omop-practice/
├── README.md
├── .gitignore
├── docs/
│   ├── 01_ohdsi_learning_summary.md
│   ├── 02_eunomia_practice_report.md
│   ├── 03_concept_vocabulary_summary.md
│   ├── 04_data_quality_summary.md
│   └── 05_reflection_data_engineering_perspective.md
├── r/
│   ├── 00_setup.R
│   ├── 01_connect_eunomia.R
│   ├── 02_run_sql_examples.R
│   └── 03_export_results.R
├── sql/
│   ├── 01_core_table_counts.sql
│   ├── 02_person_event_summary.sql
│   ├── 03_join_condition_with_concept.sql
│   ├── 04_join_drug_with_concept.sql
│   ├── 05_join_measurement_with_concept.sql
│   ├── 06_source_value_vs_concept.sql
│   ├── 07_concept_set_like_query.sql
│   ├── 08_simple_rule_based_cohort.sql
│   └── 09_dq_checks.sql
├── results/
│   ├── 01_core_table_counts.md
│   ├── 02_person_event_summary.md
│   ├── 03_top_conditions.md
│   ├── 04_top_drugs.md
│   ├── 05_top_measurements.md
│   ├── 06_source_value_vs_concept.md
│   ├── 07_simple_cohort_result.md
│   └── 08_dq_check_results.md
└── images/
    └── omop_core_table_flow.png

---

This project is not intended to build a predictive model, but to practice the foundational data standardization and quality checking workflow required before real-world healthcare data can be used for research.