#' Get parameters and codes for risk data from TBB
#'
#' @param categories Data Categories from categories_risk() ANA_KATEGORI column
#'
#' @param periods Data Periods from periods_risk() YIL column
#'
#'
#' @return A tibble with risk data
#'
#' @examples
#'
#' \dontrun{
#' # Get all risk data
#' dt <- data_risk()
#' 
#' # Get risk data for specific categories and periods
#' cats <- categories_risk()$ana_kategori[1:2]
#' pers <- periods_risk()$yil[1:3]
#' dt <- data_risk(categories = cats, periods = pers)
#' }
#'
#' @export
#'
data_risk <- function(categories = NULL, periods = NULL) {
  # Validate parameters
  if (!is.null(categories)) {
    if (!is.vector(categories)) {
      stop("Categories must be a vector of category codes from categories_risk()$ANA_KATEGORI.", call. = FALSE)
    }
    categories <- paste(categories, collapse = ", ")
  } else {
    categories <- ""
  }

  if (!is.null(periods)) {
    if (!is.vector(periods)) {
      stop("Periods must be a vector of period codes from periods_risk()$YIL.", call. = FALSE)
    }
    periods <- paste(periods, collapse = ", ")
  } else {
    periods <- ""
  }

  request_body <- paste0(
    '{"route":"kkbDegerler","paramKategoriler":[',
    categories, '],"paramYillar":[',
    periods, '],"paramRaporAdlari":[]}'
  )

  # Use tryCatch to handle potential errors
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
    parsed_data <- tryCatch(
      jsonlite::fromJSON(content_text),
      error = function(e) {
        stop("Failed to parse API response: ", e$message, call. = FALSE)
      }
    )
    
    # Check if response data is valid
    if (length(parsed_data) == 0 || nrow(parsed_data) == 0) {
      stop("No data returned for the specified parameters. Try different parameters.", call. = FALSE)
    }
    
    # Check for required columns
    required_cols <- c("DONEM", "YIL", "AY", "UK_RAPOR", "RAPOR_ADI")
    missing_cols <- required_cols[!required_cols %in% names(parsed_data)]
    if (length(missing_cols) > 0) {
      stop("API response missing required columns: ", paste(missing_cols, collapse = ", "), call. = FALSE)
    }
    
    # Process the data
    riskdata <- parsed_data %>%
      dplyr::select(
        .data$DONEM, .data$YIL, .data$AY, .data$UK_RAPOR,
        .data$RAPOR_ADI, .data$RAPOR_ADI_EN, .data$UK_KATEGORI,
        .data$KATEGORI, .data$KATEGORI_EN, .data$ALT_KATEGORI_1,
        .data$ALT_KATEGORI_1_EN, .data$ALT_KATEGORI_2,
        .data$ALT_KATEGORI_2_EN, .data$TUTAR, .data$ADET,
        .data$TEKIL_KISI_SAYISI,
        tidyselect::everything()
      ) %>%
      dplyr::arrange(
        .data$RAPOR_ADI, .data$KATEGORI, .data$ALT_KATEGORI_1,
        .data$ALT_KATEGORI_2
      ) %>%
      janitor::clean_names() %>%
      tibble::as_tibble()
      
    # Final validation
    if (nrow(riskdata) == 0) {
      stop("No data was returned after processing. Check your parameter values.", call. = FALSE)
    }
    
    return(riskdata)
      
  }, error = function(e) {
    if (grepl("Timeout", e$message)) {
      stop("API request timed out. The server may be busy, please try again later.", call. = FALSE)
    } else if (grepl("Could not resolve host", e$message)) {
      stop("Network connection failed. Please check your internet connection.", call. = FALSE)
    } else {
      stop("Error retrieving risk data: ", e$message, call. = FALSE)
    }
  })
}
