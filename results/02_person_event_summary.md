# Person and Clinical Event Summary

## 실습 목적

Eunomia Sample CDM의 주요 대상자 및 임상 이벤트 테이블을 대상으로 전체 레코드 수와 고유 대상자 수를 비교하였습니다.

## 실행 환경

- Sample CDM: Eunomia
- Database: SQLite
- CDM schema: `main`
- Query: `sql/02_person_event_summary.sql`
- Execution script: `r/02_run_sql_examples.R`

## 실행 결과

| Table                  | Record count | Person count |
| ---------------------- | -----------: | ------------------: |
| `condition_occurrence` |       65332 |              2694 |
| `drug_exposure`        |       67707 |              2694 |
| `measurement`          |       44053 |              2686 |
| `observation_period`   |       5343 |              5343 |
| `person`               |       2694 |              2694 |
| `visit_occurrence`     |       1037 |              890 |

## 결과 해석

### `person`

`person` 테이블은 연구 대상자별 기본 정보를 저장합니다.

`person_id`는 대상자를 고유하게 식별하는 기본 키이므로, 정상적인 데이터에서는 전체 레코드 수와 고유 대상자 수가 동일해야합니다.

이번 결과에서도 두 값이 동일한지 확인하였고, 동일한 것을 확인할 수 있었습니다.

### `observation_period`

`observation_period` 테이블은 각 대상자의 데이터가 연구에 활용 가능한 관찰 기간을 저장하는 테이블입니다.  

`observation_period`의 행 수는 환자 수가 아니라 저장된 전체 관찰 기간의 수를 의미합니다.  

한 대상자가 보험 탈퇴 후 재가입 등의 이유로 둘 이상의 관찰 기간을 가질 수 있으므로, 전체 레코드 수가 고유 대상자 수보다 많거나 같을 수 있습니다.  

Eunomia Sample CDM에서는 전체 레코드 수와 고유 대상자 수가 동일한 것을 확인할 수 있었고, 이는 연구 대상자들이 각 하나의 관찰 기간만을 가진 것을 의미한다고 보았습니다.

### `visit_occurrence`

`visit_occurrence` 테이블은 입원, 외래, 응급실 등 의료기관 방문 기록을 저장합니다.

한 대상자는 여러 번 의료기관을 방문할 수 있으므로, 전체 방문 기록 수는 방문 기록을 가진 고유 대상자 수보다 많거나 같을 수 있습니다.

### `condition_occurrence`

`condition_occurrence` 테이블은 진단, 질환 및 임상 상태 기록을 저장합니다.

한 대상자는 서로 다른 질환을 진단받거나 같은 질환에 대해 여러 기록을 가질 수 있습니다. 따라서 전체 진단 기록 수는 진단 기록을 가진 고유 대상자 수보다 많을 수 있습니다.

### `drug_exposure`

`drug_exposure` 테이블은 처방, 조제 및 기타 약물 노출 기록을 저장합니다.

한 대상자는 여러 약물을 사용하거나 동일한 약물을 반복 처방받을 수 있으므로, 전체 약물 노출 기록 수는 약물 기록을 가진 고유 대상자 수보다 많을 수 있습니다.

### `measurement`

`measurement` 테이블은 검사와 측정 결과를 저장합니다.

한 대상자는 혈액검사, 혈압, 체중 등 여러 측정 기록을 가질 수 있으며, 동일한 측정 항목도 여러 시점에 반복될 수 있습니다. 따라서 전체 측정 기록 수는 측정 기록을 가진 고유 대상자 수보다 많을 수 있습니다.