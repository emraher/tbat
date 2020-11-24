#' Get bank groups info for financial data from TBB
#'
#'
#' @return A tibble
#'
#' @examples
#'
#' \dontrun{
#' dt <- groups_financial()
#' }
#'
#' @export
#'
groups_financial <- function() {
  groups <- httr::POST("https://verisistemi.tbb.org.tr/api/router",
    body = '{"route":"bankaGruplari","donemler":[],"maliTablolar":[]}',
    httr::add_headers("LANG" = "tr", "ID" = "null"),
    httr::accept_json()
  ) %>%
    httr::content("text") %>%
    jsonlite::fromJSON() %>%
    janitor::clean_names() %>%
    tibble::as_tibble()

  return(groups)
}
