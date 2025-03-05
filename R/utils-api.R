#' Internal function to handle API requests
#'
#' @param url API endpoint URL
#' @param body Request body (JSON string)
#' @param timeout Timeout in seconds
#' @param headers HTTP headers to include
#'
#' @return Parsed JSON response
#'
#' @keywords internal
#'
.api_request <- function(url, 
                         body, 
                         timeout = 60, 
                         headers = c("LANG" = "tr", "ID" = "null")) {
  
  # Make the API request
  tryCatch({
    response <- httr::POST(
      url = url,
      body = body,
      httr::add_headers(headers),
      httr::accept_json(),
      config = httr::config(ssl_verifypeer = FALSE),
      httr::timeout(timeout)
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
    if (length(parsed_data) == 0) {
      stop("API returned empty dataset", call. = FALSE)
    }
    
    return(parsed_data)
    
  }, error = function(e) {
    if (grepl("Timeout", e$message)) {
      stop("API request timed out. The server may be busy, please try again later.", call. = FALSE)
    } else if (grepl("Could not resolve host", e$message)) {
      stop("Network connection failed. Please check your internet connection.", call. = FALSE)
    } else if (grepl("SSL certificate problem", e$message)) {
      stop("SSL certificate validation failed. This might be due to an outdated R installation or proxy settings.", call. = FALSE)
    } else {
      stop("Error in API request: ", e$message, call. = FALSE)
    }
  })
}

#' Check if a value is a valid parameter
#'
#' @param param Parameter value to check
#' @param valid_values Vector of valid values
#' @param param_name Name of the parameter (for error message)
#' @param allow_null Whether NULL is a valid value
#'
#' @return TRUE if valid, otherwise stops with error
#'
#' @importFrom utils head
#' @keywords internal
#'
.check_param <- function(param, valid_values, param_name, allow_null = TRUE) {
  if (is.null(param)) {
    if (allow_null) {
      return(TRUE)
    } else {
      stop(param_name, " cannot be NULL", call. = FALSE)
    }
  }
  
  if (!is.vector(param)) {
    stop(param_name, " must be a vector", call. = FALSE)
  }
  
  invalid_values <- param[!param %in% valid_values]
  if (length(invalid_values) > 0) {
    stop(
      "Invalid ", param_name, " value(s): ", 
      paste(invalid_values, collapse = ", "), 
      ". Valid values are: ", 
      paste(utils::head(valid_values, 5), collapse = ", "),
      if(length(valid_values) > 5) " and others.",
      call. = FALSE
    )
  }
  
  return(TRUE)
}