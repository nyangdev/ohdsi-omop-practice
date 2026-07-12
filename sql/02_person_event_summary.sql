-- Compare total records with unique persons in selected core OMOP CDM tables

SELECT
    'person' AS table_name,
    COUNT(*) AS record_count,
    COUNT(DISTINCT person_id) AS person_count
FROM @cdm_database_schema.person

UNION ALL

SELECT
    'observation_period' AS table_name,
    COUNT(*) AS record_count,
    COUNT(DISTINCT person_id) AS person_count
FROM @cdm_database_schema.observation_period

UNION ALL

SELECT
    'visit_occurrence' AS table_name,
    COUNT(*) AS record_count,
    COUNT(DISTINCT person_id) AS person_count
FROM @cdm_database_schema.visit_occurrence

UNION ALL

SELECT
    'condition_occurrence' AS table_name,
    COUNT(*) AS record_count,
    COUNT(DISTINCT person_id) AS person_count
FROM @cdm_database_schema.condition_occurrence

UNION ALL

SELECT
    'drug_exposure' AS table_name,
    COUNT(*) AS record_count,
    COUNT(DISTINCT person_id) AS person_count
FROM @cdm_database_schema.drug_exposure

UNION ALL

SELECT
    'measurement' AS table_name,
    COUNT(*) AS record_count,
    COUNT(DISTINCT person_id) AS person_count
FROM @cdm_database_schema.measurement

ORDER BY table_name;