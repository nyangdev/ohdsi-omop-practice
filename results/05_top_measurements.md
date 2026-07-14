# Top Measurement Concepts

## 실습 목적

Eunomia Sample CDM의 `measurement` 테이블을 `concept` 테이블과 조인하여 측정 기록의 수가 상위 20개인 Measurement Concept와 Unit Concept 정보를 확인하였습니다.

또한 Measurement 결과가 숫자형 값, 범주형 Concept 또는 원천 문자열 중 어떤 형태로 저장되어 있는지 확인하고, 결과값이 없는 기록의 수를 함께 집계하였습니다.

## 실행 환경

- Sample CDM: Eunomia
- Database: SQLite
- CDM schema: `main`
- Clinical table: `measurement`
- Vocabulary table: `concept`
- Query: `sql/05_join_measurement_with_concept.sql`
- Execution script: `r/02_run_sql_examples.R`

## 실행 결과

| measurement_concept_id | measurement_concept_name | domain_id | vocabulary_id | standard_concept | unit_concept_id | unit_concept_name | measurement_record_count | person_count | numeric_value_count | concept_value_count | source_value_count | missing_result_count | min_value | avg_value | max_value |
|-----------------------:|--------------------------|-----------|---------------|------------------|----------------:|-------------------|-------------------------:|-------------:|--------------------:|--------------------:|-------------------:|---------------------:|----------:|----------:|----------:|
| 3006322 | Oral temperature | Measurement | LOINC | S | 0 | No matching concept | 12,873 | 2,664 | 0 | 0 | 0 | 12,873 | NA | NA | NA |
| 4024958 | Throat culture | Measurement | SNOMED | S | 0 | No matching concept | 5,507 | 2,336 | 0 | 0 | 0 | 5,507 | NA | NA | NA |
| 4052083 | Measurement of respiratory function | Measurement | SNOMED | S | 0 | No matching concept | 4,088 | 2,072 | 0 | 0 | 0 | 4,088 | NA | NA | NA |
| 3011505 | FEV1/FVC | Measurement | LOINC | S | 0 | No matching concept | 2,320 | 125 | 0 | 0 | 0 | 2,320 | NA | NA | NA |
| 4133840 | Spirometry | Measurement | SNOMED | S | 0 | No matching concept | 2,320 | 125 | 0 | 0 | 0 | 2,320 | NA | NA | NA |
| 40766240 | Are you covered by health insurance or some other kind of health care plan [PhenX] | Measurement | LOINC | S | 0 | No matching concept | 1,046 | 211 | 0 | 0 | 0 | 1,046 | NA | NA | NA |
| 40758406 | HIV status | Measurement | LOINC | S | 0 | No matching concept | 1,046 | 211 | 0 | 0 | 0 | 1,046 | NA | NA | NA |
| 3051031 | History of Hospitalizations+Outpatient visits Narrative | Measurement | LOINC | S | 0 | No matching concept | 1,046 | 211 | 0 | 0 | 0 | 1,046 | NA | NA | NA |
| 46235214 | Sexual orientation | Measurement | LOINC | S | 0 | No matching concept | 1,046 | 211 | 0 | 0 | 0 | 1,046 | NA | NA | NA |
| 3036780 | American house dust mite IgE Ab [Units/volume] in Serum | Measurement | LOINC | S | 0 | No matching concept | 704 | 320 | 0 | 0 | 0 | 704 | NA | NA | NA |
| 3023430 | Cat dander IgE Ab [Units/volume] in Serum | Measurement | LOINC | S | 0 | No matching concept | 704 | 320 | 0 | 0 | 0 | 704 | NA | NA | NA |
| 3005136 | Cladosporium herbarum IgE Ab [Units/volume] in Serum | Measurement | LOINC | S | 0 | No matching concept | 704 | 320 | 0 | 0 | 0 | 704 | NA | NA | NA |
| 3000876 | Codfish IgE Ab [Units/volume] in Serum | Measurement | LOINC | S | 0 | No matching concept | 704 | 320 | 0 | 0 | 0 | 704 | NA | NA | NA |
| 3001247 | Common Ragweed IgE Ab [Units/volume] in Serum | Measurement | LOINC | S | 0 | No matching concept | 704 | 320 | 0 | 0 | 0 | 704 | NA | NA | NA |
| 3001488 | Cow milk IgE Ab [Units/volume] in Serum | Measurement | LOINC | S | 0 | No matching concept | 704 | 320 | 0 | 0 | 0 | 704 | NA | NA | NA |
| 3014599 | Egg white IgE Ab [Units/volume] in Serum | Measurement | LOINC | S | 0 | No matching concept | 704 | 320 | 0 | 0 | 0 | 704 | NA | NA | NA |
| 3020655 | Honey bee IgE Ab [Units/volume] in Serum | Measurement | LOINC | S | 0 | No matching concept | 704 | 320 | 0 | 0 | 0 | 704 | NA | NA | NA |
| 3019406 | Latex IgE Ab [Units/volume] in Serum | Measurement | LOINC | S | 0 | No matching concept | 704 | 320 | 0 | 0 | 0 | 704 | NA | NA | NA |
| 3012494 | Peanut IgE Ab [Units/volume] in Serum | Measurement | LOINC | S | 0 | No matching concept | 704 | 320 | 0 | 0 | 0 | 704 | NA | NA | NA |
| 3021226 | Shrimp IgE Ab [Units/volume] in Serum | Measurement | LOINC | S | 0 | No matching concept | 704 | 320 | 0 | 0 | 0 | 704 | NA | NA | NA |

## Measurement Concept와 Unit Concept

`measurement.measurement_concept_id`는 무엇을 측정하거나 검사했는지를 나타내는 id값입니다.

이번 쿼리에서는 무엇을 측정했는가?에 대한 답을 얻기 위해서 Measurement Concept를 다음 조건으로 `concept` 테이블과 연결하였습니다.

```sql
measurement.measurement_concept_id
=
concept.concept_id
```

또한 어떤 단위로 결과를 표현했는가?에 대한 답을 얻기 위해 `measurement.unit_concept_id`를 다시 `concept.concept_id`와 연결하여 표준 단위 정보를 확인하였습니다.

## Standard Concept와 Vocabulary

조회된 20개 Measurement Concept의 `standard_concept` 값은 모두 `S`였습니다.

이는 해당 Measurement 항목들이 OMOP 표준 분석에 사용할 수 있는 Standard Concept라는 뜻입니다.

Measurement Concept의 Vocabulary로는 주로 `LOINC`와 `SNOMED`가 확인되었는데, 각 Vocabulary가 무엇인지 알아봤을때

- `LOINC`: 검사, 관찰, 설문 및 측정 항목을 표현하는 데 널리 사용되는 Vocabulary
- `SNOMED`: 질환, 임상 소견, 검사 및 기타 임상 개념을 포괄하는 Vocabulary

라는 것을 알 수 있었습니다.

## 전체 기록 수와 고유 대상자 수

`measurement_record_count`는 해당 Measurement Concept와 Unit Concept 조합에 속하는 전체 기록 수입니다.

`person_count`는 해당 Measurement 기록을 하나 이상 가진 고유 대상자 수입니다.

한 대상자는 같은 측정이나 검사를 여러 차례 받을 수 있으므로 모든 결과에서 전체 기록 수가 고유 대상자 수보다 많았습니다.

## Measurement 결과값 저장 방식

OMOP CDM의 Measurement 결과는 여러 방식으로 저장될 수 있습니다.

- `value_as_number`: 숫자형 결과
- `value_as_concept_id`: 표준화된 범주형 결과
- `value_source_value`: 원천 데이터의 결과 문자열

이번 SQL에서는 각각의 값이 존재하는 기록 수를 다음과 같이 계산하였습니다.

- `numeric_value_count`: `value_as_number`가 존재하는 기록 수
- `concept_value_count`: 유효한 `value_as_concept_id`가 존재하는 기록 수
- `source_value_count`: `value_source_value`가 존재하는 기록 수
- `missing_result_count`: 세 결과 컬럼에 모두 값이 없는 기록 수

## 숫자형 결과

상위 20개 Measurement Concept의 `numeric_value_count`는 모두 0이었고  
`value_as_number`에 저장된 숫자형 측정 결과는 존재하지 않았습니다.

계산할 숫자가 없었기 때문에 다음 값도 모두 `NA`로 나타났습니다.

- `min_value`
- `avg_value`
- `max_value`

## 범주형 및 원천 결과

상위 20개 Measurement Concept에서 `concept_value_count`와 `source_value_count`도 모두 0이었습니다.

따라서 다음과 같은 결과도 저장되어 있지 않았습니다.

- Positive 또는 Negative 같은 표준 범주형 Concept
- Normal 또는 Abnormal 같은 결과 Concept
- 원천 데이터에 존재했던 결과 문자열

따라서 이번에 조회된 상위 Measurement 기록은 실제 측정값보다는 측정 또는 검사가 수행되었다는 이벤트 자체를 나타내는 것으로 해석했습니다.

## Unit Concept

모든 결과에서 `unit_concept_id`는 0이었으며, `unit_concept_name`은 `No matching concept`로 확인되었습니다.

이는 분석에 사용할 수 있는 표준 Unit Concept가 연결되지 않았다는 뜻입니다.

또한 실제 숫자형 결과도 존재하지 않았으므로, 이번 데이터에서는 측정값과 단위를 이용한 수치 분석을 수행할 수 없었습니다.

## 결론

이번 실습에 조회한 데이터는 측정값 자체보다는 측정 또는 검사 이벤트가 존재했다는 사실을 나타내는 것으로 이해했습니다.

<!-- AUTO-GENERATED-RESULT:START -->

## 자동 생성 결과 테이블

| measurement_concept_id | measurement_concept_name | domain_id | vocabulary_id | standard_concept | unit_concept_id | unit_concept_name | measurement_record_count | person_count | numeric_value_count | concept_value_count | source_value_count | missing_result_count | min_value | avg_value | max_value |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 3,006,322 | Oral temperature | Measurement | LOINC | S | 0 | No matching concept | 12,873 | 2,664 | 0 | 0 | 0 | 12,873 | NA | NA | NA |
| 4,024,958 | Throat culture | Measurement | SNOMED | S | 0 | No matching concept | 5,507 | 2,336 | 0 | 0 | 0 | 5,507 | NA | NA | NA |
| 4,052,083 | Measurement of respiratory function | Measurement | SNOMED | S | 0 | No matching concept | 4,088 | 2,072 | 0 | 0 | 0 | 4,088 | NA | NA | NA |
| 3,011,505 | FEV1/FVC | Measurement | LOINC | S | 0 | No matching concept | 2,320 | 125 | 0 | 0 | 0 | 2,320 | NA | NA | NA |
| 4,133,840 | Spirometry | Measurement | SNOMED | S | 0 | No matching concept | 2,320 | 125 | 0 | 0 | 0 | 2,320 | NA | NA | NA |
| 40,766,240 | Are you covered by health insurance or some other kind of health care plan [PhenX] | Measurement | LOINC | S | 0 | No matching concept | 1,046 | 211 | 0 | 0 | 0 | 1,046 | NA | NA | NA |
| 40,758,406 | HIV status | Measurement | LOINC | S | 0 | No matching concept | 1,046 | 211 | 0 | 0 | 0 | 1,046 | NA | NA | NA |
| 3,051,031 | History of Hospitalizations+Outpatient visits Narrative | Measurement | LOINC | S | 0 | No matching concept | 1,046 | 211 | 0 | 0 | 0 | 1,046 | NA | NA | NA |
| 46,235,214 | Sexual orientation | Measurement | LOINC | S | 0 | No matching concept | 1,046 | 211 | 0 | 0 | 0 | 1,046 | NA | NA | NA |
| 3,036,780 | American house dust mite IgE Ab [Units/volume] in Serum | Measurement | LOINC | S | 0 | No matching concept | 704 | 320 | 0 | 0 | 0 | 704 | NA | NA | NA |
| 3,023,430 | Cat dander IgE Ab [Units/volume] in Serum | Measurement | LOINC | S | 0 | No matching concept | 704 | 320 | 0 | 0 | 0 | 704 | NA | NA | NA |
| 3,005,136 | Cladosporium herbarum IgE Ab [Units/volume] in Serum | Measurement | LOINC | S | 0 | No matching concept | 704 | 320 | 0 | 0 | 0 | 704 | NA | NA | NA |
| 3,000,876 | Codfish IgE Ab [Units/volume] in Serum | Measurement | LOINC | S | 0 | No matching concept | 704 | 320 | 0 | 0 | 0 | 704 | NA | NA | NA |
| 3,001,247 | Common Ragweed IgE Ab [Units/volume] in Serum | Measurement | LOINC | S | 0 | No matching concept | 704 | 320 | 0 | 0 | 0 | 704 | NA | NA | NA |
| 3,001,488 | Cow milk IgE Ab [Units/volume] in Serum | Measurement | LOINC | S | 0 | No matching concept | 704 | 320 | 0 | 0 | 0 | 704 | NA | NA | NA |
| 3,014,599 | Egg white IgE Ab [Units/volume] in Serum | Measurement | LOINC | S | 0 | No matching concept | 704 | 320 | 0 | 0 | 0 | 704 | NA | NA | NA |
| 3,020,655 | Honey bee IgE Ab [Units/volume] in Serum | Measurement | LOINC | S | 0 | No matching concept | 704 | 320 | 0 | 0 | 0 | 704 | NA | NA | NA |
| 3,019,406 | Latex IgE Ab [Units/volume] in Serum | Measurement | LOINC | S | 0 | No matching concept | 704 | 320 | 0 | 0 | 0 | 704 | NA | NA | NA |
| 3,012,494 | Peanut IgE Ab [Units/volume] in Serum | Measurement | LOINC | S | 0 | No matching concept | 704 | 320 | 0 | 0 | 0 | 704 | NA | NA | NA |
| 3,021,226 | Shrimp IgE Ab [Units/volume] in Serum | Measurement | LOINC | S | 0 | No matching concept | 704 | 320 | 0 | 0 | 0 | 704 | NA | NA | NA |

<!-- AUTO-GENERATED-RESULT:END -->
