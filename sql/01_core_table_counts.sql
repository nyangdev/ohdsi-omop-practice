-- 핵심 테이블 건수 카운팅으로 확인

SELECT
    'person' AS table_name, -- 환자의 기본 정보 저장
    COUNT(*) AS row_count
FROM @cdm_database_schema.person

UNION ALL

SELECT
    'observation_period' AS table_name, -- 각 대상자의 데이터 관찰 가능 기간 저장
    COUNT(*) AS row_count
FROM @cdm_database_schema.observation_period

UNION ALL

SELECT
    'visit_occurrence' AS table_name, -- 입원, 외래, 응급실 등 의료기관 방문 정보 저장
    COUNT(*) AS row_count
FROM @cdm_database_schema.visit_occurrence

UNION ALL

SELECT
    'condition_occurrence' AS table_name, -- 질환, 진단 또는 임상 상태 기록 저장
    COUNT(*) AS row_count
FROM @cdm_database_schema.condition_occurrence

UNION ALL

SELECT
    'drug_exposure' AS table_name, -- 환자의 약물 노출 또는 처방 기록 저장
    COUNT(*) AS row_count
FROM @cdm_database_schema.drug_exposure

UNION ALL

SELECT
    'measurement' AS table_name, -- 검사 및 측정 결과 저장
    COUNT(*) AS row_count
FROM @cdm_database_schema.measurement

ORDER BY table_name;