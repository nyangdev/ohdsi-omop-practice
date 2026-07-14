# Eunomia Practice Report

## 1. 실습 개요

본 실습에서는 OHDSI에서 제공하는 Eunomia Sample CDM을 이용하여 OMOP Common Data Model의 주요 테이블과 Standardized Vocabulary 구조를 직접 조회하였습니다.

또한 특정 임상 개념을 이용한 간단한 Rule-based Cohort를 생성하고, 주요 OMOP CDM 테이블을 대상으로 기본적인 Data Quality 검사를 수행하였습니다.

모든 실습은 GPT를 이용해서 진행했습니다.

---

## 2. 실습 환경

### 사용 기술

- R
- SQL
- Eunomia
- DatabaseConnector
- SqlRender
- SQLite
- RStudio

### 주요 프로젝트 파일

```text
r/00_setup.R
r/01_connect_eunomia.R
r/02_run_sql_examples.R
r/03_export_results.R
```

### 데이터베이스 환경

Eunomia는 OHDSI 학습과 패키지 테스트에 사용할 수 있는 Sample OMOP CDM 데이터셋입니다.

이번 실습에서는 Eunomia 패키지가 제공하는 Connection Details를 이용해 SQLite 데이터베이스에 연결하였습니다.

```r
connection_details <- Eunomia::getEunomiaConnectionDetails()

connection <- DatabaseConnector::connect(
  connection_details
)
```

---

## 3. Eunomia 연결 및 테이블 확인

`r/01_connect_eunomia.R`에서는 Eunomia 데이터베이스에 연결하고, 주요 OMOP CDM 테이블이 존재하는지 확인하였습니다.

확인한 주요 테이블은 다음과 같습니다.

- `person`
- `observation_period`
- `visit_occurrence`
- `condition_occurrence`
- `drug_exposure`
- `measurement`
- `concept`

연결 과정에서는 다음 사항을 확인하였습니다.

```text
Eunomia 연결 가능 여부
→ main schema의 테이블 목록 조회
→ 실습에 필요한 주요 테이블 존재 여부 확인
→ 작업 종료 후 Connection 해제
```

---

## 4. SQL 실행 구조

`r/02_run_sql_examples.R`에서는 여러 SQL 파일을 동일한 방식으로 실행할 수 있도록 공통 함수 `run_sql_file()`을 작성하였습니다.

공통 실행 흐름은 다음과 같습니다.

```text
SQL 파일 존재 여부 확인
→ SQL 파일 읽기
→ Schema parameter 치환
→ SQLite dialect로 변환
→ SQL 실행
→ R data.frame 반환
```

주요 코드 흐름은 다음과 같습니다.

```r
sql <- SqlRender::readSql(sql_file)

rendered_sql <- SqlRender::render(
  sql = sql,
  cdm_database_schema = "main"
)

translated_sql <- SqlRender::translate(
  sql = rendered_sql,
  targetDialect = "sqlite"
)

result <- DatabaseConnector::querySql(
  connection = connection,
  sql = translated_sql
)
```

SQL 파일에서는 데이터베이스의 실제 schema 이름을 직접 작성하지 않고 다음 parameter를 사용하였습니다.

```sql
@cdm_database_schema
```

이를 통해 SQL 파일과 실제 실행 환경을 분리하였습니다.

---

## 5. Core OMOP CDM 테이블 탐색

### 5.1 주요 테이블 행 수 확인

`sql/01_core_table_counts.sql`에서는 실습에 사용한 주요 OMOP CDM 테이블의 행 수를 확인하였습니다.

조회 대상에는 다음 테이블이 포함되었습니다.

- `person`
- `observation_period`
- `visit_occurrence`
- `condition_occurrence`
- `drug_exposure`
- `measurement`

이 조회를 통해 테이블별 데이터 규모를 확인하고, Eunomia Sample CDM에서 어떤 임상 영역의 기록이 상대적으로 많이 존재하는지 파악하였습니다.

실행 결과는 다음 문서에 기록하였습니다.

```text
results/01_core_table_counts.md
```

### 5.2 Record 수와 Person 수 비교

`sql/02_person_event_summary.sql`에서는 각 테이블의 전체 Record 수와 고유 `person_id` 수를 함께 계산하였습니다.

이를 통해 다음 차이를 확인하였습니다.

```text
record_count
= 테이블에 저장된 전체 이벤트 행 수

person_count
= 해당 이벤트를 보유한 고유 대상자 수
```

한 대상자는 여러 이벤트를 가질 수 있으므로 다음 관계가 일반적으로 나타납니다.

```text
record_count >= person_count
```

이 실습을 통해 임상 이벤트 테이블의 행 수를 환자 수로 해석해서는 안 된다는 점을 확인하였습니다.

실행 결과는 다음 문서에 기록하였습니다.

```text
results/02_person_event_summary.md
```

---

## 6. Standardized Vocabulary 실습

## 6.1 Condition Concept 조회

`sql/03_join_condition_with_concept.sql`에서는 `condition_occurrence.condition_concept_id`를 `concept.concept_id`와 연결하였습니다.

이를 통해 Condition 기록에 저장된 숫자형 Concept ID를 다음 정보로 해석하였습니다.

- `concept_name`
- `domain_id`
- `vocabulary_id`
- `standard_concept`

또한 Concept별 Condition Record 수와 고유 대상자 수를 계산하였습니다.

```text
condition_concept_id
→ concept 테이블 조인
→ Standardized clinical meaning 확인
```

실행 결과는 다음 문서에 기록하였습니다.

```text
results/03_top_conditions.md
```

## 6.2 Drug Concept 조회

`sql/04_join_drug_with_concept.sql`에서는 `drug_exposure.drug_concept_id`를 `concept` 테이블과 연결하였습니다.

Drug Concept에서는 약물 concept의 세부 유형을 담고있는 `concept_class_id`를 추가로 확인하였습니다.

실행 결과는 다음 문서에 기록하였습니다.

```text
results/04_top_drugs.md
```

## 6.3 Measurement Concept 및 결과값 확인

`sql/05_join_measurement_with_concept.sql`에서는 다음 정보를 함께 확인하였습니다.

- Measurement Concept
- Unit Concept
- Numeric Result
- Categorical Result
- Source Result
- Missing Result

Measurement에서 무엇을 측정했는지는 `measurement_concept_id`를 통해 확인할 수 있지만, 실제 결과값은 다음 컬럼에 저장될 수 있습니다.

```text
value_as_number
value_as_concept_id
value_source_value
```

Eunomia Measurement 결과에서는 많은 기록에서 다음 특성이 확인되었습니다.

```text
Measurement 이벤트 존재
→ measurement_concept_id 존재
→ 실제 결과값 없음
→ unit_concept_id = 0
```

검사 또는 측정이 수행되었다는 사실은 기록되어 있지만, 결과값 기반 분석에는 제한이 있는 데이터라고 판단했습니다.

실행 결과는 다음 문서에 기록하였습니다.

```text
results/05_top_measurements.md
```

---

## 7. Source Value와 Standard Concept 비교

`sql/06_source_value_vs_concept.sql`에서는 Condition 기록에 저장된 다음 값을 비교하였습니다.

- `condition_source_value`
- `condition_source_concept_id`
- `condition_concept_id`

각 컬럼의 역할은 다음과 같습니다.

```text
condition_source_value
→ 원천 시스템에서 가져온 코드 또는 값

condition_source_concept_id
→ 원천 코드를 표현하는 OMOP Source Concept

condition_concept_id
→ 분석에 사용하는 Standard Concept
```

실행 결과는 다음 문서에 기록하였습니다.

```text
results/06_source_value_vs_concept.md
```

---

## 8. Concept 후보 탐색

`sql/07_concept_set_like_query.sql`에서는 `diabetes` 키워드를 이용하여 다음 조건을 만족하는 Concept 후보를 검색하였습니다.

```text
domain_id = Condition
standard_concept = S
invalid_reason IS NULL
```

그러나 Eunomia 검색 결과에서는 다음 Concept 한 건만 확인되었습니다.

```text
Diabetes mellitus due to cystic fibrosis
```

Eunomia에는 Sample CDM 실습에 필요한 Vocabulary subset이 포함되어 있으므로, 전체 OMOP Vocabulary에서 조회할 수 있는 모든 Diabetes Concept가 포함되어 있지는 않았습니다.

따라서 diabetes 키워드 검색 결과를 Cohort Concept Set으로는 사용하지 않았습니다.

---

## 9. Simple Rule-Based Cohort 생성

`sql/08_simple_rule_based_cohort.sql`에서는 Eunomia 실습 데이터에서 활용 가능한 Gastrointestinal hemorrhage Concept를 이용해 간단한 Cohort를 생성하였습니다.

사용한 대표 Concept ID는 다음과 같습니다.

```text
192671
```

Cohort Definition은 다음 규칙으로 구성하였다.

| Cohort element          | Definition                           |
| ----------------------- | ------------------------------------ |
| Target concept          | Gastrointestinal hemorrhage          |
| Descendant concepts     | `concept_ancestor`로 포함               |
| Entry event             | `condition_occurrence`               |
| Observation requirement | Condition 발생일이 Observation Period 내부 |
| Primary event limit     | 대상자별 최초 이벤트                          |
| Index date              | 최초 GI bleed `condition_start_date`   |
| Cohort end date         | Observation Period 종료일               |
| Re-entry                | 허용하지 않음                              |

Concept 계층은 다음 구조로 적용하였습니다.

```text
Gastrointestinal hemorrhage
→ 대표 Concept
→ Descendant Concepts
```

대상자별로 여러 GI bleed 이벤트가 존재할 수 있으므로 `ROW_NUMBER()`를 사용해 코호트 진입 이벤트 발생이 가장 빠른 이벤트를 선택하였습니다.

```text
대상자별 이벤트 정렬
→ event_rank = 1
→ 최초 이벤트를 Index Date로 선택
```

실행 결과는 다음 문서에 기록하였다.

```text
results/07_simple_cohort_result.md
```

---

## 10. Data Quality 검사

`sql/09_dq_checks.sql`에서는 실습에 사용한 주요 OMOP CDM 테이블을 대상으로 19개의 기초 Data Quality 검사를 수행하였습니다.

검사 영역은 다음과 같습니다.

- Uniqueness : 기본키가 중복되지 않았는가?
- Temporal validity : Observation Period 날짜 순서가 올바른가?
- Referential integrity : 임상 기록의 person_id와 concept_id가 실제 테이블에 존재하는가?
- Standardization : 임상 기록이 Standard Concept로 매핑되지 않은 상태인 것이 있는가?
- Completeness : Measurement에 측정 결과값이 존재하는가?

### 10.1 Primary Key Uniqueness

다음 결과가 확인되었습니다.

| Table                  |        Finding |
| ---------------------- | -------------: |
| `person`               |              0 |
| `observation_period`   |              0 |
| `condition_occurrence` |              0 |
| `drug_exposure`        | 초과 중복 행 4,384건 |
| `measurement`          | 초과 중복 행 2,183건 |

### 10.2 Temporal Validity

Observation Period의 시작일이 종료일보다 늦은 기록은 발견되지 않았습니다.

반면 대상자의 어떤 Observation Period에도 포함되지 않는 임상 이벤트가 일부 확인되었습니다.

| Event         | Outside Observation Period |
| ------------- | -------------------------: |
| Condition     |                         85 |
| Drug Exposure |                         80 |
| Measurement   |                          4 |

해당 기록들은 Observation Period 내부 이벤트만 사용하는 Cohort나 분석에서 제외될 수 있습니다.

### 10.3 Referential Integrity

다음 참조 관계에서는 발견 사항이 없었습니다.

```text
condition_occurrence.person_id
→ person.person_id

drug_exposure.person_id
→ person.person_id

measurement.person_id
→ person.person_id
```

또한 0이 아닌 주요 임상 Concept ID가 `concept` 테이블에 존재하지 않는 경우도 발견되지 않았습니다.

### 10.4 Standardization

다음 주요 임상 Concept ID가 `0`인 기록은 발견되지 않았습니다.

* `condition_concept_id`
* `drug_concept_id`
* `measurement_concept_id`

### 10.5 Measurement Completeness

실제 Measurement 결과값이 없는 기록이 다음과 같이 확인되었습니다.

```text
44,053 records
```

해당 기록에서는 다음 컬럼이 모두 비어 있거나 사용 가능한 Concept 값이 없었습니다.

```text
value_as_number
value_as_concept_id
value_source_value
```

따라서 검사 수행 여부는 확인할 수 있지만, 검사 수치 또는 범주형 결과 기반 분석에는 제한이 있는 데이터셋이라고 판단했습니다.

전체 실행 결과와 상세 해석은 다음 문서에 기록하였습니다.

```text
results/08_dq_check_results.md
```

---

## 11. 결과 Export 자동화

`r/03_export_results.R`에서는 R에서 생성된 Query Result 객체를 Markdown 표로 변환하여 기존 `results/` 문서에 반영하도록 구성하였습니다.

자동 생성 영역은 다음 Marker로 관리하였습니다.

```html
<!-- AUTO-GENERATED-RESULT:START -->
<!-- AUTO-GENERATED-RESULT:END -->
```

스크립트를 다시 실행하면 기존 결과 문서 전체를 덮어쓰지 않고 Marker 사이의 영역만 교체하는 형식입니다.

---

## 12. 결론

이번 실습은 Eunomia Sample CDM에 연결하여 주요 OMOP CDM 테이블의 구조를 확인하고 데이터를 SQL을 이용하여 간단히 조회해본 실습이었습니다.