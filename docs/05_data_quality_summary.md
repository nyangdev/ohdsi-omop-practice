# OMOP CDM Data Quality Summary

## 1. 문서 목적

본 문서는 Eunomia Sample CDM을 대상으로 수행한 기본 Data Quality 검사 결과를 바탕으로 OMOP CDM의 데이터 품질 개념을 정리한 문서입니다.

실습에서는 다음 주요 테이블을 대상으로 총 19개의 기초 검사를 수행하였습니다.

- `person`
- `observation_period`
- `condition_occurrence`
- `drug_exposure`
- `measurement`
- `concept`

검사 영역은 다음과 같습니다.

- Primary Key uniqueness
- Temporal validity
- Person reference integrity
- Standard Concept mapping status
- Concept reference integrity
- Measurement result completeness

---

## 2. 의료 데이터에서 Data Quality가 중요한 이유

의료 데이터는 단순히 테이블에 값이 존재한다고 해서 바로 연구에 사용하는 것이 아니라, 다음 질문을 확인해야 합니다.

```text
각 행을 고유하게 식별할 수 있는가?
임상 이벤트가 실제 대상자와 연결되어 있는가?
이벤트 날짜가 관찰 가능한 기간 안에 있는가?
원천 코드가 Standard Concept로 표현되어 있는가?
분석에 필요한 결과값이 존재하는가?
```

예를 들어 `measurement` 테이블에 검사 이벤트가 존재해도 `value_as_number`, `value_as_concept_id`, `value_source_value`가 모두 비어 있다면 검사 수행 여부는 확인할 수 있지만 검사 결과값 분석은 수행하기 어렵습니다.

따라서 데이터 품질은 다음 두 질문을 모두 포함합니다.

```text
데이터가 OMOP CDM 구조를 준수하는가?
+
현재 연구 질문에 사용할 수 있는가?
```

---

## 3. Data Quality는 하나의 절대 점수가 아니다

데이터 품질은 단순히 좋은 데이터와 나쁜 데이터로 구분하기 어렵습니다.

동일한 데이터도 연구 목적에 따라 활용 가능성이 달라질 수 있습니다.

예를 들어 결과값이 없는 Measurement 기록은 다음 연구에는 사용할 수 있습니다.

```text
특정 검사가 수행되었는가?
검사 기록을 가진 대상자가 몇 명인가?
검사 이용 빈도는 어떠한가?
```

반면 다음 연구에는 사용하기 어렵습니다.

```text
검사 수치가 정상 범위에 있는가?
시간에 따라 검사값이 어떻게 변했는가?
특정 검사 결과를 Cohort 진입 조건으로 사용할 수 있는가?
```

따라서 Data Quality 결과는 단순한 오류 목록이 아니라, 데이터가 특정 분석 목적에 적합한지를 판단하기 위한 근거로 사용해야 합니다.

특정 연구 목적에 적합한 데이터인가? 라는 질문이 가장 중요합니다.

---

## 4. OMOP CDM Data Quality의 주요 관점

이번 실습에서는 데이터 품질을 다음 관점으로 구분했습니다.

| Quality area          | 주요 질문                          |
| --------------------- | ------------------------------ |
| Conformance           | 데이터가 CDM의 구조와 규칙을 준수하는가?       |
| Completeness          | 분석에 필요한 데이터가 충분히 존재하는가?        |
| Plausibility          | 값과 시간 관계가 현실적이고 논리적인가?         |
| Referential integrity | 테이블 간 참조 관계가 유지되는가?            |
| Standardization       | 임상 이벤트가 분석 가능한 Concept로 표현되는가? |
| Fitness for use       | 특정 분석 목적에 실제로 활용할 수 있는가?       |

---

## 5. Conformance

Conformance는 데이터가 OMOP CDM에서 정의한 구조, 데이터 타입, 필수값 및 관계 규칙을 준수하는지를 확인하는 관점입니다.

주요 확인 대상은 다음과 같습니다.

```text
필수 테이블과 컬럼 존재 여부
Primary Key uniqueness
Required field의 NULL 여부
허용된 값과 데이터 타입
테이블 간 참조 관계
Concept Domain 적합성
```

### Primary Key의 역할

Primary Key는 각 테이블의 행을 고유하게 식별합니다.

같은 대상자가 같은 날짜에 동일한 약물이나 검사를 여러 번 가질 수는 있지만, 각 이벤트 행은 서로 다른 Primary Key를 가져야 합니다.

```text
동일한 임상 의미의 이벤트가 여러 건 존재
→ 가능

동일한 Primary Key를 가진 여러 행 존재
→ 구조적 검토 필요
```

---

## 6. Completeness

Completeness는 분석에 필요한 데이터가 얼마나 채워져 있는지를 확인하는 관점입니다.

다음과 같은 형태로 확인할 수 있습니다.

### Field completeness

특정 컬럼에 값이 존재하는가?

```text
measurement.value_as_number
measurement.value_as_concept_id
measurement.value_source_value
```

### Record completeness

특정 임상 이벤트 자체가 데이터에 존재하는가?

```text
Condition 기록 존재 여부
Drug Exposure 기록 존재 여부
Measurement 기록 존재 여부
```

### Temporal completeness

대상자의 관찰 가능한 기간과 임상 기록이 충분히 연결되는가?

```text
Observation Period 안에 임상 이벤트가 존재하는가?
Index Date 이전 기록을 충분히 관찰할 수 있는가?
```

---

## 7. Plausibility

Plausibility는 데이터가 논리적이고 현실적으로 가능한지를 확인하는 관점입니다.

주요 예시는 다음과 같습니다.

```text
시작일이 종료일보다 늦지 않은가?
출생일 이전에 임상 이벤트가 존재하지 않는가?
약물 노출 시작일이 종료일보다 늦지 않은가?
Observation Period 밖에 임상 이벤트가 존재하지 않는가?
비현실적인 검사 수치가 존재하지 않는가?
```

---

## 8. Referential Integrity

Referential Integrity는 한 테이블의 식별자가 참조 대상 테이블에 실제로 존재하는지를 확인합니다.

### Person reference

임상 이벤트는 실제 대상자와 연결되어야 합니다.

```text
condition_occurrence.person_id
→ person.person_id

drug_exposure.person_id
→ person.person_id

measurement.person_id
→ person.person_id
```

임상 이벤트의 `person_id`가 `person` 테이블에 존재하지 않으면 해당 기록이 누구의 기록인지 확인할 수 없습니다.

### Concept reference

임상 이벤트에 저장된 Concept ID는 `concept` 테이블에서 조회할 수 있어야 합니다.

```text
condition_occurrence.condition_concept_id
→ concept.concept_id

drug_exposure.drug_concept_id
→ concept.concept_id

measurement.measurement_concept_id
→ concept.concept_id
```

Concept ID가 `0`은 아니지만 `concept` 테이블에서 찾을 수 없다면 Vocabulary 참조 무결성 문제를 검토해야 합니다.

---

## 9. Standardization

Standardization은 원천 임상 데이터가 OMOP Standardized Vocabulary를 이용해 공통된 임상 의미로 표현되어 있는지를 확인하는 관점입니다.

이번 검사에서는 다음 주요 Concept ID가 `0`인지 확인하였습니다.

```text
condition_concept_id
drug_concept_id
measurement_concept_id
```

Concept ID `0`은 사용할 수 있는 Concept가 연결되지 않은 상태를 나타냅니다.

다만 다음 두 상태는 구분해야 합니다.

```text
concept_id = 0
→ 사용할 수 있는 Standard Concept가 연결되지 않음

concept_id <> 0
→ 어떤 Concept ID는 저장되어 있음
```

Concept ID가 `0`이 아니라는 사실만으로 가장 적절한 Standard Concept에 매핑되었다고 판단할 수는 없습니다.

실제 매핑 품질을 확인하려면 다음 내용까지 검토해야 합니다.

- Source Value
- Source Concept
- Standard Concept
- `concept_relationship`
- `Maps to` 관계
- Domain 적합성
- Concept 유효 기간
- 임상 전문가 검토

따라서 이번 검사는 Standardization의 존재 여부를 일부 확인한 것이며, 임상적 매핑 정확성을 검증한 것은 아닙니다.

---

## 10. Observation Period와 Data Quality

Observation Period는 대상자의 의료 기록을 관찰할 수 있다고 판단하는 기간을 나타냅니다.

다음 관계를 만족하는 임상 이벤트는 대상자가 관찰 중인 기간에 발생한 것으로 해석할 수 있습니다.

```text
observation_period_start_date
<= event_date
<= observation_period_end_date
```

---

## 11. 이번 DQ 검사 구조

`sql/09_dq_checks.sql`에서는 총 19개의 검사를 수행하였습니다.

| Check range | Quality area                    |
| ----------- | ------------------------------- |
| DQ001–DQ005 | Primary Key uniqueness          |
| DQ006–DQ009 | Temporal validity               |
| DQ010–DQ012 | Person reference integrity      |
| DQ013–DQ015 | Standard Concept mapping status |
| DQ016–DQ018 | Concept reference integrity     |
| DQ019       | Measurement result completeness |

각 검사 결과는 다음 컬럼으로 반환하였습니다.

```text
check_id
check_category
check_name
finding_count
```

```text
finding_count > 0
→ 추가 검토가 필요한 기록 존재
```

---

## 12. Eunomia 검사 결과

이번 검사에서 확인한 주요 결과는 다음과 같습니다.

| Quality area                       | Result         |
| ---------------------------------- | -------------- |
| Person Primary Key                 | 중복 없음          |
| Observation Period Primary Key     | 중복 없음          |
| Condition Primary Key              | 중복 없음          |
| Drug Exposure Primary Key          | 초과 중복 행 4,384건 |
| Measurement Primary Key            | 초과 중복 행 2,183건 |
| Observation Period 날짜 역전           | 없음             |
| Observation Period 밖 Condition     | 85건            |
| Observation Period 밖 Drug Exposure | 80건            |
| Observation Period 밖 Measurement   | 4건             |
| Person 참조 누락                       | 없음             |
| 주요 임상 Concept ID `0`               | 없음             |
| Concept 참조 누락                      | 없음             |
| 결과값 없는 Measurement                 | 44,053건        |

상세 결과는 다음 문서에 기록하였습니다.

```text
results/08_dq_check_results.md
```
---

## 13. ETL 과정과 Data Quality

OMOP CDM Data Quality 문제는 원천 데이터와 ETL 과정 모두에서 발생할 수 있습니다.   
원천 데이터에서 발생한 품질 문제는 통제 불가능할 수 있지만 ETL 과정에서 발생한 품질 문제는 우리가 통제 가능한 부분일 수 있습니다.

```text
Source Data Quality
+
ETL Logic Quality
+
Vocabulary Mapping Quality
+
CDM Structural Quality
```

DQ 결과를 해결할 때는 최종 CDM 테이블만 보지 않고 원천 데이터와 ETL 설계를 함께 추적해야 합니다.

---

## 14. Data Quality Continuum

Data Quality는 CDM 적재가 끝난 후 한 번만 검사하는 작업이 아닙니다.

다음 단계 전체에서 지속적으로 확인해야 합니다.

```text
원천 데이터 프로파일링
→ ETL 설계 검증
→ CDM 적재 중 검증
→ CDM 구조 및 Vocabulary 검사
→ Cohort 생성 전 검사
→ 분석 결과 검토
```

### 원천 데이터 단계

다음 내용을 확인합니다.

- 원천 테이블과 컬럼 구조
- 코드 분포
- NULL 비율
- 날짜 범위
- 중복 여부
- 데이터 타입
- 원천 Vocabulary

White Rabbit과 같은 프로파일링 도구는 원천 데이터의 구조와 값 분포를 이해하는 데 활용할 수 있습니다.

### ETL 설계 단계

다음 내용을 결정합니다.

- Source table과 CDM table 매핑
- Primary Key 생성 규칙
- Person 식별자 변환
- 날짜 변환
- Observation Period 생성
- Vocabulary mapping
- Source Value 보존

### CDM 적재 단계

다음 내용을 확인합니다.

- Record count 변화
- 필수값 누락
- 중복 적재
- 참조 무결성
- Concept ID 변환
- 날짜 범위

### 분석 준비 단계

다음 내용을 확인합니다.

- Cohort Concept Set 적합성
- Index Date 이전 관찰 기간
- Outcome 데이터 존재 여부
- Measurement 결과 완전성
- 연구에 필요한 Domain의 데이터 범위

---

## 15. Data Quality 결과와 Cohort의 관계

Data Quality 결과는 Cohort 크기와 대상자 선정에 직접적인 영향을 줄 수 있습니다.

이번 GI bleed Cohort에서는 다음 조건을 사용하였습니다.

```text
Condition 발생일이 Observation Period 내부
```

따라서 Observation Period 밖에 존재하는 Condition 85건은 해당 코호트의 진입 이벤트로 사용할 수 없습니다.

또한 임상 이벤트 ID가 중복되어 있다면 다음 문제가 발생할 수 있습니다.

```text
이벤트 수 과대 계산
동일 이벤트 반복 선택
포함 기준 충족 횟수 왜곡
```

Measurement 결과값이 없으면 다음 Inclusion Criteria를 구현하기 어렵습니다.

```text
검사 수치가 특정 기준 이상
검사 결과가 특정 범주
Index Date 이전 검사값 존재
```

따라서 Cohort Definition을 작성하기 전에 필요한 Domain과 컬럼의 품질을 확인해야 합니다.

```text
Cohort Logic이 SQL로 실행됨
≠
연구에 적합한 Cohort가 생성됨
```

---

## 16. DQ 결과를 해석할 때 주의할 점

Data Quality 검사 결과가 0이라는 사실도 제한적으로 해석해야 합니다.

Condition Event에 `0`이 아닌 Concept ID가 모든 컬럼에 저장되어 있을때,

아래 조건들을 보장해주지는 않습니다.

- 올바른 Standard Concept인가
- 올바른 Domain인가
- Source Value와 정확히 매핑되었는가
- 임상적으로 적절한 Concept인가
- 현재 유효한 Concept인가

반대로 `finding_count > 0`이라고 해서 모든 기록을 삭제해야 하는 것도 아닙니다.

```text
Measurement 결과값 없음
→ 검사 수행 사실 분석에는 사용 가능

Concept ID 0
→ 원천 이벤트 보존을 위해 존재할 수 있음

Observation Period 밖 이벤트
→ 원천 및 ETL 규칙 추가 검토 필요
```

따라서 DQ 결과는 기록 제거 기준이 아니라 조사와 의사결정을 위한 근거로 사용해야 합니다.