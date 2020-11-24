#' Get banks info for financial data from TBB
#'
#'
#' @return A tibble
#'
#' @examples
#'
#'
#' \dontrun{
#' dt <- banks_financial()
#' }
#'
#' @export
#'
banks_financial <- function() {
  banks <- httr::POST("https://verisistemi.tbb.org.tr/api/router",
                      body = '{"route":"bankalar","donemler":[],"maliTablolar":[]}',
                      httr::add_headers("LANG" = "tr", "ID" = "null"),
                      httr::accept_json()) %>%
    httr::content("text") %>%
    jsonlite::fromJSON() %>%
    dplyr::select(.data$TR_ADI, .data$BANKA_KODU) %>%
    janitor::clean_names() %>%
    tibble::as_tibble()

  return(banks)
}
