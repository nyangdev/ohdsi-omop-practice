# Read, render, translate, and execute an SQL file

connection_details <- Eunomia::getEunomiaConnectionDetails()

connection <- DatabaseConnector::connect(connection_details)

run_sql_file <- function(connection, sql_file) {
  
  if (!file.exists(sql_file)) {
    stop(
      paste(
        "SQL file not found:",
        sql_file
      )
    )
  }
  
  sql <- SqlRender::readSql(sql_file)
  
  rendered_sql <- SqlRender::render(
    sql = sql,
    cdm_database_schema = "main"
  )
  
  translated_sql <- SqlRender::translate(
    sql = rendered_sql,
    targetDialect = "sqlite"
  )
  
  result <- DatabaseConnector::querySql(
    connection = connection,
    sql = translated_sql
  )
  
  return(result)
}


tryCatch(
  {
    # Count records in selected core OMOP CDM tables
    core_table_counts <- run_sql_file(
      connection = connection,
      sql_file = file.path(
        "sql",
        "01_core_table_counts.sql"
      )
    )
    
    message("Core OMOP CDM table count query completed.")
    print(core_table_counts)
    
    
    # Compare records with unique persons
    person_event_summary <- run_sql_file(
      connection = connection,
      sql_file = file.path(
        "sql",
        "02_person_event_summary.sql"
      )
    )
    
    message("Person and clinical event summary query completed.")
    print(person_event_summary)
    
    # Join condition records with standardized concept information
    top_conditions <- run_sql_file(
      connection = connection,
      sql_file = file.path(
        "sql",
        "03_join_condition_with_concept.sql"
      )
    )
    
    message("Condition and concept join query completed.")
    print(top_conditions)
    
    # Join drug exposure records with standardized concept information
    top_drugs <- run_sql_file(
      connection = connection,
      sql_file = file.path(
        "sql",
        "04_join_drug_with_concept.sql"
      )
    )
    
    message("Drug exposure and concept join query completed.")
    print(top_drugs)
    
    # Summarize measurement records with concept and unit information
    top_measurements <- run_sql_file(
      connection = connection,
      sql_file = file.path(
        "sql",
        "05_join_measurement_with_concept.sql"
      )
    )
    
    message("Measurement and unit concept join query completed.")
    print(top_measurements)
    
    # Compare source condition values with source and standard concepts
    source_value_comparison <- run_sql_file(
      connection = connection,
      sql_file = file.path(
        "sql",
        "06_source_value_vs_concept.sql"
      )
    )
    
    message("Source value and concept comparison query completed.")
    print(source_value_comparison)
    
  },
  finally = {
    DatabaseConnector::disconnect(connection)
    message("Database connection closed.")
  }
)