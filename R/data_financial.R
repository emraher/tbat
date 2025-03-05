#' Get financial tables data from TBB
#'
#' @param periods Period codes from periods_financial() KEY column
#'
#' @param tables Table codes from tables_financial() UNIQUE_KEY column
#'
#' @param banks Bank codes from banks_financial() BANKA_KODU column
#'
#' @param groups Group codes from groups_financial() GRUP_NO column
#'
#' @return A tibble with financial data
#'
#' @examples
#'
#' \dontrun{
#' # Get financial data for specific periods and tables
#' periods <- periods_financial()$key[1:2]
#' tables <- tables_financial()$unique_key[1:3]
#' banks <- banks_financial()$banka_kodu[1:5]
#' dt <- data_financial(periods = periods, tables = tables, banks = banks)
#' }
#'
#' @export
#'
data_financial <- function(periods,
                           tables,
                           banks = NULL,
                           groups = NULL) {
  # Validate required parameters
  if (missing(periods)) {
    stop("You need to specify at least one period! Use periods_financial() to get valid period codes.", call. = FALSE)
  }
  if (!is.vector(periods)) {
    stop("Periods must be a vector of period codes from periods_financial()$KEY.", call. = FALSE)
  }
  
  if (missing(tables)) {
    stop("You need to specify at least one table! Use tables_financial() to get valid table codes.", call. = FALSE)
  }
  if (!is.vector(tables)) {
    stop("Tables must be a vector of table codes from tables_financial()$UNIQUE_KEY.", call. = FALSE)
  }

  if (is.null(banks) & is.null(groups)) {
    stop("You need to specify either a bank or a group! Use banks_financial() or groups_financial() to get valid codes.", call. = FALSE)
  }
  
  if (!is.null(banks) && !is.null(groups)) {
    stop("Cannot select both banks and groups at the same time. Choose either banks or groups parameter.", call. = FALSE)
  }

  if (!is.null(banks)) {
    if (!is.vector(banks)) {
      stop("Banks must be a vector of bank codes from banks_financial()$BANKA_KODU.", call. = FALSE)
    }
    banks_body <- paste(banks, collapse = ", ")
  } else {
    banks_body <- ""
  }

  if (!is.null(groups)) {
    if (!is.vector(groups)) {
      stop("Groups must be a vector of group codes from groups_financial()$GRUP_NO.", call. = FALSE)
    }
    groups_body <- paste(groups, collapse = ", ")
  } else {
    groups_body <- ""
  }

  periods_body <- paste(periods, collapse = ", ")
  tables_body <- paste(tables, collapse = ", ")

  request_body <- paste0(
    '{"route":"degerler","donemler":[', periods_body,
    '],"maliTablolar":[', tables_body,
    '],"bankalar":[', banks_body,
    '],"bankaGruplari":[', groups_body,
    "]}"
  )

  tryCatch({
    # Make the API request
    response <- httr::POST("https://verisistemi.tbb.org.tr/api/router",
      body = request_body,
      httr::add_headers("LANG" = "tr", "ID" = "null"),
      httr::accept_json(),
      config = httr::config(ssl_verifypeer = FALSE),
      httr::timeout(60) # Add timeout to prevent hanging
    )
    
    # Check the response status
    if (httr::http_error(response)) {
      status <- httr::status_code(response)
      msg <- paste0("API request failed with status code ", status)
      
      # Try to get error details from response
      error_content <- tryCatch(
        httr::content(response, "text", encoding = "UTF-8"),
        error = function(e) NULL
      )
      
      if (!is.null(error_content)) {
        msg <- paste0(msg, ": ", error_content)
      }
      
      stop(msg, call. = FALSE)
    }
    
    # Parse the response content
    content_text <- httr::content(response, "text", encoding = "UTF-8")
    
    if (content_text == "" || is.null(content_text)) {
      stop("API returned empty response", call. = FALSE)
    }
    
    # Parse JSON
    dat <- tryCatch(
      jsonlite::fromJSON(content_text),
      error = function(e) {
        stop("Failed to parse API response: ", e$message, call. = FALSE)
      }
    )
    
    # Check if response data is valid
    if (length(dat) == 0 || nrow(dat) == 0) {
      stop("No data returned for the specified parameters. Try different parameters.", call. = FALSE)
    }
    
    # Process the data
    dat <- dat %>%
      janitor::clean_names() %>%
      dplyr::left_join(banks_financial(), by = "banka_kodu") %>%
      dplyr::rename("banka_tr_adi" = "tr_adi") %>%
      dplyr::select(
        .data$banka_tr_adi, .data$yil, .data$ay, .data$tp_deger,
        .data$yp_deger, .data$toplam, tidyselect::everything()
      )
      
  }, error = function(e) {
    if (grepl("Timeout", e$message)) {
      stop("API request timed out. The server may be busy, please try again later.", call. = FALSE)
    } else if (grepl("Could not resolve host", e$message)) {
      stop("Network connection failed. Please check your internet connection.", call. = FALSE)
    } else {
      stop("Error in API request: ", e$message, call. = FALSE)
    }
  })

  # Process data based on whether we're using banks or groups
  tryCatch({
    if (is.null(banks) & !is.null(groups)) {
      # Process group data
      groups_data <- tryCatch(
        groups_financial(),
        error = function(e) {
          stop("Failed to retrieve groups data: ", e$message, call. = FALSE)
        }
      )
      
      tables_data <- tryCatch(
        tables_financial(bank_code = groups),
        error = function(e) {
          stop("Failed to retrieve tables data for the specified groups: ", e$message, call. = FALSE)
        }
      )
      
      dat <- dat %>%
        dplyr::left_join(groups_data, by = c("banka_kodu" = "grup_no"))
      
      # Check if join was successful
      if (!"tr_adi" %in% names(dat)) {
        stop("Failed to join group data: group codes may be invalid. Check values from groups_financial().", call. = FALSE)
      }
      
      dat <- dat %>%
        dplyr::select(-.data$banka_tr_adi) %>%
        dplyr::rename("banka_tr_adi" = "tr_adi") %>%
        dplyr::rename("banka_eng_adi" = "eng_adi") %>%
        dplyr::left_join(tables_data, by = "unique_key")
      
      # Check if tables join was successful
      if (!"root_tr_adi" %in% names(dat)) {
        warning("Some tables data may not have joined correctly. Check table codes from tables_financial().")
      }
      
      dat <- dat %>%
        dplyr::select(
          .data$banka_tr_adi, .data$banka_eng_adi, .data$yil,
          .data$ay, .data$tr_adi, .data$banka_kodu,
          .data$root_tr_adi, .data$toplam, .data$tp_deger,
          .data$yp_deger, .data$banka_grup,
          tidyselect::everything()
        ) %>%
        tibble::as_tibble() %>%
        janitor::clean_names() %>%
        dplyr::mutate(banka_tr_adi = stringr::str_trim(.data$banka_tr_adi))
        
    } else if (!is.null(banks) & is.null(groups)) {
      # Process bank data
      tables_data <- tryCatch(
        tables_financial(bank_code = banks),
        error = function(e) {
          stop("Failed to retrieve tables data for the specified banks: ", e$message, call. = FALSE)
        }
      )
      
      dat <- dat %>%
        dplyr::left_join(tables_data, by = "unique_key")
        
      # Check if tables join was successful
      if (!"root_tr_adi" %in% names(dat)) {
        warning("Some tables data may not have joined correctly. Check table codes from tables_financial().")
      }
      
      dat <- dat %>%
        dplyr::select(
          .data$banka_tr_adi, .data$yil, .data$ay, .data$tr_adi,
          .data$banka_kodu, .data$root_tr_adi, .data$toplam,
          .data$tp_deger, .data$yp_deger, .data$banka_grup,
          tidyselect::everything()
        ) %>%
        tibble::as_tibble() %>%
        janitor::clean_names()
    }
  }, error = function(e) {
    stop("Error processing data: ", e$message, call. = FALSE)
  })

  # Final validation
  if (is.null(dat) || nrow(dat) == 0) {
    stop("No data was returned after processing. Check your parameter values.", call. = FALSE)
  }

  return(dat)
}
