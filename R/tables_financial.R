#' Get financial tables data from TBB
#'
#' @param bank_code Bank codes from banks_financial()
#'
#' @param periods Period codes from periods_financial()
#'
#' @return A tibble
#'
#' @examples
#'
#' \dontrun{
#' dt <- tables_financial()
#' }
#'
#' @export
#'
tables_financial <- function(bank_code, periods = NULL) {
  if (!is.null(periods)) {
    periods <- paste(periods, collapse = ", ")
  } else {
    periods <- ""
  }

  bank_code_body <- paste(bank_code, collapse = ", ")

  request_body <- paste0(
    '{"route":"maliTablolar","donemler":[', periods,
    '],"bankalar":[',
    bank_code_body, "]}"
  )

  tables <- httr::POST("https://verisistemi.tbb.org.tr/api/router",
    body = request_body,
    httr::add_headers("LANG" = "tr", "ID" = "null"),
    httr::accept_json(),
    config = httr::config(ssl_verifypeer = FALSE)
  ) %>%
    httr::content("text") %>%
    jsonlite::fromJSON() %>%
    janitor::clean_names() %>%
    tibble::as_tibble()


  return(tables)
}
