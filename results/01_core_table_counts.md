# Core OMOP CDM Table Counts

## 실습 목적

Eunomia Sample CDM에 포함된 주요 임상 테이블의 전체 레코드 수를 확인하였습니다.

## 실행 환경

- Sample CDM: Eunomia
- Database: SQLite
- CDM schema: `main`
- Query: `sql/01_core_table_counts.sql`
- Execution script: `r/02_run_sql_examples.R`

## 실행 결과

| table_name | row_count |
|---|---:|
| `condition_occurrence` | 65332 |
| `drug_exposure` | 67707 |
| `measurement` | 44053 |
| `observation_period` | 5343 |
| `person` | 2694 |
| `visit_occurrence` | 1037 |

## 결과 해석

`person` 테이블은 환자의 기본 정보를 저장하는 테이블입니다.  
각 행은 각 연구 대상을 나타냅니다.  

`observation_period` 테이블은 각 대상자의 데이터가 연구에 활용 가능한 관찰 기간을 나타냅니다.  
대상자에 따라 하나 이상의 관찰 기간을 가질 수 있으므로, 행 수가 항상 `person` 테이블의 행 수와 일치하는 것은 아닙니다.  

`visit_occurrence`, `condition_occurrence`, `drug_exposure`, `measurement` 테이블은 한 대상자가 여러 기록을 가질 수 있는 이벤트 기반 테이블입니다.  
따라서 이 테이블들의 전체 행 수는 고유 환자 수가 아니라 방문, 진단, 약물 노출, 검사 및 측정 기록의 전체 건수를 의미합니다.

이번 결과를 통해 Eunomia Sample CDM에 주요 임상 영역의 샘플 데이터가 실제로 존재하며, 이후 연구 대상자와 임상 이벤트 간의 관계를 조회할 수 있음을 확인하였습니다.  

## 확인한 사항

- Eunomia Sample CDM의 `main` 스키마에 정상적으로 접근하였습니다.
- 주요 OMOP CDM 임상 테이블의 레코드 수를 조회하였습니다.
- 대상자 중심 테이블과 이벤트 기반 테이블의 데이터 단위 차이를 확인하였습니다.