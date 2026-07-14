# Top Condition Concepts

## 실습 목적

Eunomia Sample CDM의 `condition_occurrence` 테이블을 `concept` 테이블과 조인하여, `condition_concept_id`에 대응하는 표준 질환명과 Vocabulary 정보를 확인하였습니다.

또한 각 Condition Concept에 대해 전체 진단 기록 수와 해당 기록을 가진 고유 대상자 수를 계산하였습니다.

## 실행 환경

- Sample CDM: Eunomia
- Database: SQLite
- CDM schema: `main`
- Clinical table: `condition_occurrence`
- Vocabulary table: `concept`
- Query: `sql/03_join_condition_with_concept.sql`
- Execution script: `r/02_run_sql_examples.R`

## 실행 결과

| condition_concept_id | concept_name | domain_id | vocabulary_id | standard_concept | condition_record_count | person_count |
| -------------------: | ------------ | ------ | ---------- | :--------------: | -----------: | -----------: |
|             40481087 |                          Viral sinusitis| Condition|        SNOMED|S                  |17268         |2686
|              4112343 |                  Acute viral pharyngitis| Condition|        SNOMED|S                  |10217         |2606
|               260139 |                         Acute bronchitis| Condition|        SNOMED|S                  | 8184         |2543
|               372328 |                             Otitis media| Condition|        SNOMED|S                  | 3605         |2025
|                80180 |                           Osteoarthritis| Condition|        SNOMED|S                  | 2694         |2694
|                28060 |                Streptococcal sore throat| Condition|        SNOMED|S                  | 2656         |1677
|                81151 |                          Sprain of ankle| Condition|        SNOMED|S                  | 1915         |1357
|               378001 | Concussion with no loss of consciousness| Condition|        SNOMED|S                  | 1013         | 852
|              4283893 |                                Sinusitis| Condition|        SNOMED|S                  | 1001         | 833
|              4294548 |                Acute bacterial sinusitis| Condition|        SNOMED|S                  |  939         | 786
|               257012 |                        Chronic sinusitis| Condition|        SNOMED|S                  |  825         | 812
|              4218389 |                  Whiplash injury to neck| Condition|        SNOMED|S                  |  825         | 708
|              4027663 |                             Peptic ulcer| Condition|        SNOMED|S                  |  802         | 802
|                78272 |                          Sprain of wrist| Condition|        SNOMED|S                  |  770         | 677
|              4278672 |                      Fracture of forearm| Condition|        SNOMED|S                  |  569         | 510
|              4155034 |                    Laceration of forearm| Condition|        SNOMED|S                  |  507         | 459
|              4113008 |                       Laceration of hand| Condition|        SNOMED|S                  |  500         | 462
|              4152936 |                      Laceration of thigh| Condition|        SNOMED|S                  |  499         | 455
|              4156265 |                        Facial laceration| Condition|        SNOMED|S                  |  497         | 459
|              4134304 |            Fracture subluxation of wrist| Condition|        SNOMED|S                  |  493         | 442

`condition_occurrence`에는 질환명이 직접 저장되는 것이 아니라 `condition_concept_id`가 저장됩니다.

이번 SQL에서는 다음 조건으로 두 테이블을 연결하였습니다.

```sql
condition_occurrence.condition_concept_id
=
concept.concept_id
```

- `concept_name`: 사람이 읽을 수 있는 Concept 명칭
- `domain_id`: Concept가 속한 임상 영역 id
- `vocabulary_id`: Concept가 속한 Vocabulary
- `standard_concept`: Standard Concept 여부

## 결과 해석

### Condition Concept와 표준 질환명

`condition_occurrence.condition_concept_id`는 진단 및 질환 기록에 연결된 표준 Concept ID입니다.  
Concept ID는 숫자값으로 나타나있기에 ID만으로는 질환의 의미를 알 수 없지만, `concept` 테이블과 조인하면 해당 Concept의 표준 명칭을 확인할 수 있습니다.

### Domain

조회된 Condition Concept의 `domain_id`를 통해 각 Concept가 어떤 임상 영역에 속하는지 확인하였습니다.

### Vocabulary

`vocabulary_id`는 해당 Concept가 어떤 Vocabulary에서 정의되었는지를 확인할 수 있게하는 id 값입니다.

조회된 데이터가 어떤 표준 Vocabulary에서 정의된 Concept를 사용하는 값인지 확인하였습니다.

### Standard Concept

`standard_concept` 값은 해당 Concept가 OMOP CDM의 표준 분석에 사용되는 Standard Concept인지 나타냅니다.

일반적으로 값의 의미는 다음과 같습니다.

- `S`: Standard Concept
- `C`: Classification Concept
- 빈 값: Non-standard Concept

`condition_concept_id`에는 표준화된 Concept가 저장되는 것이 원칙이므로, 조회 결과에서 모두 `S`가 나타나는지 확인하였습니다.

### 전체 기록 수와 고유 대상자 수

`condition_record_count`는 해당 Concept에 대응하는 전체 진단 기록 수입니다.

`person_count`는 해당 Concept의 진단 기록을 하나 이상 가진 고유 대상자 수입니다.

한 대상자가 동일한 질환에 대해 여러 개의 기록을 가질 수 있으므로 일반적으로 다음 관계가 나타날 수 있습니다.

```text
condition_record_count >= person_count
```

따라서 전체 기록 수를 해당 질환을 가진 환자 수로 해석해서는 안 됩니다.

## 확인한 사항

이번 실습을 통해 OMOP CDM의 임상 이벤트는 Standardized Vocabulary와 결합되어 해석된다는 점을 확인했습니다.

<!-- AUTO-GENERATED-RESULT:START -->

## 자동 생성 결과 테이블

| condition_concept_id | concept_name | domain_id | vocabulary_id | standard_concept | condition_record_count | person_count |
| --- | --- | --- | --- | --- | --- | --- |
| 40,481,087 | Viral sinusitis | Condition | SNOMED | S | 17,268 | 2,686 |
| 4,112,343 | Acute viral pharyngitis | Condition | SNOMED | S | 10,217 | 2,606 |
| 260,139 | Acute bronchitis | Condition | SNOMED | S | 8,184 | 2,543 |
| 372,328 | Otitis media | Condition | SNOMED | S | 3,605 | 2,025 |
| 80,180 | Osteoarthritis | Condition | SNOMED | S | 2,694 | 2,694 |
| 28,060 | Streptococcal sore throat | Condition | SNOMED | S | 2,656 | 1,677 |
| 81,151 | Sprain of ankle | Condition | SNOMED | S | 1,915 | 1,357 |
| 378,001 | Concussion with no loss of consciousness | Condition | SNOMED | S | 1,013 | 852 |
| 4,283,893 | Sinusitis | Condition | SNOMED | S | 1,001 | 833 |
| 4,294,548 | Acute bacterial sinusitis | Condition | SNOMED | S | 939 | 786 |
| 257,012 | Chronic sinusitis | Condition | SNOMED | S | 825 | 812 |
| 4,218,389 | Whiplash injury to neck | Condition | SNOMED | S | 825 | 708 |
| 4,027,663 | Peptic ulcer | Condition | SNOMED | S | 802 | 802 |
| 78,272 | Sprain of wrist | Condition | SNOMED | S | 770 | 677 |
| 4,278,672 | Fracture of forearm | Condition | SNOMED | S | 569 | 510 |
| 4,155,034 | Laceration of forearm | Condition | SNOMED | S | 507 | 459 |
| 4,113,008 | Laceration of hand | Condition | SNOMED | S | 500 | 462 |
| 4,152,936 | Laceration of thigh | Condition | SNOMED | S | 499 | 455 |
| 4,156,265 | Facial laceration | Condition | SNOMED | S | 497 | 459 |
| 4,134,304 | Fracture subluxation of wrist | Condition | SNOMED | S | 493 | 442 |

<!-- AUTO-GENERATED-RESULT:END -->
