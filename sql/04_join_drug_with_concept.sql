-- Join drug exposure records with standardized concept information

SELECT TOP 20
    de.drug_concept_id, -- 표준 약물 concept id
    c.concept_name, -- 약물 concept 명칭
    c.domain_id, -- concept의 domain id
    c.vocabulary_id, -- concept가 속한 vocabulary
    c.concept_class_id, -- 약물 concept의 세부 유형
    c.standard_concept, -- standard concept 여부
    COUNT(*) AS drug_record_count, -- 전체 drug record 수
    COUNT(DISTINCT de.person_id) AS person_count -- 기록에서 고유 대상자 수
FROM @cdm_database_schema.drug_exposure AS de
INNER JOIN @cdm_database_schema.concept AS c
    ON de.drug_concept_id = c.concept_id
WHERE de.drug_concept_id <> 0
GROUP BY
    de.drug_concept_id,
    c.concept_name,
    c.domain_id,
    c.vocabulary_id,
    c.concept_class_id,
    c.standard_concept
ORDER BY
    drug_record_count DESC,
    person_count DESC,
    c.concept_name;