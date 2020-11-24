#' Get periods for financial data from TBB
#'
#'
#' @return A tibble
#'
#' @examples
#'
#' \dontrun{
#' dt <- periods_financial()
#' }
#'
#' @export
#'
periods_financial <- function() {
  periods <- httr::POST("https://verisistemi.tbb.org.tr/api/router",
    body = '{"route":"donemler"}',
    httr::add_headers("LANG" = "tr", "ID" = "null"),
    httr::accept_json()
  ) %>%
    httr::content("text") %>%
    jsonlite::fromJSON() %>%
    dplyr::select(.data$YIL, .data$AY, tidyselect::everything()) %>%
    dplyr::arrange(.data$YIL, .data$AY) %>%
    janitor::clean_names() %>%
    tibble::as_tibble()

  return(periods)
}
