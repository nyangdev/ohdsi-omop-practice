-- Join condition records with standardized concept information

SELECT TOP 20 -- 상위 20개만 조회
    co.condition_concept_id, -- 표준 질환 Concept ID
    c.concept_name, -- 사람이 읽을 수 있는 질환명
    c.domain_id, -- Concept의 임상 영역
    c.vocabulary_id, -- Concept가 속한 Vocabulary
    c.standard_concept, -- Standard Concept 여부
    COUNT(*) AS condition_record_count, -- 전체 진단 기록 수
    COUNT(DISTINCT co.person_id) AS person_count -- 진단 기록을 가진 고유 대상자 수
FROM @cdm_database_schema.condition_occurrence AS co
INNER JOIN @cdm_database_schema.concept AS c
    ON co.condition_concept_id = c.concept_id
WHERE co.condition_concept_id <> 0
GROUP BY
    co.condition_concept_id,
    c.concept_name,
    c.domain_id,
    c.vocabulary_id,
    c.standard_concept
ORDER BY
    condition_record_count DESC,
    person_count DESC,
    c.concept_name;