#' Get available years for risk data from TBB
#'
#' @return A tibble
#'
#' @examples
#'
#' \dontrun{
#' dt <- periods_risk()
#' }
#'
#' @export
#'
periods_risk <- function() {
  periods <- httr::POST("https://verisistemi.tbb.org.tr/api/router",
    body = '{"route":"kkbYillarAll"}',
    httr::add_headers("LANG" = "tr", "ID" = "null"), httr::accept_json()
  ) %>%
    httr::content("text") %>%
    jsonlite::fromJSON() %>%
    tibble::as_tibble()

  return(periods)
}
