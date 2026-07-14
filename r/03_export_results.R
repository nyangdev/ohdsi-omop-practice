# Export OMOP CDM query results to generated sections in Markdown files

query_script <- file.path(
  "r",
  "02_run_sql_examples.R"
)

if (!file.exists(query_script)) {
  stop(
    paste(
      "Query execution script was not found:",
      query_script
    )
  )
}

# Define the R objects and Markdown files to export

export_config <- list(
  list(
    object_name = "core_table_counts",
    output_file = file.path(
      "results",
      "01_core_table_counts.md"
    ),
    max_rows = 50
  ),
  list(
    object_name = "person_event_summary",
    output_file = file.path(
      "results",
      "02_person_event_summary.md"
    ),
    max_rows = 50
  ),
  list(
    object_name = "top_conditions",
    output_file = file.path(
      "results",
      "03_top_conditions.md"
    ),
    max_rows = 20
  ),
  list(
    object_name = "top_drugs",
    output_file = file.path(
      "results",
      "04_top_drugs.md"
    ),
    max_rows = 20
  ),
  list(
    object_name = "top_measurements",
    output_file = file.path(
      "results",
      "05_top_measurements.md"
    ),
    max_rows = 20
  ),
  list(
    object_name = "source_value_comparison",
    output_file = file.path(
      "results",
      "06_source_value_vs_concept.md"
    ),
    max_rows = 20
  ),
  list(
    object_name = "simple_cohort",
    output_file = file.path(
      "results",
      "07_simple_cohort_result.md"
    ),
    max_rows = 20
  ),
  list(
    object_name = "dq_check_results",
    output_file = file.path(
      "results",
      "08_dq_check_results.md"
    ),
    max_rows = 50
  )
)

# Convert a single value into a Markdown-safe character value

format_markdown_value <- function(value) {
  if (length(value) == 0) {
    return("NA")
  }
  
  if (is.na(value)[1]) {
    return("NA")
  }
  
  if (inherits(value, "Date")) {
    formatted_value <- format(
      value,
      "%Y-%m-%d"
    )
  } else if (
    inherits(value, "POSIXct") ||
    inherits(value, "POSIXt")
  ) {
    formatted_value <- format(
      value,
      "%Y-%m-%d %H:%M:%S"
    )
  } else if (is.numeric(value)) {
    formatted_value <- format(
      value,
      trim = TRUE,
      scientific = FALSE,
      big.mark = ","
    )
  } else {
    formatted_value <- as.character(value)
  }
  
  # Escape Markdown table separators without using a regular expression
  
  formatted_value <- gsub(
    pattern = "|",
    replacement = "\\|",
    x = formatted_value,
    fixed = TRUE
  )
  
  # Replace line breaks with HTML line breaks
  
  formatted_value <- gsub(
    pattern = "\r\n",
    replacement = "<br>",
    x = formatted_value,
    fixed = TRUE
  )
  
  formatted_value <- gsub(
    pattern = "\n",
    replacement = "<br>",
    x = formatted_value,
    fixed = TRUE
  )
  
  formatted_value <- gsub(
    pattern = "\r",
    replacement = "<br>",
    x = formatted_value,
    fixed = TRUE
  )
  
  formatted_value
}

# Convert a data frame into a Markdown table

data_frame_to_markdown <- function(
    data,
    max_rows = 20
) {
  if (!is.data.frame(data)) {
    stop("The export object must be a data.frame.")
  }
  
  if (ncol(data) == 0) {
    return("> No columns were returned.")
  }
  
  if (nrow(data) == 0) {
    return("> The query returned no rows.")
  }
  
  displayed_data <- utils::head(
    data,
    max_rows
  )
  
  header_values <- vapply(
    names(displayed_data),
    format_markdown_value,
    character(1)
  )
  
  header_line <- paste0(
    "| ",
    paste(
      header_values,
      collapse = " | "
    ),
    " |"
  )
  
  separator_line <- paste0(
    "| ",
    paste(
      rep(
        "---",
        ncol(displayed_data)
      ),
      collapse = " | "
    ),
    " |"
  )
  
  row_lines <- vapply(
    seq_len(nrow(displayed_data)),
    function(row_index) {
      row_values <- vapply(
        displayed_data,
        function(column) {
          format_markdown_value(
            column[[row_index]]
          )
        },
        character(1)
      )
      

      paste0(
        "| ",
        paste(
          row_values,
          collapse = " | "
        ),
        " |"
      )
    },
    character(1)

    
  )
  
  markdown_lines <- c(
    header_line,
    separator_line,
    row_lines
  )
  
  if (nrow(data) > max_rows) {
    markdown_lines <- c(
      markdown_lines,
      "",
      paste0(
        "> 전체 ",
        format(
          nrow(data),
          big.mark = ",",
          trim = TRUE
        ),
        "행 중 앞 ",
        max_rows,
        "행만 표시했습니다."
      )
    )
  }
  
  paste(
    markdown_lines,
    collapse = "\n"
  )
}

# Insert or replace the generated result section

update_generated_section <- function(
    output_file,
    markdown_table
) {
  start_marker <- "<!-- AUTO-GENERATED-RESULT:START -->"
  end_marker <- "<!-- AUTO-GENERATED-RESULT:END -->"
  
  if (!file.exists(output_file)) {
    stop(
      paste(
        "Result Markdown file was not found:",
        output_file
      )
    )
  }
  
  existing_lines <- readLines(
    output_file,
    warn = FALSE,
    encoding = "UTF-8"
  )
  
  generated_lines <- c(
    start_marker,
    "",
    "## 자동 생성 결과 테이블",
    "",
    markdown_table,
    "",
    end_marker
  )
  
  start_index <- which(
    trimws(existing_lines) == start_marker
  )
  
  end_index <- which(
    trimws(existing_lines) == end_marker
  )
  
  if (
    length(start_index) == 0 &&
    length(end_index) == 0
  ) {
    updated_lines <- c(
      existing_lines,
      "",
      generated_lines
    )
  } else if (
    length(start_index) == 1 &&
    length(end_index) == 1 &&
    start_index < end_index
  ) {
    lines_before <- if (start_index > 1) {
      existing_lines[
        seq_len(start_index - 1)
      ]
    } else {
      character(0)
    }
    
    lines_after <- if (
      end_index < length(existing_lines)
    ) {
      existing_lines[
        seq.int(
          end_index + 1,
          length(existing_lines)
        )
      ]
    } else {
      character(0)
    }
    
    updated_lines <- c(
      lines_before,
      generated_lines,
      lines_after
    )
    
  } else {
    stop(
      paste(
        "Generated result markers are invalid in:",
        output_file
      )
    )
  }
  
  writeLines(
    updated_lines,
    output_file,
    useBytes = TRUE
  )
}

# Collect the names of all required query result objects

required_object_names <- vapply(
  export_config,
  function(config) {
    config$object_name
  },
  character(1)
)

# Check whether result objects already exist in the current R session

missing_objects <- required_object_names[
  !vapply(
    required_object_names,
    exists,
    logical(1),
    envir = .GlobalEnv,
    inherits = FALSE
  )
]

# Run the query script when required objects are missing

if (length(missing_objects) > 0) {
  message(
    paste(
      "Running query script because the following",
      "result objects are missing:",
      paste(
        missing_objects,
        collapse = ", "
      )
    )
  )
  
  source(
    query_script,
    local = .GlobalEnv
  )
}

# Confirm that all required objects were created

missing_objects_after_execution <- required_object_names[
  !vapply(
    required_object_names,
    exists,
    logical(1),
    envir = .GlobalEnv,
    inherits = FALSE
  )
]

if (length(missing_objects_after_execution) > 0) {
  stop(
    paste(
      "The following result objects were not created:",
      paste(
        missing_objects_after_execution,
        collapse = ", "
      )
    )
  )
}

# Export each query result to its corresponding Markdown file

for (config in export_config) {
  result_data <- get(
    config$object_name,
    envir = .GlobalEnv
  )
  
  if (!is.data.frame(result_data)) {
    stop(
      paste(
        "The result object is not a data.frame:",
        config$object_name
      )
    )
  }
  
  markdown_table <- data_frame_to_markdown(
    data = result_data,
    max_rows = config$max_rows
  )
  
  update_generated_section(
    output_file = config$output_file,
    markdown_table = markdown_table
  )
  
  message(
    paste(
      "Exported",
      config$object_name,
      "to",
      config$output_file
    )
  )
}

message(
  "All query results were exported successfully."
)
