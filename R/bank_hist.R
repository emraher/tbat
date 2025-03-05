#' Get Historical Bank info from TBB
#'
#' @return A tibble with historical bank information including both operating and closed banks
#'
#' @examples
#'
#' \dontrun{
#' # Get historical bank information
#' bank_history <- bank_hist()
#' 
#' # View operating banks
#' operating_banks <- bank_history %>% filter(!is.na(historical_data))
#' }
#'
#' @export
#'
bank_hist <- function() {
  # URLs for the Excel files
  url_operating <- "https://www.tbb.org.tr/en/Content/Upload/Dokuman/48/Historical_Data_about_Banks_Operating_in_Turkey.xlsx"
  url_closed <- "https://www.tbb.org.tr/en/Content/Upload/Dokuman/49/Historical_Data_about_Closed_Banks.xlsx"
  
  # Function to download and process Excel files with error handling
  download_excel <- function(url, description) {
    tryCatch({
      # Download the Excel file
      message(paste("Downloading", description, "data..."))
      
      excel_data <- openxlsx::read.xlsx(
        url, 
        check.names = FALSE,
        na.strings = c("", "NA", "N/A")
      )
      
      if (is.null(excel_data) || nrow(excel_data) < 3) {
        stop("Downloaded file has insufficient data", call. = FALSE)
      }
      
      return(excel_data)
      
    }, error = function(e) {
      if (grepl("Could not resolve host|Connection refused|SSL|timeout", e$message)) {
        stop("Failed to download ", description, " data: Network error. Please check your internet connection.", call. = FALSE)
      } else if (grepl("Cannot open", e$message)) {
        stop("Failed to download ", description, " data: Could not open the Excel file. The file structure may have changed.", call. = FALSE)
      } else {
        stop("Failed to download ", description, " data: ", e$message, call. = FALSE)
      }
    })
  }
  
  # Download and process operating banks data
  hist_operating <- download_excel(url_operating, "operating banks")
  
  # Process operating banks data with error handling
  tryCatch({
    if (nrow(hist_operating) < 3 || ncol(hist_operating) < 3) {
      stop("Operating banks data has unexpected format", call. = FALSE)
    }
    
    hist_operating_dat <- hist_operating %>%
      purrr::set_names(hist_operating[2, ]) %>%
      dplyr::rename("bank" = 1) %>%
      tidyr::drop_na(.data$`Historical Data`) %>%
      dplyr::slice(-1) %>%
      dplyr::mutate(dplyr::across(tidyselect::everything(),
        .fns = as.character
      )) %>%
      janitor::clean_names()
      
    if (nrow(hist_operating_dat) == 0) {
      stop("No operating banks data found after processing", call. = FALSE)
    }
    
  }, error = function(e) {
    stop("Error processing operating banks data: ", e$message, call. = FALSE)
  })
  
  # Download and process closed banks data
  hist_closed <- download_excel(url_closed, "closed banks")
  
  # Process closed banks data with error handling
  tryCatch({
    if (nrow(hist_closed) < 3 || ncol(hist_closed) < 3) {
      stop("Closed banks data has unexpected format", call. = FALSE)
    }
    
    hist_closed_dat <- hist_closed %>%
      purrr::set_names(hist_closed[2, ])
    
    if (!"bank" %in% names(hist_closed_dat) && ncol(hist_closed_dat) > 0) {
      names(hist_closed_dat)[1] <- "bank"
    }
    
    hist_closed_dat <- hist_closed_dat %>%
      tidyr::drop_na(.data$`Historical Data`) %>%
      tidyr::drop_na(.data$bank) %>%
      dplyr::select(1:3) %>%
      dplyr::mutate(dplyr::across(tidyselect::everything(),
        .fns = as.character
      )) %>%
      janitor::clean_names() %>%
      dplyr::rename("establish_year" = 2)
      
    if (nrow(hist_closed_dat) == 0) {
      stop("No closed banks data found after processing", call. = FALSE)
    }
    
  }, error = function(e) {
    stop("Error processing closed banks data: ", e$message, call. = FALSE)
  })
  
  # Combine the datasets
  tryCatch({
    hist_data <- dplyr::bind_rows(hist_operating_dat, hist_closed_dat) %>%
      tibble::as_tibble()
      
    if (nrow(hist_data) == 0) {
      stop("No data found after combining operating and closed banks data", call. = FALSE)
    }
    
    return(hist_data)
    
  }, error = function(e) {
    stop("Error combining bank history data: ", e$message, call. = FALSE)
  })
}
