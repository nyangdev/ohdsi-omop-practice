-- Run basic data quality checks on selected OMOP CDM tables

WITH dq_results AS (
    
-- DQ001: Duplicate person_id
SELECT
    'DQ001' AS check_id,
    'Uniqueness' AS check_category,
    'Duplicate person_id' AS check_name,
    COALESCE(SUM(duplicate_count - 1), 0) AS finding_count
FROM (
    SELECT
        person_id,
        COUNT(*) AS duplicate_count
    FROM @cdm_database_schema.person
    GROUP BY person_id
    HAVING COUNT(*) > 1
) AS duplicate_person

UNION ALL

-- DQ002: Duplicate observation_period_id
SELECT
    'DQ002',
    'Uniqueness',
    'Duplicate observation_period_id',
    COALESCE(SUM(duplicate_count - 1), 0)
FROM (
    SELECT
        observation_period_id,
        COUNT(*) AS duplicate_count
    FROM @cdm_database_schema.observation_period
    GROUP BY observation_period_id
    HAVING COUNT(*) > 1
) AS duplicate_observation_period

UNION ALL

-- DQ003: Duplicate condition_occurrence_id
SELECT
    'DQ003',
    'Uniqueness',
    'Duplicate condition_occurrence_id',
    COALESCE(SUM(duplicate_count - 1), 0)
FROM (
    SELECT
        condition_occurrence_id,
        COUNT(*) AS duplicate_count
    FROM @cdm_database_schema.condition_occurrence
    GROUP BY condition_occurrence_id
    HAVING COUNT(*) > 1
) AS duplicate_condition

UNION ALL

-- DQ004: Duplicate drug_exposure_id
SELECT
    'DQ004',
    'Uniqueness',
    'Duplicate drug_exposure_id',
    COALESCE(SUM(duplicate_count - 1), 0)
FROM (
    SELECT
        drug_exposure_id,
        COUNT(*) AS duplicate_count
    FROM @cdm_database_schema.drug_exposure
    GROUP BY drug_exposure_id
    HAVING COUNT(*) > 1
) AS duplicate_drug

UNION ALL

-- DQ005: Duplicate measurement_id
SELECT
    'DQ005',
    'Uniqueness',
    'Duplicate measurement_id',
    COALESCE(SUM(duplicate_count - 1), 0)
FROM (
    SELECT
        measurement_id,
        COUNT(*) AS duplicate_count
    FROM @cdm_database_schema.measurement
    GROUP BY measurement_id
    HAVING COUNT(*) > 1
) AS duplicate_measurement

UNION ALL

-- DQ006: Invalid observation period date order
SELECT
    'DQ006',
    'Temporal validity',
    'Observation period start date after end date',
    COUNT(*)
FROM @cdm_database_schema.observation_period
WHERE observation_period_start_date >
      observation_period_end_date

UNION ALL

-- DQ007: Condition event outside every observation period
SELECT
    'DQ007',
    'Temporal validity',
    'Condition start date outside observation period',
    COUNT(*)
FROM @cdm_database_schema.condition_occurrence AS co
LEFT JOIN @cdm_database_schema.observation_period AS op
    ON op.person_id = co.person_id
   AND co.condition_start_date
       BETWEEN op.observation_period_start_date
           AND op.observation_period_end_date
WHERE co.condition_start_date IS NOT NULL
  AND op.observation_period_id IS NULL

UNION ALL

-- DQ008: Drug exposure outside every observation period
SELECT
    'DQ008',
    'Temporal validity',
    'Drug exposure start date outside observation period',
    COUNT(*)
FROM @cdm_database_schema.drug_exposure AS de
LEFT JOIN @cdm_database_schema.observation_period AS op
    ON op.person_id = de.person_id
   AND de.drug_exposure_start_date
       BETWEEN op.observation_period_start_date
           AND op.observation_period_end_date
WHERE de.drug_exposure_start_date IS NOT NULL
  AND op.observation_period_id IS NULL

UNION ALL

-- DQ009: Measurement outside every observation period
SELECT
    'DQ009',
    'Temporal validity',
    'Measurement date outside observation period',
    COUNT(*)
FROM @cdm_database_schema.measurement AS m
LEFT JOIN @cdm_database_schema.observation_period AS op
    ON op.person_id = m.person_id
   AND m.measurement_date
       BETWEEN op.observation_period_start_date
           AND op.observation_period_end_date
WHERE m.measurement_date IS NOT NULL
  AND op.observation_period_id IS NULL

UNION ALL

-- DQ010: Condition record without a valid person
SELECT
    'DQ010',
    'Referential integrity',
    'Condition records with missing person reference',
    COUNT(*)
FROM @cdm_database_schema.condition_occurrence AS co
LEFT JOIN @cdm_database_schema.person AS p
    ON co.person_id = p.person_id
WHERE p.person_id IS NULL

UNION ALL

-- DQ011: Drug record without a valid person
SELECT
    'DQ011',
    'Referential integrity',
    'Drug exposure records with missing person reference',
    COUNT(*)
FROM @cdm_database_schema.drug_exposure AS de
LEFT JOIN @cdm_database_schema.person AS p
    ON de.person_id = p.person_id
WHERE p.person_id IS NULL

UNION ALL

-- DQ012: Measurement record without a valid person
SELECT
    'DQ012',
    'Referential integrity',
    'Measurement records with missing person reference',
    COUNT(*)
FROM @cdm_database_schema.measurement AS m
LEFT JOIN @cdm_database_schema.person AS p
    ON m.person_id = p.person_id
WHERE p.person_id IS NULL

UNION ALL

-- DQ013: Condition record without a mapped standard concept
SELECT
    'DQ013',
    'Standardization',
    'Condition records with condition_concept_id 0',
    COUNT(*)
FROM @cdm_database_schema.condition_occurrence
WHERE condition_concept_id = 0

UNION ALL

-- DQ014: Drug record without a mapped standard concept
SELECT
    'DQ014',
    'Standardization',
    'Drug exposure records with drug_concept_id 0',
    COUNT(*)
FROM @cdm_database_schema.drug_exposure
WHERE drug_concept_id = 0

UNION ALL

-- DQ015: Measurement record without a mapped standard concept
SELECT
    'DQ015',
    'Standardization',
    'Measurement records with measurement_concept_id 0',
    COUNT(*)
FROM @cdm_database_schema.measurement
WHERE measurement_concept_id = 0

UNION ALL

-- DQ016: Condition concept ID missing from the concept table
SELECT
    'DQ016',
    'Referential integrity',
    'Condition concept IDs not found in concept table',
    COUNT(*)
FROM @cdm_database_schema.condition_occurrence AS co
LEFT JOIN @cdm_database_schema.concept AS c
    ON co.condition_concept_id = c.concept_id
WHERE co.condition_concept_id <> 0
  AND c.concept_id IS NULL

UNION ALL

-- DQ017: Drug concept ID missing from the concept table
SELECT
    'DQ017',
    'Referential integrity',
    'Drug concept IDs not found in concept table',
    COUNT(*)
FROM @cdm_database_schema.drug_exposure AS de
LEFT JOIN @cdm_database_schema.concept AS c
    ON de.drug_concept_id = c.concept_id
WHERE de.drug_concept_id <> 0
  AND c.concept_id IS NULL

UNION ALL

-- DQ018: Measurement concept ID missing from the concept table
SELECT
    'DQ018',
    'Referential integrity',
    'Measurement concept IDs not found in concept table',
    COUNT(*)
FROM @cdm_database_schema.measurement AS m
LEFT JOIN @cdm_database_schema.concept AS c
    ON m.measurement_concept_id = c.concept_id
WHERE m.measurement_concept_id <> 0
  AND c.concept_id IS NULL

UNION ALL

-- DQ019: Measurement record without any result value
SELECT
    'DQ019',
    'Completeness',
    'Measurement records without any result value',
    COUNT(*)
FROM @cdm_database_schema.measurement AS m
WHERE m.value_as_number IS NULL
  AND (
      m.value_as_concept_id IS NULL
      OR m.value_as_concept_id = 0
  )
  AND m.value_source_value IS NULL

)

SELECT
check_id,
check_category,
check_name,
finding_count
FROM dq_results
ORDER BY check_id;
