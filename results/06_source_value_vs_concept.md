# Source Value and Standard Concept Comparison

## 실습 목적

Eunomia Sample CDM의 `condition_occurrence` 테이블에서 원천 진단 값, Source Concept 및 분석용 Condition Concept를 함께 조회하였습니다.

이번 실습은 원천 데이터의 진단 정보가 OMOP CDM에 어떻게 보존되어 있으며, Source Concept와 표준 분석용 Concept가 각 기록에 어떤 형태로 저장되어 있는지 확인하기 위해 수행하였습니다.

## 실행 환경

- Sample CDM: Eunomia
- Database: SQLite
- CDM schema: `main`
- Clinical table: `condition_occurrence`
- Vocabulary table: `concept`
- Query: `sql/06_source_value_vs_concept.sql`
- Execution script: `r/02_run_sql_examples.R`

## 실행 결과

| condition_source_value | condition_source_concept_id | source_concept_code | source_concept_name | source_vocabulary_id | source_standard_concept | condition_concept_id | standard_concept_name | standard_vocabulary_id | target_standard_concept | concept_status | condition_record_count | person_count |
|------------------------|----------------------------:|---------------------|---------------------|----------------------|-------------------------|---------------------:|-----------------------|------------------------|-------------------------|----------------|-----------------------:|-------------:|
| 444814009 | 40481087 | 444814009 | Viral sinusitis | SNOMED | S | 40481087 | Viral sinusitis | SNOMED | S | Source and standard concepts present | 17,268 | 2,686 |
| 195662009 | 4112343 | 195662009 | Acute viral pharyngitis | SNOMED | S | 4112343 | Acute viral pharyngitis | SNOMED | S | Source and standard concepts present | 10,217 | 2,606 |
| 10509002 | 260139 | 10509002 | Acute bronchitis | SNOMED | S | 260139 | Acute bronchitis | SNOMED | S | Source and standard concepts present | 8,184 | 2,543 |
| 65363002 | 372328 | 65363002 | Otitis media | SNOMED | S | 372328 | Otitis media | SNOMED | S | Source and standard concepts present | 3,605 | 2,025 |
| 396275006 | 80180 | 396275006 | Osteoarthritis | SNOMED | S | 80180 | Osteoarthritis | SNOMED | S | Source and standard concepts present | 2,694 | 2,694 |
| 43878008 | 28060 | 43878008 | Streptococcal sore throat | SNOMED | S | 28060 | Streptococcal sore throat | SNOMED | S | Source and standard concepts present | 2,656 | 1,677 |
| 44465007 | 81151 | 44465007 | Sprain of ankle | SNOMED | S | 81151 | Sprain of ankle | SNOMED | S | Source and standard concepts present | 1,915 | 1,357 |
| 62106007 | 378001 | 62106007 | Concussion with no loss of consciousness | SNOMED | S | 378001 | Concussion with no loss of consciousness | SNOMED | S | Source and standard concepts present | 1,013 | 852 |
| 36971009 | 4283893 | 36971009 | Sinusitis | SNOMED | S | 4283893 | Sinusitis | SNOMED | S | Source and standard concepts present | 1,001 | 833 |
| 75498004 | 4294548 | 75498004 | Acute bacterial sinusitis | SNOMED | S | 4294548 | Acute bacterial sinusitis | SNOMED | S | Source and standard concepts present | 939 | 786 |
| 40055000 | 257012 | 40055000 | Chronic sinusitis | SNOMED | S | 257012 | Chronic sinusitis | SNOMED | S | Source and standard concepts present | 825 | 812 |
| 39848009 | 4218389 | 39848009 | Whiplash injury to neck | SNOMED | S | 4218389 | Whiplash injury to neck | SNOMED | S | Source and standard concepts present | 825 | 708 |
| 13200003 | 4027663 | 13200003 | Peptic ulcer | SNOMED | S | 4027663 | Peptic ulcer | SNOMED | S | Source and standard concepts present | 802 | 802 |
| 70704007 | 78272 | 70704007 | Sprain of wrist | SNOMED | S | 78272 | Sprain of wrist | SNOMED | S | Source and standard concepts present | 770 | 677 |
| 65966004 | 4278672 | 65966004 | Fracture of forearm | SNOMED | S | 4278672 | Fracture of forearm | SNOMED | S | Source and standard concepts present | 569 | 510 |
| 283371005 | 4155034 | 283371005 | Laceration of forearm | SNOMED | S | 4155034 | Laceration of forearm | SNOMED | S | Source and standard concepts present | 507 | 459 |
| 284549007 | 4113008 | 284549007 | Laceration of hand | SNOMED | S | 4113008 | Laceration of hand | SNOMED | S | Source and standard concepts present | 500 | 462 |
| 283385000 | 4152936 | 283385000 | Laceration of thigh | SNOMED | S | 4152936 | Laceration of thigh | SNOMED | S | Source and standard concepts present | 499 | 455 |
| 370247008 | 4156265 | 370247008 | Facial laceration | SNOMED | S | 4156265 | Facial laceration | SNOMED | S | Source and standard concepts present | 497 | 459 |
| 263102004 | 4134304 | 263102004 | Fracture subluxation of wrist | SNOMED | S | 4134304 | Fracture subluxation of wrist | SNOMED | S | Source and standard concepts present | 493 | 442 |

## 비교한 세 가지 정보

### Source Value

`condition_source_value`는 원천 데이터에 존재했던 진단 코드 또는 값을 보존합니다.

이 값은 원천 기관에서 실제로 사용된 표현이므로, 기관 내부 코드나 특정 진단 Vocabulary의 코드일 수 있습니다.

Source Value는 표준화된 분석에 직접 사용하는 값이라기보다 다음 용도로 중요합니다.

- 원천 데이터 추적
- ETL 결과 검증
- Vocabulary 매핑 확인
- 매핑되지 않은 코드 조사

### Source Concept

`condition_source_concept_id`는 원천 코드를 OMOP Standardized Vocabularies 안에서 식별한 Concept ID 입니다.

이번 SQL에서는 해당 ID를 `concept.concept_id`와 연결하여 다음 정보를 확인하였습니다.

- Source Concept의 공식 코드
- Source Concept 이름
- Source Vocabulary
- Source Concept의 Standard 여부

Source Concept가 존재하면 원천 코드가 OMOP Vocabulary 안에서 식별 가능한 코드라는 의미입니다.

### Condition Concept

`condition_concept_id`는 해당 Condition 기록을 표준 분석에서 표현하기 위해 저장된 Concept ID 입니다.

이번 SQL에서는 이 값을 다시 `concept` 테이블과 연결하여 다음 정보를 확인하였습니다.

- 분석용 Concept 이름
- 분석용 Concept의 Vocabulary
- Standard Concept 여부

`target_standard_concept`가 `S`라면 해당 Concept가 OMOP의 Standard Concept임을 의미합니다.

## Source Concept와 Standard Concept 비교

Source Concept와 분석용 Concept는 서로 다른 역할을 합니다.

```text
Source Concept
= 원천 코드를 Vocabulary 안에서 식별

Condition Concept
= 표준화된 임상 의미를 분석에 사용
```

일반적인 표준화 흐름은 다음과 같이 이해할 수 있습니다.

```text
원천 진단 값
→ Source Concept
→ Standard Condition Concept
```

## Concept 상태

이번 SQL에서는 Source Concept ID와 Condition Concept ID의 저장 상태를 다음 세 가지로 분류하였다.

### `Source and standard concepts present`

Source Concept ID와 분석용 Condition Concept ID가 모두 존재하는 상태입니다.

```text
condition_source_concept_id != 0
condition_concept_id != 0
```

이는 원천 코드에 대응하는 Source Concept와 분석용 Concept가 모두 임상 이벤트 테이블에 저장되어 있음을 의미합니다.

### `Standard concept only`

Source Concept ID는 0이지만 분석용 Condition Concept ID는 존재하는 상태입니다.

```text
condition_source_concept_id = 0
condition_concept_id != 0
```

이는 OMOP Vocabulary에서 직접 식별되는 Source Concept는 저장되지 않았지만, ETL 과정에서 분석용 Concept가 지정된 상태로 해석할 수 있습니다.

### `No standard concept`

분석용 `condition_concept_id`가 0인 상태입니다.

```text
condition_concept_id = 0
```

이는 해당 원천 Condition 기록에 표준 분석용 Concept가 저장되지 않았음을 의미합니다.

이 경우에도 원천 기록은 삭제되지 않고 `condition_source_value` 등을 통해 보존될 수 있습니다.

## 전체 기록 수와 고유 대상자 수

`condition_record_count`는 동일한 Source Value, Source Concept ID 및 Condition Concept ID 조합에 해당하는 전체 Condition 기록 수입니다.

`person_count`는 해당 조합의 기록을 하나 이상 가진 고유 대상자 수입니다.

한 대상자가 동일한 진단과 관련된 기록을 여러 번 가질 수 있으므로 일반적으로 다음 관계가 나타날 수 있습니다.

```text
condition_record_count >= person_count
```

따라서 전체 기록 수를 해당 진단을 가진 환자 수와 동일하게 해석해서는 안 됩니다.

## 확인한 사항

OMOP CDM은 표준화된 Condition Concept만 저장하는 것이 아니라, 원천 진단 값과 Source Concept 정보도 함께 보존하여 ETL 결과를 추적할 수 있게 한다는 점을 확인하였습니다.
