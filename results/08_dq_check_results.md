# OMOP CDM Data Quality Check Results

## 실습 목적

Eunomia Sample CDM의 주요 OMOP CDM 테이블을 대상으로 기본적인 Data Quality 검사를 수행하였습니다.

이번 검사는 OMOP Data Quality Dashboard 전체 규칙을 구현하는 것이 아니라, 실습에서 사용한 주요 테이블을 대상으로 다음 품질 영역을 직접 확인하는 것을 목적으로 하였습니다.

- Primary Key uniqueness
- Temporal validity
- Person reference integrity
- Standard Concept mapping status
- Concept reference integrity
- Measurement result completeness

## 실행 환경

- Sample CDM: Eunomia
- Database: SQLite
- CDM schema: `main`
- Query: `sql/09_dq_checks.sql`
- Execution script: `r/02_run_sql_examples.R`

## 전체 검사 결과

| Check ID | Category              | Check name                                            | Finding count |
| -------- | --------------------- | ----------------------------------------------------- | ------------: |
| DQ001    | Uniqueness            | Duplicate `person_id`                                 |             0 |
| DQ002    | Uniqueness            | Duplicate `observation_period_id`                     |             0 |
| DQ003    | Uniqueness            | Duplicate `condition_occurrence_id`                   |             0 |
| DQ004    | Uniqueness            | Duplicate `drug_exposure_id`                          |         4,384 |
| DQ005    | Uniqueness            | Duplicate `measurement_id`                            |         2,183 |
| DQ006    | Temporal validity     | Observation Period start date after end date          |             0 |
| DQ007    | Temporal validity     | Condition start date outside Observation Period       |            85 |
| DQ008    | Temporal validity     | Drug exposure start date outside Observation Period   |            80 |
| DQ009    | Temporal validity     | Measurement date outside Observation Period           |             4 |
| DQ010    | Referential integrity | Condition records with missing Person reference       |             0 |
| DQ011    | Referential integrity | Drug Exposure records with missing Person reference   |             0 |
| DQ012    | Referential integrity | Measurement records with missing Person reference     |             0 |
| DQ013    | Standardization       | Condition records with `condition_concept_id = 0`     |             0 |
| DQ014    | Standardization       | Drug Exposure records with `drug_concept_id = 0`      |             0 |
| DQ015    | Standardization       | Measurement records with `measurement_concept_id = 0` |             0 |
| DQ016    | Referential integrity | Condition Concept IDs not found in `concept`          |             0 |
| DQ017    | Referential integrity | Drug Concept IDs not found in `concept`               |             0 |
| DQ018    | Referential integrity | Measurement Concept IDs not found in `concept`        |             0 |
| DQ019    | Completeness          | Measurement records without any result value          |        44,053 |

## 결과 요약

이번 검사에서 다음 주요 발견 사항을 확인하였습니다.

| Quality area                | Main finding                               |
| --------------------------- | ------------------------------------------ |
| Uniqueness                  | `drug_exposure_id`와 `measurement_id` 중복 발견 |
| Temporal validity           | Observation Period 밖에 위치한 일부 임상 이벤트 발견     |
| Person reference integrity  | 발견 사항 없음                                   |
| Standard Concept mapping    | 주요 임상 Concept ID가 `0`인 기록 없음               |
| Concept reference integrity | `concept` 테이블에서 찾을 수 없는 주요 Concept ID 없음   |
| Measurement completeness    | 실제 결과값이 없는 Measurement 기록 44,053건          |

## Primary Key Uniqueness

### 발견 결과

| Table                  | Primary Key               | Excess duplicate row count |
| ---------------------- | ------------------------- | -------------------------: |
| `person`               | `person_id`               |                          0 |
| `observation_period`   | `observation_period_id`   |                          0 |
| `condition_occurrence` | `condition_occurrence_id` |                          0 |
| `drug_exposure`        | `drug_exposure_id`        |                      4,384 |
| `measurement`          | `measurement_id`          |                      2,183 |

`person`, `observation_period`, `condition_occurrence` 테이블에서는 Primary Key 중복이 발견되지 않았습니다.

반면 다음 두 테이블에서는 중복이 발견되었습니다.

```text
drug_exposure_id: 4,384건
measurement_id: 2,183건
```

이번 SQL은 중복된 ID의 종류 수가 아니라, 각 ID별로 정상적인 한 행을 초과한 행의 수를 계산하였습니다.

예를 들어 동일한 ID가 세 행 존재한다면 다음과 같이 계산됩니다.

```text
3 records - 1 expected record
= 2 excess duplicate rows
```

따라서 `4,384`와 `2,183`은 중복 ID의 개수가 아니라 **초과 중복 행 수**를 의미합니다.

OMOP CDM에서 `drug_exposure_id`와 `measurement_id`는 각 행을 고유하게 식별하기 위한 Primary Key입니다.

동일한 대상자에게 같은 날짜와 같은 Concept의 이벤트가 여러 번 발생할 수는 있지만, 각각의 이벤트 행에는 서로 다른 Primary Key가 부여되어야 합니다.

## Temporal Validity

### Observation Period 날짜 순서

다음 오류는 발견되지 않았습니다.

```text
observation_period_start_date
>
observation_period_end_date
```

결과:

```text
Finding count: 0
```

모든 Observation Period에서 시작일이 종료일보다 늦지 않았습니다.

### Observation Period 밖의 임상 이벤트

| Clinical event | Outside Observation Period |
| -------------- | -------------------------: |
| Condition      |                         85 |
| Drug Exposure  |                         80 |
| Measurement    |                          4 |

다음 조건을 만족하는 Observation Period가 존재하지 않는 임상 이벤트를 집계하였습니다.

```text
observation_period_start_date
<= event_date
<= observation_period_end_date
```

Condition 85건, Drug Exposure 80건, Measurement 4건의 이벤트가 대상자의 어떤 Observation Period에도 포함되지 않았습니다.

## Person Reference Integrity

다음 임상 테이블의 `person_id`가 `person` 테이블에 존재하는지 확인하였습니다.

| Table                  | Missing Person reference |
| ---------------------- | -----------------------: |
| `condition_occurrence` |                        0 |
| `drug_exposure`        |                        0 |
| `measurement`          |                        0 |

모든 검사 대상 임상 이벤트가 유효한 Person과 연결되어 있었습니다.

이는 다음 참조 관계에서 발견 사항이 없음을 의미합니다.

```text
condition_occurrence.person_id
→ person.person_id

drug_exposure.person_id
→ person.person_id

measurement.person_id
→ person.person_id
```

## Standard Concept Mapping Status

다음 주요 임상 Concept ID가 `0`인 기록을 확인하였습니다.

| Table                  | Concept column           | Concept ID 0 count |
| ---------------------- | ------------------------ | -----------------: |
| `condition_occurrence` | `condition_concept_id`   |                  0 |
| `drug_exposure`        | `drug_concept_id`        |                  0 |
| `measurement`          | `measurement_concept_id` |                  0 |

검사 대상 세 테이블에서는 주요 임상 Concept ID가 `0`인 기록이 발견되지 않았습니다.

이는 모든 주요 임상 이벤트에 `0`이 아닌 Concept ID가 저장되어 있다는 뜻입니다.

그러나 다음 두 의미는 구분해야 합니다.

```text
Concept ID가 0이 아님
≠
임상적으로 가장 적절한 Standard Concept에 매핑됨
```

이번 검사는 Concept ID가 존재하는지만 확인하였습니다.

원천 코드와 Standard Concept 사이의 임상적 매핑 적절성까지 검증한 것은 아닙니다.

## Concept Reference Integrity

0이 아닌 임상 Concept ID가 `concept` 테이블에 존재하는지 확인하였습니다.

| Clinical table         | Concept IDs missing from `concept` |
| ---------------------- | ---------------------------------: |
| `condition_occurrence` |                                  0 |
| `drug_exposure`        |                                  0 |
| `measurement`          |                                  0 |

모든 검사 대상 Concept ID가 Eunomia의 `concept` 테이블에서 조회 가능하였습니다.

다음 두 상태는 서로 다릅니다.

```text
concept_id = 0
→ 사용할 수 있는 Standard Concept가 연결되지 않은 상태

concept_id <> 0이지만 concept 테이블에 없음
→ Vocabulary 참조 무결성 문제 가능성
```

이번 검사에서는 두 상태 모두 발견되지 않았습니다.

## Measurement Result Completeness

### 발견 결과

```text
Measurement records without any result value: 44,053
```

다음 세 결과 컬럼에 모두 사용 가능한 값이 없는 Measurement 기록을 집계하였습니다.

```text
value_as_number
value_as_concept_id
value_source_value
```

검사 조건은 다음과 같습니다.

```text
value_as_number IS NULL
AND value_as_concept_id IS NULL 또는 0
AND value_source_value IS NULL
```

총 44,053건의 Measurement 기록에서 숫자형, 범주형 및 원천 결과값을 확인할 수 없었습니다.

앞선 Measurement 실습에서도 상위 Measurement Concept 기록에서 동일한 특성을 확인하였습니다.

```text
Measurement 이벤트는 존재
→ 무엇을 측정했는지는 확인 가능
→ 실제 측정 결과는 확인 불가능
```

이는 반드시 OMOP 구조 오류를 의미하지는 않는다고 합니다.

검사가 수행되었다는 사실만 수집되었거나, 원천 시스템에서 결과값을 제공하지 않았을 가능성이 있다고 합니다.

## 결론

Eunomia Sample CDM의 Person 및 Concept 참조 관계에서는 발견 사항이 없었으며, Observation Period의 시작일과 종료일 순서도 정상적이었습니다.

반면 `drug_exposure_id`와 `measurement_id`에서 Primary Key 중복이 발견되었고, 일부 Condition, Drug Exposure 및 Measurement 이벤트가 Observation Period 밖에 존재하였습니다.

또한 44,053건의 Measurement 기록에서 숫자형, 범주형 또는 원천 결과값을 확인할 수 없었습니다.
