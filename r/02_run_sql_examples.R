# Run a parameterized SQL query against the Eunomia Sample CDM

connection_details <- Eunomia::getEunomiaConnectionDetails()

connection <- DatabaseConnector::connect(connection_details)

tryCatch(
  {
    # Define the SQL file path
    sql_file <- file.path(
      "sql",
      "01_core_table_counts.sql"
    )

    # Validate that the SQL file exists
    if (!file.exists(sql_file)) {
      stop(
        paste(
          "SQL file not found:",
          sql_file
        )
      )
    }

    # Read the parameterized SQL file
    sql <- SqlRender::readSql(sql_file)

    # Replace the CDM schema parameter
    rendered_sql <- SqlRender::render(
      sql = sql,
      cdm_database_schema = "main"
    )

    # Translate the SQL to the SQLite dialect
    translated_sql <- SqlRender::translate(
      sql = rendered_sql,
      targetDialect = "sqlite"
    )

    # Execute the query and retrieve the result
    core_table_counts <- DatabaseConnector::querySql(
      connection = connection,
      sql = translated_sql
    )

    message("Core OMOP CDM table count query completed.")
    print(core_table_counts)
  },
  finally = {
    DatabaseConnector::disconnect(connection)
    message("Database connection closed.")
  }
)