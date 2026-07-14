-- Search valid standard Condition concepts related to diabetes
-- 당뇨병 대상자를 찾을 때 어떤 condition_concept_id를 사용할 것인가?
-- concept 테이블에서 diabetes라는 단어가 포함된 유효한 Standard Condition Concept 후보 찾기

SELECT TOP 50
    c.concept_id,
    c.concept_name,
    c.domain_id,
    c.vocabulary_id,
    c.concept_class_id,
    c.standard_concept,
    c.concept_code,
    c.valid_start_date,
    c.valid_end_date
FROM @cdm_database_schema.concept AS c
WHERE LOWER(c.concept_name) LIKE '%diabetes%'
  AND c.domain_id = 'Condition'
  AND c.standard_concept = 'S'
  AND c.invalid_reason IS NULL
ORDER BY
    c.concept_name,
    c.concept_id;