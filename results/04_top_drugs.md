# Top Drug Concepts

## 실습 목적

Eunomia Sample CDM의 `drug_exposure` 테이블을 `concept` 테이블과 조인하여 `drug_concept_id`에 대응하는 표준 약물명과 Vocabulary 정보를 확인하였습니다.

또한 각 Drug Concept에 대해 전체 약물 노출 기록 수와 해당 기록을 가진 고유 대상자 수를 계산하였습니다.

## 실행 환경

- Sample CDM: Eunomia
- Database: SQLite
- CDM schema: `main`
- Clinical table: `drug_exposure`
- Vocabulary table: `concept`
- Query: `sql/04_join_drug_with_concept.sql`
- Execution script: `r/02_run_sql_examples.R`

## 실행 결과

| drug_concept_id | concept_name | domain_id | vocabulary_id | concept_class_id | standard_concept | drug_record_count | person_count |
| --------------: | ------------ | ------ | ---------- | ------------- | :--------------: | -----------: | -----------: |
| 1127433|                                                                                               Acetaminophen 325 MG Oral Tablet| Drug | RxNorm | Clinical Drug| S| 9365 | 2580 |
|40213160|                                                                                                poliovirus vaccine, inactivated| Drug |    CVX |           CVX| S| 7977 | 2140 |
|40213227|                                                     tetanus and diphtheria toxoids, adsorbed, preservative free, for adult use| Drug |    CVX |           CVX| S| 7430 | 2660 |
|19059056|                                                                                                      Aspirin 81 MG Oral Tablet| Drug | RxNorm | Clinical Drug| S| 4380 | 1927 |
| 1713671|                                                                            Amoxicillin 250 MG / Clavulanate 125 MG Oral Tablet| Drug | RxNorm | Clinical Drug| S| 3851 | 2021 |
|40213296|                                                                                              hepatitis A vaccine, adult dosage| Drug |    CVX |           CVX| S| 3211 | 1737 |
| 1127078|                                                                                               Acetaminophen 160 MG Oral Tablet| Drug | RxNorm | Clinical Drug| S| 2158 | 1428 |
|40213260|                                                                                                           zoster vaccine, live| Drug |    CVX |           CVX| S| 2125 | 1140 |
|40229134|              Acetaminophen 21.7 MG/ML / Dextromethorphan Hydrobromide 1 MG/ML / doxylamine succinate 0.417 MG/ML Oral Solution| Drug | RxNorm | Clinical Drug| S| 1993 | 1393 |
|40213306|                                                                                              hepatitis B vaccine, adult dosage| Drug |    CVX |           CVX| S| 1916 | 1560 |
| 1118084|                                                                                                                      celecoxib| Drug | RxNorm |    Ingredient| S| 1844 | 1844 |
|19078461|                                                                                                   Ibuprofen 200 MG Oral Tablet| Drug | RxNorm | Clinical Drug| S| 1767 | 1280 |
|19133873|                                                                                      Penicillin V Potassium 250 MG Oral Tablet| Drug | RxNorm | Clinical Drug| S| 1719 | 1272 |
|40213314|                                                                       Haemophilus influenzae type b vaccine, PRP-OMP conjugate| Drug |    CVX |           CVX| S| 1413 |  555 |
| 1115171|                                                                                             Naproxen sodium 220 MG Oral Tablet| Drug | RxNorm | Clinical Drug| S| 1159 |  947 |
|19006318|                                                                                     Penicillin G 375 MG/ML Injectable Solution| Drug | RxNorm | Clinical Drug| S| 1142 |  831 |
|19133905|                                                                                      Penicillin V Potassium 500 MG Oral Tablet| Drug | RxNorm | Clinical Drug| S| 1087 |  856 |
|19128065| {7 (Inert Ingredients 1 MG Oral Tablet) / 21 (Mestranol 0.05 MG / Norethindrone 1 MG Oral Tablet) } Pack [Norinyl 1+50 28 Day]| Drug | RxNorm |  Branded Pack| S| 1056 |  605 |
| 1124300|                                                                                                                     Diclofenac| Drug | RxNorm |    Ingredient| S|  850 |  850 |
|  920300|                                                                                         Nitrofurantoin 5 MG/ML Oral Suspension| Drug | RxNorm | Clinical Drug| S|  810 |  630 |

## 조인 구조

이번 SQL에서는 다음 조건으로 두 테이블을 연결하였습니다.

```sql
drug_exposure.drug_concept_id
=
concept.concept_id
```

- `concept_name`: 사람이 읽을 수 있는 약물 Concept 명칭
- `domain_id`: Concept가 속한 임상 영역
- `vocabulary_id`: Concept가 정의된 Vocabulary
- `concept_class_id`: Vocabulary 내부의 세부 약물 Concept 유형
- `standard_concept`: Standard Concept 여부

## 결과 해석

### Drug Concept와 표준 약물명

`drug_exposure.drug_concept_id`는 약물 노출 기록에 연결된 표준 Drug Concept ID 입니다.

drug_concept_id는 숫자로 표현되어있어서 해당 ID 값만으로는 어떤 약물을 의미하는지 확인하기 어렵지만, `concept` 테이블과 조인하면 사람이 읽을 수 있는 표준 약물명을 확인할 수 있습니다.

### Domain

`domain_id`는 해당 Concept가 어느 임상 데이터 영역에 속하는지를 나타냅니다.

`drug_exposure`에 저장된 Concept는 일반적으로 `Drug` Domain에 속할 것으로 예상했고, 실제 조회 결과를 통해 이를 확인하였습니다.

### Vocabulary

`vocabulary_id`는 해당 약물 Concept가 어느 Vocabulary에서 정의되었는지를 나타냅니다.

조회 결과를 통해 Eunomia의 약물 노출 기록이 어떤 약물 Vocabulary를 사용하는지 확인하였습니다.

### Concept Class

`concept_class_id`는 해당 약물 Concept가 Vocabulary 내부에서 어떤 유형인지를 세부적으로 나타내는 값입니다.

해당 Concept가 어느 수준의 약물 정보를 표현하는지 이해하는 데 도움이 되는 값이라고 이해했습니다.

### Standard Concept

`standard_concept` 값은 해당 Concept가 OMOP CDM의 표준 분석에 사용되는 Standard Concept인지 나타냅니다.

일반적으로 값의 의미는 다음과 같습니다.

- `S`: 환자의 약물 노출을 표준화하여 표현하는 Standard Concept
- `C`: 여러 하위 Concept를 분류하거나 묶기 위한 Classification Concept
- 빈 값: 원천 코드 보존과 Standard Concept 매핑에 사용되는 Non-standard Concept

`drug_concept_id`에는 일반적으로 Standard Concept가 저장되는 것이 원칙이므로, 조회 결과에서 `S`가 나타나는지 확인하였습니다.

### 전체 기록 수와 고유 대상자 수

`drug_record_count`는 해당 Drug Concept에 대응하는 전체 약물 노출 기록 수입니다.

`person_count`는 해당 Drug Concept의 기록을 하나 이상 가진 고유 대상자 수입니다.

한 대상자가 같은 약물을 여러 번 처방받거나 투여받을 수 있으므로 일반적으로 다음 관계가 나타날 수 있습니다.

```text
drug_record_count >= person_count
```

따라서 전체 약물 노출 기록 수를 해당 약물을 사용한 환자 수와 동일하게 해석해서는 안 됩니다.

## 확인한 사항

이번 실습을 통해 OMOP CDM의 약물 노출 기록이 Standardized Vocabulary와 결합되어 해석된다는 점을 확인했습니다.

<!-- AUTO-GENERATED-RESULT:START -->

## 자동 생성 결과 테이블

| drug_concept_id | concept_name | domain_id | vocabulary_id | concept_class_id | standard_concept | drug_record_count | person_count |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 1,127,433 | Acetaminophen 325 MG Oral Tablet | Drug | RxNorm | Clinical Drug | S | 9,365 | 2,580 |
| 40,213,160 | poliovirus vaccine, inactivated | Drug | CVX | CVX | S | 7,977 | 2,140 |
| 40,213,227 | tetanus and diphtheria toxoids, adsorbed, preservative free, for adult use | Drug | CVX | CVX | S | 7,430 | 2,660 |
| 19,059,056 | Aspirin 81 MG Oral Tablet | Drug | RxNorm | Clinical Drug | S | 4,380 | 1,927 |
| 1,713,671 | Amoxicillin 250 MG / Clavulanate 125 MG Oral Tablet | Drug | RxNorm | Clinical Drug | S | 3,851 | 2,021 |
| 40,213,296 | hepatitis A vaccine, adult dosage | Drug | CVX | CVX | S | 3,211 | 1,737 |
| 1,127,078 | Acetaminophen 160 MG Oral Tablet | Drug | RxNorm | Clinical Drug | S | 2,158 | 1,428 |
| 40,213,260 | zoster vaccine, live | Drug | CVX | CVX | S | 2,125 | 1,140 |
| 40,229,134 | Acetaminophen 21.7 MG/ML / Dextromethorphan Hydrobromide 1 MG/ML / doxylamine succinate 0.417 MG/ML Oral Solution | Drug | RxNorm | Clinical Drug | S | 1,993 | 1,393 |
| 40,213,306 | hepatitis B vaccine, adult dosage | Drug | CVX | CVX | S | 1,916 | 1,560 |
| 1,118,084 | celecoxib | Drug | RxNorm | Ingredient | S | 1,844 | 1,844 |
| 19,078,461 | Ibuprofen 200 MG Oral Tablet | Drug | RxNorm | Clinical Drug | S | 1,767 | 1,280 |
| 19,133,873 | Penicillin V Potassium 250 MG Oral Tablet | Drug | RxNorm | Clinical Drug | S | 1,719 | 1,272 |
| 40,213,314 | Haemophilus influenzae type b vaccine, PRP-OMP conjugate | Drug | CVX | CVX | S | 1,413 | 555 |
| 1,115,171 | Naproxen sodium 220 MG Oral Tablet | Drug | RxNorm | Clinical Drug | S | 1,159 | 947 |
| 19,006,318 | Penicillin G 375 MG/ML Injectable Solution | Drug | RxNorm | Clinical Drug | S | 1,142 | 831 |
| 19,133,905 | Penicillin V Potassium 500 MG Oral Tablet | Drug | RxNorm | Clinical Drug | S | 1,087 | 856 |
| 19,128,065 | {7 (Inert Ingredients 1 MG Oral Tablet) / 21 (Mestranol 0.05 MG / Norethindrone 1 MG Oral Tablet) } Pack [Norinyl 1+50 28 Day] | Drug | RxNorm | Branded Pack | S | 1,056 | 605 |
| 1,124,300 | Diclofenac | Drug | RxNorm | Ingredient | S | 850 | 850 |
| 920,300 | Nitrofurantoin 5 MG/ML Oral Suspension | Drug | RxNorm | Clinical Drug | S | 810 | 630 |

<!-- AUTO-GENERATED-RESULT:END -->
