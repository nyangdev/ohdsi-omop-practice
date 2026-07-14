# OHDSI OMOP Practice

This repository documents my learning and hands-on practice with OHDSI and the OMOP Common Data Model.

The goal of this project is to understand how real-world healthcare data can be standardized into the OMOP CDM, connected with standardized vocabularies, evaluated for data quality, and prepared for reproducible observational research.

This project focuses on the foundational workflow required before healthcare data can be used for research:

```text
OMOP CDM structure
→ Standardized Vocabulary
→ Clinical event exploration
→ Concept-based cohort definition
→ Data quality evaluation
→ Reproducible result documentation
```

---

## Background

I have experience in data engineering and data governance, including metadata-driven ETL, heterogeneous database integration, workflow orchestration, and source-to-target data validation.

Through this practice project, I connected my previous experience with healthcare data science by exploring how OMOP CDM standardizes data structures, clinical concepts, temporal context, and data quality rules.

This repository does not represent production-level OMOP ETL experience or research using real patient data. It documents a hands-on learning project using the Eunomia Sample CDM.

---

## Learning Goals

The main goals of this repository are:

* Understand the core structure of OMOP CDM
* Explore major CDM tables such as `PERSON`, `OBSERVATION_PERIOD`, `VISIT_OCCURRENCE`, `CONDITION_OCCURRENCE`, `DRUG_EXPOSURE`, `MEASUREMENT`, and `CONCEPT`
* Understand the difference between source values, source concepts, and standard concepts
* Practice joining clinical event tables with the `CONCEPT` table
* Understand the roles of Domain, Vocabulary, Concept Class, and Standard Concept
* Explore Concept candidates and understand the difference between keyword search and a complete Concept Set
* Create a simple rule-based cohort using Concept hierarchy and Observation Period
* Write basic SQL-based OMOP CDM data quality checks
* Document query results in a reproducible format
* Connect OMOP CDM practice with my previous ETL and data validation experience

---

## Current Status

The following practice activities have been completed:

* Completed first-round reading of selected chapters from *The Book of OHDSI Korea*
* Summarized core concepts including OMOP CDM, Standardized Vocabulary, ETL, Cohort Definition, Data Quality, and OHDSI tools
* Configured a local R and RStudio environment
* Installed and tested the required OHDSI R packages
* Connected to the Eunomia Sample CDM using `DatabaseConnector`
* Used `SqlRender` to render and translate SQL for SQLite
* Explored major OMOP CDM tables and clinical event counts
* Joined Condition, Drug, and Measurement records with Standardized Vocabulary concepts
* Compared source values, source concepts, and standard concepts
* Explored diabetes-related Concept candidates in the Eunomia Vocabulary subset
* Created a simple GI bleed rule-based cohort
* Performed 19 basic OMOP CDM data quality checks
* Exported R query results into Markdown result documents

---

## Completed Practice

### 1. OHDSI and OMOP CDM Learning Summary

The foundational concepts from *The Book of OHDSI Korea* were summarized.

Topics include:

* OMOP CDM structure
* CDM schema and result schema
* Standardized Vocabulary and Concept
* Source Value, Source Concept, and Standard Concept
* ETL process and vocabulary mapping
* Observation Period
* Cohort Definition
* Data Quality
* OHDSI tools such as ATLAS, SqlRender, DatabaseConnector, ACHILLES, and Data Quality Dashboard

Related document:

```text
docs/01_ohdsi_learning_summary.md
```

---

### 2. Local Environment and Eunomia Setup

A local R environment was configured for OHDSI package practice.

Completed tasks:

* Installed R and RStudio
* Installed the required OHDSI packages
* Connected to the Eunomia Sample CDM
* Confirmed the availability of major OMOP CDM tables
* Implemented safe database connection and disconnection handling

Related files:

```text
docs/02_environment_setup.md
r/00_setup.R
r/01_connect_eunomia.R
```

---

### 3. Core CDM Table Exploration

The following OMOP CDM tables were explored:

* `PERSON`
* `OBSERVATION_PERIOD`
* `VISIT_OCCURRENCE`
* `CONDITION_OCCURRENCE`
* `DRUG_EXPOSURE`
* `MEASUREMENT`
* `CONCEPT`

Completed queries include:

* Record counts by table
* Record counts and unique Person counts by clinical event table
* Condition frequency by Standard Concept
* Drug Exposure frequency by Standard Concept
* Measurement frequency and result-value availability

This practice confirmed that the number of clinical event records is different from the number of unique patients.

```text
record_count
≠
person_count
```

Related SQL files:

```text
sql/01_core_table_counts.sql
sql/02_person_event_summary.sql
sql/03_join_condition_with_concept.sql
sql/04_join_drug_with_concept.sql
sql/05_join_measurement_with_concept.sql
```

---

### 4. Vocabulary and Concept Practice

Clinical event tables were joined with the `CONCEPT` table to interpret numeric Concept IDs as standardized clinical meanings.

The practice covered:

* Condition Concepts
* Drug Concepts
* Measurement Concepts
* Domain
* Vocabulary
* Concept Class
* Standard Concept
* Concept ID `0`
* Source Value
* Source Concept
* Standard Concept

The following relationship was explored:

```text
Source Value
→ Source Concept
→ Standard Concept
→ Common analysis
```

Related files:

```text
sql/03_join_condition_with_concept.sql
sql/04_join_drug_with_concept.sql
sql/05_join_measurement_with_concept.sql
sql/06_source_value_vs_concept.sql
docs/04_concept_vocabulary_summary.md
```

---

### 5. Concept Candidate Search and Simple Cohort

A keyword-based Concept candidate search was performed using diabetes-related Standard Condition Concepts.

The search showed that the Eunomia database contains only a subset of the complete OMOP Standardized Vocabularies. Only the following matching Concept was returned under the applied conditions:

```text
Diabetes mellitus due to cystic fibrosis
```

This Concept was not used to define a general diabetes cohort because its clinical meaning did not match that purpose.

This practice demonstrated that:

```text
Keyword-based Concept search
≠
Complete and validated Concept Set
```

A separate simple rule-based cohort was created using the Gastrointestinal hemorrhage Concept and its Descendants.

The cohort logic included:

* GI bleed Concept and Descendant Concepts
* `CONDITION_OCCURRENCE` as the Entry Event
* Events occurring within an Observation Period
* The first eligible event per Person
* The first event date as the Index Date
* The Observation Period end date as the Cohort End Date

The final cohort result used the following structure:

```text
cohort_definition_id
subject_id
cohort_start_date
cohort_end_date
```

This cohort was created for learning purposes and is not a clinically validated phenotype.

Related files:

```text
sql/07_concept_set_like_query.sql
sql/08_simple_rule_based_cohort.sql
results/07_simple_cohort_result.md
```

---

### 6. Basic Data Quality Checks

A total of 19 basic SQL-based Data Quality checks were performed.

The checks covered:

* Primary Key uniqueness
* Observation Period date validity
* Clinical events outside Observation Period
* Missing Person references
* Major clinical Concept IDs equal to `0`
* Concept IDs missing from the `CONCEPT` table
* Measurement result completeness

Major findings included:

| Quality check                                   | Finding |
| ----------------------------------------------- | ------: |
| Excess duplicate `drug_exposure_id` rows        |   4,384 |
| Excess duplicate `measurement_id` rows          |   2,183 |
| Condition events outside Observation Period     |      85 |
| Drug Exposure events outside Observation Period |      80 |
| Measurement events outside Observation Period   |       4 |
| Measurement records without any result value    |  44,053 |

No findings were identified for:

* Duplicate `person_id`
* Duplicate `observation_period_id`
* Duplicate `condition_occurrence_id`
* Invalid Observation Period date order
* Missing Person references
* Major clinical Concept IDs equal to `0`
* Major Concept IDs missing from the `CONCEPT` table

The results demonstrate that successful SQL execution and structural CDM availability do not automatically guarantee fitness for research use.

```text
Pipeline success
≠
Data quality success

CDM conformance
≠
Fitness for use
```

Related files:

```text
sql/09_dq_checks.sql
results/08_dq_check_results.md
docs/05_data_quality_summary.md
```

---

### 7. Reproducible Query Execution and Result Export

A reusable R function was implemented to execute SQL files consistently.

The execution workflow includes:

```text
Read SQL file
→ Render schema parameters
→ Translate SQL to SQLite
→ Execute query
→ Return an R data frame
```

A separate export script converts query results into Markdown tables and updates generated sections in the existing result documents.

Generated result sections are managed using the following markers:

```text
AUTO-GENERATED-RESULT:START
AUTO-GENERATED-RESULT:END
```

This reduces manual copy errors and helps keep query results synchronized with the result documentation.

Related files:

```text
r/02_run_sql_examples.R
r/03_export_results.R
```

---

## Repository Structure

```text
ohdsi-omop-practice/
├── README.md
├── .gitignore
├── docs/
│   ├── 01_ohdsi_learning_summary.md
│   ├── 02_environment_setup.md
│   ├── 03_eunomia_practice_report.md
│   ├── 04_concept_vocabulary_summary.md
│   └── 05_data_quality_summary.md
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
└── results/
    ├── 01_core_table_counts.md
    ├── 02_person_event_summary.md
    ├── 03_top_conditions.md
    ├── 04_top_drugs.md
    ├── 05_top_measurements.md
    ├── 06_source_value_vs_concept.md
    ├── 07_simple_cohort_result.md
    └── 08_dq_check_results.md
```

---

## Project Scope and Limitations

This project focuses on foundational OMOP CDM learning and practice.

It does not include:

* Real patient-level healthcare data
* Production-level Source-to-CDM ETL
* Complete Athena Vocabulary data
* A clinically validated Concept Set
* A clinically validated Cohort phenotype
* Causal inference
* Patient-level prediction
* Population-level effect estimation
* A complete Data Quality Dashboard execution

The project is not intended to build a predictive model. It focuses on the data standardization, vocabulary, cohort, and quality-checking workflow required before real-world healthcare data can be used for research.

---

## AI Assistance Disclosure

All practice activities and documentation in this repository were completed with assistance from GPT.

I personally executed the code and SQL queries, reviewed the outputs, resolved execution errors, and verified the final contents of the repository.

---

## Data Note

This repository uses public sample data for learning purposes.

No real patient-level data, private healthcare data, or personally identifiable information is included in this repository.

---

# OHDSI OMOP Practice

이 저장소는 OHDSI와 OMOP Common Data Model에 대한 학습 및 실습 과정을 기록합니다.

이 프로젝트의 목표는 실제 의료 데이터가 OMOP CDM 구조로 어떻게 표준화되는지, Standardized Vocabulary와 어떻게 연결되는지, 데이터 품질을 어떻게 평가하는지, 재현 가능한 관찰 연구를 위해 어떻게 준비되는지를 이해하는 것입니다.

이 프로젝트는 의료 데이터를 연구에 사용하기 전에 필요한 다음 기초 흐름에 중점을 둡니다.

```text
OMOP CDM 구조
→ Standardized Vocabulary
→ 임상 이벤트 탐색
→ Concept 기반 Cohort 정의
→ Data Quality 평가
→ 재현 가능한 결과 문서화
```

---

## 배경

저는 Metadata 기반 ETL, 이기종 Database 통합, Workflow Orchestration, Source-to-Target 데이터 검증을 포함한 데이터 엔지니어링 및 데이터 거버넌스 경험이 있습니다.

이번 실습 프로젝트에서는 OMOP CDM이 데이터 구조, 임상 Concept, 시간적 맥락 및 데이터 품질 규칙을 어떻게 표준화하는지 탐색하며 기존 경험을 의료 데이터 과학과 연결하고자 하였습니다.

이 저장소는 운영 환경의 OMOP ETL 경험이나 실제 환자 데이터를 이용한 연구 경험을 의미하지 않습니다. Eunomia Sample CDM을 이용해 수행한 실습 중심의 학습 프로젝트를 기록합니다.

---

## 학습 목표

이 저장소의 주요 학습 목표는 다음과 같습니다.

* OMOP CDM의 핵심 구조 이해
* `PERSON`, `OBSERVATION_PERIOD`, `VISIT_OCCURRENCE`, `CONDITION_OCCURRENCE`, `DRUG_EXPOSURE`, `MEASUREMENT`, `CONCEPT`와 같은 주요 CDM 테이블 탐색
* Source Value, Source Concept, Standard Concept의 차이 이해
* Clinical Event 테이블과 `CONCEPT` 테이블의 조인 실습
* Domain, Vocabulary, Concept Class, Standard Concept의 역할 이해
* Concept 후보를 탐색하고 키워드 검색과 완성된 Concept Set의 차이 이해
* Concept 계층과 Observation Period를 이용한 간단한 Rule-based Cohort 생성
* SQL 기반의 기본적인 OMOP CDM Data Quality 검사 작성
* Query 결과를 재현 가능한 형식으로 문서화
* OMOP CDM 실습을 기존 ETL 및 데이터 검증 경험과 연결

---

## 현재 진행 상태

다음 실습을 완료하였습니다.

* *The Book of OHDSI Korea*의 주요 장에 대한 1차 학습 완료
* OMOP CDM, Standardized Vocabulary, ETL, Cohort Definition, Data Quality 및 OHDSI 도구의 핵심 개념 정리
* 로컬 R 및 RStudio 환경 구성
* 필요한 OHDSI R Package 설치 및 실행 확인
* `DatabaseConnector`를 이용한 Eunomia Sample CDM 연결
* `SqlRender`를 이용한 SQL Render 및 SQLite Dialect 변환
* 주요 OMOP CDM 테이블과 Clinical Event 규모 탐색
* Condition, Drug, Measurement 기록과 Standardized Vocabulary Concept 조인
* Source Value, Source Concept, Standard Concept 비교
* Eunomia Vocabulary subset에서 Diabetes 관련 Concept 후보 탐색
* 간단한 GI bleed Rule-based Cohort 생성
* 19개의 기본적인 OMOP CDM Data Quality 검사 수행
* R Query 결과를 Markdown 결과 문서로 Export

---

## 완료한 실습

### 1. OHDSI 및 OMOP CDM 학습 정리

*The Book of OHDSI Korea*를 기반으로 기초 개념을 정리하였습니다.

주요 학습 내용은 다음과 같습니다.

* OMOP CDM 구조
* CDM Schema와 Result Schema
* Standardized Vocabulary와 Concept
* Source Value, Source Concept, Standard Concept
* ETL 과정과 Vocabulary Mapping
* Observation Period
* Cohort Definition
* Data Quality
* ATLAS, SqlRender, DatabaseConnector, ACHILLES, Data Quality Dashboard 등의 OHDSI 도구

관련 문서:

```text
docs/01_ohdsi_learning_summary.md
```

---

### 2. 로컬 환경 및 Eunomia 설정

OHDSI Package 실습을 위한 로컬 R 환경을 구성하였습니다.

완료한 작업은 다음과 같습니다.

* R 및 RStudio 설치
* 필요한 OHDSI Package 설치
* Eunomia Sample CDM 연결
* 주요 OMOP CDM 테이블 존재 여부 확인
* 안전한 Database 연결 및 종료 처리 구현

관련 파일:

```text
docs/02_environment_setup.md
r/00_setup.R
r/01_connect_eunomia.R
```

---

### 3. Core CDM 테이블 탐색

다음 OMOP CDM 테이블을 탐색하였습니다.

* `PERSON`
* `OBSERVATION_PERIOD`
* `VISIT_OCCURRENCE`
* `CONDITION_OCCURRENCE`
* `DRUG_EXPOSURE`
* `MEASUREMENT`
* `CONCEPT`

완료한 Query는 다음과 같습니다.

* 테이블별 Record 수 조회
* Clinical Event 테이블별 Record 수와 고유 Person 수 조회
* Standard Concept별 Condition 발생 빈도
* Standard Concept별 Drug Exposure 발생 빈도
* Measurement 발생 빈도 및 결과값 존재 여부 확인

이번 실습을 통해 Clinical Event Record 수와 고유 환자 수가 다르다는 점을 확인하였습니다.

```text
record_count
≠
person_count
```

관련 SQL 파일:

```text
sql/01_core_table_counts.sql
sql/02_person_event_summary.sql
sql/03_join_condition_with_concept.sql
sql/04_join_drug_with_concept.sql
sql/05_join_measurement_with_concept.sql
```

---

### 4. Vocabulary 및 Concept 실습

Clinical Event 테이블과 `CONCEPT` 테이블을 연결하여 숫자형 Concept ID를 표준화된 임상적 의미로 해석하였습니다.

다음 내용을 실습하였습니다.

* Condition Concept
* Drug Concept
* Measurement Concept
* Domain
* Vocabulary
* Concept Class
* Standard Concept
* Concept ID `0`
* Source Value
* Source Concept
* Standard Concept

다음 관계를 탐색하였습니다.

```text
Source Value
→ Source Concept
→ Standard Concept
→ 공통 분석
```

관련 파일:

```text
sql/03_join_condition_with_concept.sql
sql/04_join_drug_with_concept.sql
sql/05_join_measurement_with_concept.sql
sql/06_source_value_vs_concept.sql
docs/04_concept_vocabulary_summary.md
```

---

### 5. Concept 후보 검색 및 간단한 Cohort 생성

Diabetes 관련 Standard Condition Concept를 대상으로 키워드 기반 Concept 후보 검색을 수행하였습니다.

검색 결과를 통해 Eunomia Database에는 전체 OMOP Standardized Vocabularies가 아니라 일부 Vocabulary subset이 포함되어 있다는 점을 확인하였습니다.

적용한 조건에서는 다음 Concept 한 건만 조회되었습니다.

```text
Diabetes mellitus due to cystic fibrosis
```

이 Concept는 일반적인 Diabetes Cohort를 정의하는 목적과 임상적 의미가 일치하지 않았기 때문에 Cohort 정의에는 사용하지 않았습니다.

이번 실습을 통해 다음 차이를 확인하였습니다.

```text
키워드 기반 Concept 검색
≠
완성되고 검증된 Concept Set
```

별도의 실습으로 Gastrointestinal hemorrhage Concept와 그 Descendant를 이용한 간단한 Rule-based Cohort를 생성하였습니다.

Cohort Logic에는 다음 내용이 포함되었습니다.

* GI bleed Concept 및 Descendant Concept
* `CONDITION_OCCURRENCE`를 Entry Event로 사용
* Observation Period 안에서 발생한 Event만 사용
* Person별 첫 번째 적격 Event 선택
* 첫 Event 발생일을 Index Date로 사용
* Observation Period 종료일을 Cohort End Date로 사용

최종 Cohort 결과는 다음 구조를 사용하였습니다.

```text
cohort_definition_id
subject_id
cohort_start_date
cohort_end_date
```

이 Cohort는 학습 목적으로 생성한 것이며, 임상적으로 검증된 Phenotype이 아닙니다.

관련 파일:

```text
sql/07_concept_set_like_query.sql
sql/08_simple_rule_based_cohort.sql
results/07_simple_cohort_result.md
```

---

### 6. 기본 Data Quality 검사

총 19개의 기본적인 SQL 기반 Data Quality 검사를 수행하였습니다.

검사 영역은 다음과 같습니다.

* Primary Key uniqueness
* Observation Period 날짜 유효성
* Observation Period 밖의 Clinical Event
* 존재하지 않는 Person 참조
* 주요 Clinical Concept ID의 `0` 여부
* `CONCEPT` 테이블에서 찾을 수 없는 Concept ID
* Measurement 결과값 완전성

주요 발견 결과는 다음과 같습니다.

| Quality check                            | Finding |
| ---------------------------------------- | ------: |
| 초과 중복 `drug_exposure_id` 행               |   4,384 |
| 초과 중복 `measurement_id` 행                 |   2,183 |
| Observation Period 밖 Condition Event     |      85 |
| Observation Period 밖 Drug Exposure Event |      80 |
| Observation Period 밖 Measurement Event   |       4 |
| 결과값이 없는 Measurement Record               |  44,053 |

다음 영역에서는 발견 사항이 없었습니다.

* 중복된 `person_id`
* 중복된 `observation_period_id`
* 중복된 `condition_occurrence_id`
* Observation Period의 잘못된 날짜 순서
* 존재하지 않는 Person 참조
* 주요 Clinical Concept ID가 `0`인 Record
* `CONCEPT` 테이블에 존재하지 않는 주요 Concept ID

이번 결과를 통해 SQL이 정상적으로 실행되고 CDM 구조가 존재한다고 해서 연구 목적에 적합한 데이터 품질이 자동으로 보장되는 것은 아니라는 점을 확인하였습니다.

```text
Pipeline 성공
≠
Data Quality 성공

CDM Conformance
≠
Fitness for Use
```

관련 파일:

```text
sql/09_dq_checks.sql
results/08_dq_check_results.md
docs/05_data_quality_summary.md
```

---

### 7. 재현 가능한 Query 실행 및 결과 Export

여러 SQL 파일을 일관된 방식으로 실행할 수 있도록 재사용 가능한 R 함수를 구현하였습니다.

실행 흐름은 다음과 같습니다.

```text
SQL 파일 읽기
→ Schema Parameter 적용
→ SQLite Dialect로 변환
→ Query 실행
→ R Data Frame 반환
```

별도의 Export Script에서는 Query 결과를 Markdown 표로 변환하고, 기존 결과 문서의 자동 생성 영역을 갱신합니다.

자동 생성 결과 영역은 다음 Marker로 관리합니다.

```text
AUTO-GENERATED-RESULT:START
AUTO-GENERATED-RESULT:END
```

이를 통해 결과값을 수동으로 복사하면서 발생할 수 있는 오류를 줄이고, Query 결과와 결과 문서가 일치하도록 구성하였습니다.

관련 파일:

```text
r/02_run_sql_examples.R
r/03_export_results.R
```

---

## 저장소 구조

```text
ohdsi-omop-practice/
├── README.md
├── .gitignore
├── docs/
│   ├── 01_ohdsi_learning_summary.md
│   ├── 02_environment_setup.md
│   ├── 03_eunomia_practice_report.md
│   ├── 04_concept_vocabulary_summary.md
│   └── 05_data_quality_summary.md
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
└── results/
    ├── 01_core_table_counts.md
    ├── 02_person_event_summary.md
    ├── 03_top_conditions.md
    ├── 04_top_drugs.md
    ├── 05_top_measurements.md
    ├── 06_source_value_vs_concept.md
    ├── 07_simple_cohort_result.md
    └── 08_dq_check_results.md
```

---

## 프로젝트 범위 및 한계

이 프로젝트는 OMOP CDM의 기초 학습과 실습에 중점을 둡니다.

다음 내용은 포함하지 않습니다.

* 실제 환자 수준 의료 데이터
* 운영 환경 수준의 Source-to-CDM ETL
* 전체 Athena Vocabulary 데이터
* 임상적으로 검증된 Concept Set
* 임상적으로 검증된 Cohort Phenotype
* 인과 추론
* Patient-level Prediction
* Population-level Effect Estimation
* 전체 Data Quality Dashboard 실행

이 프로젝트는 예측 모델을 개발하는 것이 목적이 아닙니다.

실제 의료 데이터를 연구에 활용하기 전에 필요한 데이터 표준화, Vocabulary, Cohort 및 Data Quality 검사 흐름을 실습하는 것을 목적으로 합니다.

---

## AI 활용 고지

이 저장소의 모든 실습 진행과 문서 작성은 GPT의 도움을 받아 수행하였습니다.

코드와 SQL Query는 직접 실행하였으며, 실행 결과를 검토하고 오류를 해결한 뒤 저장소의 최종 내용을 직접 확인하였습니다.

---

## 데이터 안내

이 저장소는 학습 목적으로 공개된 Sample Data를 사용합니다.

실제 환자 수준 데이터, 비공개 의료 데이터 또는 개인식별정보는 포함하지 않습니다.
