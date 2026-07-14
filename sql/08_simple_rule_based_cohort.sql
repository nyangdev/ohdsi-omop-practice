-- Create a simple GI bleed cohort using the first eligible condition event

WITH gi_bleed_concepts AS (
    SELECT
        192671 AS concept_id -- 위장관 출혈 concept id

    UNION

    SELECT
        ca.descendant_concept_id AS concept_id -- 하위 concept id 조회
    FROM @cdm_database_schema.concept_ancestor AS ca
    WHERE ca.ancestor_concept_id = 192671
),

-- 후보 이벤트 추출
candidate_events AS (
    SELECT
        co.person_id,
        co.condition_occurrence_id,
        co.condition_concept_id,
        co.condition_start_date,
        op.observation_period_start_date,
        op.observation_period_end_date,

        -- 대상자별 이벤트 순서 지정
        ROW_NUMBER() OVER (
            PARTITION BY co.person_id
            ORDER BY
                co.condition_start_date,
                co.condition_occurrence_id
        ) AS event_rank

    FROM @cdm_database_schema.condition_occurrence AS co

    INNER JOIN gi_bleed_concepts AS gbc
        ON co.condition_concept_id = gbc.concept_id

    -- condition 기록이 대상자의 observation period 안에서 발생했는지 확인
    INNER JOIN @cdm_database_schema.observation_period AS op
        ON co.person_id = op.person_id
       AND co.condition_start_date
           BETWEEN op.observation_period_start_date
               AND op.observation_period_end_date

    WHERE co.condition_start_date IS NOT NULL
)

SELECT
    1 AS cohort_definition_id, -- 코호트 식별 임시 id
    person_id AS subject_id, -- 대상자 식별 컬럼
    condition_start_date AS cohort_start_date, --코호트 시작일 index date
    observation_period_end_date AS cohort_end_date
FROM candidate_events
WHERE event_rank = 1 -- 각 대상자의 최초 이벤트만 선택
ORDER BY subject_id;