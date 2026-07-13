-- Compare source condition values with source and standard concepts

WITH condition_summary AS (
    SELECT
        co.condition_source_value, -- 원천 진단 코드 또는 값
        co.condition_source_concept_id, -- 원천 코드를 나타내는 concept id
        co.condition_concept_id, -- 원천 코드가 매핑된 standard concept id
        COUNT(*) AS condition_record_count, -- 전체 기록 수
        COUNT(DISTINCT co.person_id) AS person_count -- 고유 대상자 수
    FROM @cdm_database_schema.condition_occurrence AS co -- 진단, 질병 정보를 저장하는 테이블
    WHERE co.condition_source_value IS NOT NULL
    GROUP BY
        co.condition_source_value,
        co.condition_source_concept_id,
        co.condition_concept_id
)

SELECT TOP 20
    cs.condition_source_value,
    cs.condition_source_concept_id,
    sc.concept_code AS source_concept_code,
    sc.concept_name AS source_concept_name,
    sc.vocabulary_id AS source_vocabulary_id,
    sc.standard_concept AS source_standard_concept,
    cs.condition_concept_id,
    tc.concept_name AS standard_concept_name,
    tc.vocabulary_id AS standard_vocabulary_id,
    tc.standard_concept AS target_standard_concept,

    CASE
        WHEN cs.condition_concept_id = 0
            THEN 'No standard concept'
        WHEN cs.condition_source_concept_id = 0
            THEN 'Standard concept only'
        ELSE 'Source and standard concepts present'
    END AS concept_status,

    cs.condition_record_count,
    cs.person_count

FROM condition_summary AS cs

LEFT JOIN @cdm_database_schema.concept AS sc
    ON cs.condition_source_concept_id = sc.concept_id

LEFT JOIN @cdm_database_schema.concept AS tc
    ON cs.condition_concept_id = tc.concept_id

ORDER BY
    cs.condition_record_count DESC,
    cs.person_count DESC,
    cs.condition_source_value;