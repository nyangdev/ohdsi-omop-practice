# Concept and Standardized Vocabulary Summary

## 1. 문서 설명

본 문서는 Eunomia Sample CDM을 이용한 실습을 바탕으로 OMOP CDM의 Concept와 Standardized Vocabulary 구조를 정리한 문서입니다.

---

## 2. OMOP Concept란 무엇인가

OMOP CDM에서 Concept는 질환, 약물, 검사, 시술 등 의료 데이터에 등장하는 임상적 의미를 표현하는 표준화된 단위입니다.

각 Concept는 `concept` 테이블의 한 행으로 저장됩니다.

`concept` 테이블의 주요 컬럼은 다음과 같습니다.

| Column             | Meaning                                     |
| ------------------ | ------------------------------------------- |
| `concept_id`       | OMOP 내부에서 사용하는 고유 식별자                       |
| `concept_name`     | 사람이 읽을 수 있는 Concept 명칭                      |
| `domain_id`        | Concept가 속한 임상 영역                           |
| `vocabulary_id`    | Concept의 원천 Vocabulary                      |
| `concept_class_id` | Vocabulary 내부의 세부 분류                        |
| `standard_concept` | Standard, Classification 또는 Non-standard 여부 |
| `concept_code`     | 원래 Vocabulary에서 사용하는 코드                     |
| `valid_start_date` | Concept 유효 시작일                              |
| `valid_end_date`   | Concept 유효 종료일                              |
| `invalid_reason`   | Concept가 더 이상 유효하지 않은 경우의 상태                |

임상 이벤트 테이블에는 일반적으로 Concept 이름을 직접 저장하지 않고 숫자형으로  `concept_id`를 저장합니다.

예를 들어 Condition 기록은 다음과 같이 연결하여 명칭을 확인합니다.

```text
condition_occurrence.condition_concept_id
→ concept.concept_id
→ concept_name 확인
```

따라서 임상 이벤트의 의미를 확인하려면 이벤트 테이블과 `concept` 테이블을 연결해야 합니다.

---

## 3. Concept ID와 Source Value의 차이

OMOP CDM에서는 원천 데이터의 값을 보존하면서 동시에 표준 Concept ID를 저장합니다.

Condition을 예로 들면 다음 컬럼을 확인할 수 있습니다.

```text
condition_source_value
condition_source_concept_id
condition_concept_id
```

각 컬럼의 역할은 다음과 같습니다.

### `condition_source_value`

원천 시스템에서 실제로 사용한 코드 또는 문자열입니다.

예를 들어 원천 시스템에 ICD 코드, 병원 자체 코드 또는 진단명이 저장되어 있었다면 해당 값이 보존될 수 있습니다.

```text
원천 시스템 코드
→ condition_source_value
```

Source Value를 보존하는 이유는 다음과 같습니다.

- 원천 데이터와의 추적 가능성
- ETL 결과 검증
- 매핑 오류 분석
- 원천 코드별 분포 확인
- 데이터 lineage 유지

### `condition_source_concept_id`

원천 코드를 OMOP Vocabulary의 Concept로 표현한 값입니다.

Source Concept는 원천 코드의 의미를 OMOP Vocabulary 안에서 식별하기 위해 사용합니다.

Source Concept는 일반적으로 분석에서 직접 사용하는 Standard Concept와 다를 수 있습니다.

### `condition_concept_id`

분석에 사용하는 Standard Concept ID입니다.

여러 원천 Vocabulary의 코드가 동일하거나 유사한 임상 의미를 표현한다면 공통된 Standard Concept로 변환될 수 있습니다.

```text
기관 A 원천 코드
기관 B 원천 코드
기관 C 원천 코드
→ 동일한 Standard Concept
```

이 구조를 통해 서로 다른 데이터 소스의 임상 이벤트를 공통된 Concept ID를 기준으로 분석할 수 있습니다.

---

## 4. Vocabulary

`vocabulary_id`는 해당 Concept가 어느 Vocabulary에서 정의되었는지를 나타냅니다.

---

## 5. Domain

`domain_id`는 Concept가 어느 OMOP CDM 임상 영역에서 사용되는지를 나타냅니다.

주요 예시는 다음과 같습니다.

| Domain      | 관련 임상 영역   |
| ----------- | ---------- |
| Condition   | 질환 및 진단    |
| Drug        | 약물         |
| Measurement | 검사 및 측정    |
| Procedure   | 시술         |
| Observation | 기타 임상 관찰   |
| Visit       | 의료 이용 및 방문 |

Domain은 단순한 분류값이 아니라 Standard Concept가 어느 임상 이벤트 테이블에 저장되는지를 이해하는 데 중요합니다.

예를 들어 Condition Domain의 Standard Concept는 일반적으로 다음 컬럼에 저장됩니다.

```text
condition_occurrence.condition_concept_id
```

Measurement Domain의 Standard Concept는 다음 컬럼에서 사용됩니다.

```text
measurement.measurement_concept_id
```

Concept 이름이 유사하더라도 Domain이 다르면 임상적 역할과 저장 위치가 다를 수 있습니다.

따라서 Concept 검색 시 이름만 확인하지 않고 `domain_id`를 함께 확인해야 합니다.

---

## 6. Concept Class

`concept_class_id`는 Vocabulary 내부에서 Concept가 어떤 세부 유형에 속하는지를 나타냅니다.

---

## 7. Standard Concept

`standard_concept` 컬럼은 Concept가 OMOP 분석에서 어떤 역할을 하는지를 나타냅니다.

주요 값은 다음과 같습니다.

| Value  | Meaning                |
| ------ | ---------------------- |
| `S`    | Standard Concept       |
| `C`    | Classification Concept |
| `NULL` | Non-standard Concept   |

### Standard Concept: `S`

Standard Concept는 임상 이벤트를 공통된 의미로 표현할 때 사용합니다.

예를 들어 다음 컬럼에는 일반적으로 Standard Concept가 저장된다.

```text
condition_concept_id
drug_concept_id
measurement_concept_id
```

Standard Concept를 사용하면 서로 다른 원천 Vocabulary에서 수집된 데이터를 동일한 기준으로 조회할 수 있습니다.

### Classification Concept: `C`

Classification Concept는 여러 하위 Concept를 분류하거나 그룹화하기 위한 Concept입니다.

일반적으로 개별 임상 이벤트를 직접 표현하기보다 계층 및 분류 구조에서 활용됩니다.

```text
상위 분류 Concept
→ 여러 세부 하위 Concept
```

### Non-standard Concept: `NULL`

`standard_concept` 값이 `NULL`이면 Standard 또는 Classification으로 지정되지 않은 Non-standard Concept일 수 있습니다.

Non-standard Concept는 원천 Vocabulary의 코드를 표현하거나 Standard Concept로 연결하기 위한 Source Concept로 사용될 수 있습니다.

OMOP에서는 원천 코드의 의미와 추적 가능성을 보존하기 위해 Non-standard Concept도 함께 관리합니다.

---

## 8. Concept ID 0

OMOP CDM에서 Concept ID `0`은 사용할 수 있는 Concept가 연결되지 않았음을 표현할 때 사용됩니다.

Eunomia Measurement 실습에서는 다음 결과가 확인되었습니다.

```text
unit_concept_id = 0
```

이를 `concept` 테이블과 연결하면 다음 명칭이 나타날 수 있습니다.

```text
No matching concept
```

Concept ID `0`은 다음과 같이 해석해야 합니다.

```text
표준 Concept로 표현할 수 있는 값이 없음
또는
ETL 과정에서 매핑되지 않음
```

---

## 9. Condition Concept 실습

`condition_occurrence` 테이블의 Condition 기록을 `concept` 테이블과 연결하여 질환별 Record 수와 대상자 수를 확인하였습니다.

사용한 연결 조건은 다음과 같습니다.

```text
condition_occurrence.condition_concept_id
=
concept.concept_id
```

이 실습을 통해 다음 사항을 확인하였습니다.

- 숫자형 Condition Concept ID를 임상 질환명으로 해석할 수 있다.
- Condition별 전체 Record 수와 고유 Person 수는 다르다.
- 동일 대상자가 같은 Condition 기록을 여러 번 가질 수 있다.
- `domain_id`, `vocabulary_id`, `standard_concept`를 함께 확인해야 한다.

```text
Condition record count
≠
Condition patient count
```

Condition Concept를 기준으로 집계할 때는 이벤트 수와 대상자 수를 구분해야 한다는 것을 학습했습니다.

---

## 10. Drug Concept 실습

`drug_exposure.drug_concept_id`를 `concept.concept_id`와 연결하여 Drug Exposure 기록의 의미를 확인하였습니다.

실습에서는 Drug Concept별로 다음 정보를 확인하였습니다.

- Concept name
- Vocabulary
- Concept Class
- Standard Concept 여부
- Record 수
- 고유 대상자 수

Drug Concept는 같은 약물을 서로 다른 concept_class_id 수준으로 표현할 수 있습니다.

```text
Ingredient
→ 성분 중심

Clinical Drug
→ 성분 + 강도 + 제형

Branded Pack
→ 브랜드와 포장 구성
```

따라서 Drug Concept를 비교할 때는 Concept name뿐 아니라 `concept_class_id`를 함께 확인해야 합니다.

---

## 11. Measurement Concept 실습

Measurement에서는 다음 두 정보를 구분해야 합니다.

```text
무엇을 측정했는가?
vs.
측정 결과가 무엇인가?
```

무엇을 측정했는지는 다음 컬럼으로 표현합니다.

```text
measurement_concept_id
```

측정 결과는 다음 컬럼 중 하나 이상에 저장될 수 있습니다.

```text
value_as_number
value_as_concept_id
value_source_value
```

결과 단위는 다음 컬럼에 저장됩니다.

```text
unit_concept_id
```

Eunomia 실습 결과에서는 Measurement Event는 존재했지만, 많은 기록에서 다음 값이 확인되지 않았습니다.

- Numeric result
- Categorical result
- Source result
- Standard Unit Concept

상위 20가지 Measurement Concept 조회 결과에서는 다음 상태가 반복적으로 나타났습니다.

```text
measurement_concept_id 존재
unit_concept_id = 0
value_as_number 없음
value_as_concept_id 없음
value_source_value 없음
```

이는 아래와 같은 상황을 의미합니다.

```text
검사가 수행됐는지 분석
→ 가능

검사 결과가 얼마였는지 분석
→ 제한적
```

---

## 12. Source Concept와 Standard Concept 비교

`sql/06_source_value_vs_concept.sql`에서는 Condition 기록에 저장된 Source Value, Source Concept 및 Standard Concept를 함께 조회하였습니다.

조회 흐름은 다음과 같습니다.

```text
condition_source_value
→ 원천 코드 또는 값

condition_source_concept_id
→ 원천 Vocabulary Concept

condition_concept_id
→ 분석용 Standard Concept
```

---

## 13. Concept Hierarchy

OMOP Vocabulary는 Concept 사이의 계층 관계를 제공합니다.

계층 탐색에는 주로 다음 테이블을 사용할 수 있습니다.

```text
concept_relationship
concept_ancestor
```

`concept_ancestor`는 상위 Concept와 모든 하위 Descendant Concept의 관계를 조회하는 데 사용하는 테이블입니다.

이번 GI bleed Cohort 실습에서는 대표 Concept ID와 그 Descendant를 함께 사용하였습니다.

```text
Gastrointestinal hemorrhage
→ 대표 Concept
→ concept_ancestor를 이용한 하위 Concept 포함
```

대표 Concept 하나만 사용하면 더 세부적인 하위 질환 Concept로 기록된 이벤트를 놓칠 수 있습니다.

따라서 Cohort Definition에서는 대표 Concept뿐 아니라 Descendant 포함 여부도 고려해야 한다는 것을 학습했습니다.

---

## 14. OMOP Vocabulary를 사용하는 이유

의료 데이터에서는 같은 질환, 약물 또는 검사가 기관과 시스템에 따라 다른 코드로 표현될 수 있습니다.

```text
다른 기관
다른 코드 체계
다른 원천 값
→ 동일한 임상 의미일 수 있음
```

OMOP Standardized Vocabulary는 이러한 차이를 Standard Concept로 통합하여 동일한 분석 로직을 여러 데이터 소스에 적용할 수 있도록 합니다.

전체 흐름은 다음과 같다고 학습했습니다.

```text
Source Value
→ Source Concept
→ Standard Concept
→ 공통 분석
```

---

## 15. 결론

OMOP CDM의 Standardized Vocabulary는 서로 다른 원천 데이터의 임상적 의미를 공통된 Concept로 표현하기 위한 핵심 구성 요소입니다.

임상 이벤트 테이블에는 Standard Concept ID가 저장되며, `concept` 테이블을 통해 숫자형 ID를 질환, 약물 및 검사 의미로 해석할 수 있습니다.

Source Value와 Source Concept는 원천 데이터의 의미와 추적 가능성을 보존하고, Standard Concept는 여러 데이터 소스에서 공통 분석을 가능하게 합니다.

Domain은 Concept가 사용되는 임상 영역을 나타내며, Vocabulary는 Concept가 정의된 코드 체계를 나타냅니다.  
Concept Class는 Concept의 세부 유형을 구체적으로 구분합니다.

이번 Eunomia 실습을 통해 OMOP CDM은 단순히 동일한 테이블 구조를 사용하는 모델이 아니라 다음 요소를 결합한 표준화 체계라는 점을 학습했습니다.

```text
공통 테이블 구조
+ Standardized Vocabulary
+ Source Value 보존
+ Concept Mapping
+ Concept Hierarchy
+ Cohort Definition
```
