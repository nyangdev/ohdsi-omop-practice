-- Summarize measurement records with measurement, unit, and value information

SELECT TOP 20
    m.measurement_concept_id, -- 측정 항목의 concept id
    mc.concept_name AS measurement_concept_name, -- 측정 항목명
    mc.domain_id, -- 측정 concept의 domain
    mc.vocabulary_id, -- 측정 concept의 vocabulary
    mc.standard_concept, -- standard concept 여부
    m.unit_concept_id, -- 단위 concept id
    uc.concept_name AS unit_concept_name, -- 사람이 읽을 수 있는 단위 명칭

    COUNT(*) AS measurement_record_count, -- 현재 측정 기록의 수
    COUNT(DISTINCT m.person_id) AS person_count, -- 고유 대상자 수

    COUNT(m.value_as_number) AS numeric_value_count, -- 숫자값이 있는 기록 수

    COUNT(
        CASE
            WHEN m.value_as_concept_id IS NOT NULL
                 AND m.value_as_concept_id <> 0
            THEN 1
        END
    ) AS concept_value_count, -- 표준화된 범주형 결과 기록 수

    COUNT(
        CASE
            WHEN m.value_source_value IS NOT NULL
            THEN 1
        END
    ) AS source_value_count, -- 원천 결과 문자열이 있는 기록 수

    COUNT(
        CASE
            WHEN m.value_as_number IS NULL
                 AND (
                     m.value_as_concept_id IS NULL
                     OR m.value_as_concept_id = 0
                 )
                 AND m.value_source_value IS NULL
            THEN 1
        END
    ) AS missing_result_count, -- value_as_number, value_as_concept_id, value_source_value 세 곳에 모두 값이 없는 기록 수

    MIN(m.value_as_number) AS min_value,
    AVG(m.value_as_number) AS avg_value,
    MAX(m.value_as_number) AS max_value

FROM @cdm_database_schema.measurement AS m

INNER JOIN @cdm_database_schema.concept AS mc
    ON m.measurement_concept_id = mc.concept_id

LEFT JOIN @cdm_database_schema.concept AS uc
    ON m.unit_concept_id = uc.concept_id

WHERE m.measurement_concept_id <> 0

GROUP BY
    m.measurement_concept_id,
    mc.concept_name,
    mc.domain_id,
    mc.vocabulary_id,
    mc.standard_concept,
    m.unit_concept_id,
    uc.concept_name

ORDER BY
    measurement_record_count DESC,
    person_count DESC,
    mc.concept_name,
    uc.concept_name;