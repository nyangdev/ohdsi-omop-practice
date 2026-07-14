# Simple Rule-Based Cohort Result

## 실습 목적

Eunomia Sample CDM에서 위장관 출혈(Gastrointestinal hemorrhage) Condition 기록을 이용하여 간단한 Rule-based Cohort를 생성하였습니다.

이번 실습은 특정 Condition Concept와 하위 Concept를 임상 이벤트에 적용하고, 대상자별 최초 발생일을 Index Date로 정의하여 코호트 시작일과 종료일을 생성하는 과정을 이해하기 위해 수행하였습니다.

## 실행 환경

- Sample CDM: Eunomia
- Database: SQLite
- CDM schema: `main`
- Entry event table: `condition_occurrence`
- Observation table: `observation_period`
- Concept hierarchy table: `concept_ancestor`
- Query: `sql/08_simple_rule_based_cohort.sql`
- Execution script: `r/02_run_sql_examples.R`

## 코호트 정의

이번 코호트는 다음 규칙으로 정의하였습니다.

| Cohort element          | Definition                                        |
| ----------------------- | ------------------------------------------------- |
| Target concept          | Gastrointestinal hemorrhage                       |
| Target concept ID       | `192671`                                          |
| Descendant concepts     | `concept_ancestor`를 이용하여 포함                       |
| Entry event             | GI bleed에 해당하는 `condition_occurrence` 기록          |
| Observation requirement | Condition 발생일이 Observation Period 시작일과 종료일 사이에 존재 |
| Primary event limit     | 대상자별 최초 이벤트 1건                                    |
| Index date              | 최초 GI bleed `condition_start_date`                |
| Cohort start date       | Index Date                                        |
| Cohort end date         | 해당 이벤트가 속한 Observation Period의 종료일                |
| Re-entry                | 허용하지 않음                                           |

## 실행 결과 요약

```
unique(simple_cohort$cohort_definition_id)

nrow(simple_cohort)
length(unique(simple_cohort$subject_id))
anyDuplicated(simple_cohort$subject_id)

min(simple_cohort$cohort_start_date)
max(simple_cohort$cohort_start_date)
min(simple_cohort$cohort_end_date)
max(simple_cohort$cohort_end_date)
```
위의 명령어로 확인한 결과는

* Cohort definition ID: `1`
* Number of cohort rows: `479`
* Number of unique subjects: `479`
* Duplicate subject count: `0`
* Earliest cohort start date: `1944-01-20`
* Latest cohort start date: `2019-05-25`
* Earliest cohort end date: `1973-11-24`
* Latest cohort end date: `2019-07-01`

입니다.

대상자별 최초 이벤트만 선택했으므로, 정상적인 결과에서는 코호트 행 수와 고유 대상자 수가 동일해야하고, 동일한 것을 확인했습니다.

```text
Number of cohort rows
=
Number of unique subjects
```

## 코호트 결과 예시

전체 결과를 문서에 모두 기록하지 않고, 실행 결과의 일부 행만 예시로 기록했습니다.

| Cohort definition ID | Subject ID | Cohort start date | Cohort end date |
| -------------------: | ---------: | ----------------- | --------------- |
|                   1  |        3     |   1958-01-29    |  2018-10-29 |
|                   1  |       32     |   1987-06-09    |  2014-12-24 |
|                   1  |       35     |   1997-07-25    |  2018-12-25 |
|                   1  |       61     |   2005-09-15    |  2019-01-06 |
|                   1  |       80     |   1974-10-27    |  2019-04-15 |
|                   1  |       99     |   2000-03-11    |  2019-04-27 |
|                   1  |      115     |   2001-04-15    |  2019-05-05 |
|                   1  |      116     |   1970-03-12    |  2006-07-16 |
|                   1  |      133     |   2019-04-05    |  2019-04-06 |
|                   1  |      135     |   2010-02-01    |  2018-11-14 |
|                   1  |      149     |   1982-12-09    |  2018-10-31 |
|                   1  |      160     |   2006-02-19    |  2019-04-11 |
|                   1  |      163     |   2010-04-25    |  2018-07-10 |
|                   1  |      164     |   2009-02-26    |  2019-06-04 |

## Concept 계층 적용

이번 SQL에서는 Gastrointestinal hemorrhage의 대표 Concept ID `192671`만 사용하지 않고, `concept_ancestor`를 이용해 하위 Concept도 포함했습니다.

```text
Gastrointestinal hemorrhage
→ 대표 Concept
→ 세부 하위 Condition Concepts
```

대표 Concept만 조건에 사용하면 더 구체적인 하위 질환 Concept로 기록된 대상자를 놓칠 수 있습니다.

따라서 대표 Concept와 하위 Concept를 함께 포함하여 GI bleed와 관련된 Condition 이벤트를 조회하였습니다.

## Entry Event

코호트 진입 이벤트는 `condition_occurrence`에 저장된 GI bleed Condition 기록으로 정의하였습니다.

다음 조건을 만족하는 기록만 진입 후보로 사용하였습니다.

```text
condition_concept_id가 GI bleed Concept 목록에 포함
+
condition_start_date가 NULL이 아님
+
condition_start_date가 Observation Period 내부에 존재
```

Condition 기록이 존재한다는 사실만으로 모든 기록을 코호트 진입 이벤트로 사용하지 않고, 대상자가 실제로 관찰 중인 기간에 발생한 기록만 사용하였습니다.

## Observation Period 조건

Condition 발생일은 다음 범위에 포함되어야 했습니다.

```text
observation_period_start_date
<= condition_start_date
<= observation_period_end_date
```

이번 코호트에서는 관찰 기간 바깥의 Condition 이벤트를 제외하여, Index Date가 대상자의 관찰 가능한 기간 안에 존재하도록 하였습니다.

## Index Date

한 대상자가 여러 GI bleed Condition 기록을 가질 수 있으므로, 대상자별로 가장 이른 기록을 선택하였습니다.

```text
여러 GI bleed 이벤트
→ 날짜순 정렬
→ 첫 번째 이벤트 선택
→ 해당 날짜를 Index Date로 사용
```

SQL에서는 `ROW_NUMBER()`를 사용해 대상자별 이벤트 순서를 계산하였습니다.

같은 날짜에 여러 이벤트가 존재할 경우 `condition_occurrence_id`를 추가 정렬 기준으로 사용하여 실행할 때마다 동일한 기록이 선택되도록 하였습니다.

## Cohort Exit Strategy

이번 단순 코호트에서는 Index Date가 속한 Observation Period의 종료일을 `cohort_end_date`로 사용하였습니다.

```text
cohort_start_date
= 최초 GI bleed 발생일

cohort_end_date
= Observation Period 종료일
```

따라서 대상자는 최초 GI bleed 이벤트가 발생한 날부터 해당 Observation Period가 종료될 때까지 코호트에 속하는 것입니다.

이 Exit Strategy는 실습을 위한 단순 규칙이며, 질환이 실제로 Observation Period 종료일까지 지속된다는 임상적 의미는 아닙니다.

## 결과 검증

### 대상자 중복

대상자별 최초 이벤트만 선택했으므로 동일한 `subject_id`가 여러 행에 나타나지 않아야 합니다.

검증 결과:

```text
Duplicate subject count: 0
```

중복 대상자 수가 0으로 조회되는 정상적 결과를 확인했습니다.

### 시작일과 종료일

모든 코호트 행은 다음 조건을 만족해야 합니다.

```text
cohort_start_date <= cohort_end_date
```

이를 검증하기 위해 아래 명령어를 사용했습니다.
```
all(
     simple_cohort$cohort_start_date <=
         simple_cohort$cohort_end_date
)
```
검증 결과:

```text
All cohort start dates are on or before cohort end dates: TRUE
```
검증 결과 조건을 만족하는 정상적 결과가 조회되는 것을 확인했습니다.

## 결론

이번 결과는 OHDSI Cohort 구조를 이해하기 위한 단순 Rule-based Cohort 였습니다.

이번 실습을 통해 OMOP CDM의 코호트는 단순한 환자 목록이 아니라, Concept Set, Entry Event, Index Date, Observation Period 및 Exit Strategy를 규칙으로 정의한 대상자 집합이라는 점을 확인하였습니다.

GI bleed Condition 이벤트를 이용해 대상자별 최초 발생일을 Index Date로 설정하고, 해당 Observation Period의 종료일까지를 코호트 기간으로 구성함으로써 기본적인 Rule-based Cohort 생성 과정을 SQL로 구현하였습니다.

<!-- AUTO-GENERATED-RESULT:START -->

## 자동 생성 결과 테이블

| cohort_definition_id | subject_id | cohort_start_date | cohort_end_date |
| --- | --- | --- | --- |
| 1 | 3 | 1958-01-29 | 2018-10-29 |
| 1 | 32 | 1987-06-09 | 2014-12-24 |
| 1 | 35 | 1997-07-25 | 2018-12-25 |
| 1 | 61 | 2005-09-15 | 2019-01-06 |
| 1 | 80 | 1974-10-27 | 2019-04-15 |
| 1 | 99 | 2000-03-11 | 2019-04-27 |
| 1 | 115 | 2001-04-15 | 2019-05-05 |
| 1 | 116 | 1970-03-12 | 2006-07-16 |
| 1 | 133 | 2019-04-05 | 2019-04-06 |
| 1 | 135 | 2010-02-01 | 2018-11-14 |
| 1 | 149 | 1982-12-09 | 2018-10-31 |
| 1 | 160 | 2006-02-19 | 2019-04-11 |
| 1 | 163 | 2010-04-25 | 2018-07-10 |
| 1 | 164 | 2009-02-26 | 2019-06-04 |
| 1 | 187 | 1985-02-08 | 2018-11-19 |
| 1 | 188 | 2000-02-09 | 2019-05-26 |
| 1 | 202 | 1982-05-16 | 2019-01-19 |
| 1 | 213 | 2003-10-18 | 2018-07-02 |
| 1 | 222 | 1988-03-28 | 2018-12-21 |
| 1 | 224 | 1977-03-03 | 2019-06-25 |

> 전체 479행 중 앞 20행만 표시했습니다.

<!-- AUTO-GENERATED-RESULT:END -->
