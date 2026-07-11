# Connect to the Eunomia Sample
connection_details <- Eunomia::getEunomiaConnectionDetails()

connection <- DatabaseConnector::connect(connection_details)

tryCatch(
  {
    # Retrieve table names from the Eunomia
    table_names <- DatabaseConnector::getTableNames(
      connection = connection,
      databaseSchema = "main"
    )

    # Core OMOP CDM tables
    core_tables <- c(
      "person",
      "observation_period",
      "visit_occurrence",
      "condition_occurrence",
      "drug_exposure",
      "measurement",
      "concept"
    )

    missing_tables <- setdiff(core_tables, table_names)

    if (length(missing_tables) > 0) {
      stop(
        paste(
          "Missing core OMOP CDM tables:",
          paste(missing_tables, collapse = ", ")
        )
      )
    }

    message("Successfully connected to the Eunomia Sample CDM.")
    message("Schema: main")
    message("Number of tables found: ", length(table_names))
    message(
      "Verified core tables: ",
      paste(core_tables, collapse = ", ")
    )
  },
  finally = {
    DatabaseConnector::disconnect(connection)
    message("Database connection closed.")
  }
)
