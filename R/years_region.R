#' Get available years for regional data from TBB
#' #'
#' @return A tibble
#'
#' @examples
#'
#' \dontrun{
#' dt <- years_region()
#' }
#'
#' @export
#'

years_region <- function() {
  url <- "https://verisistemi.tbb.org.tr/api/router"

  req_body <- '{"route":"blgYillar","paramBolgeler":[],"paramParametreler":[]}'

  http_response <- httr::POST(url,
    body = req_body,
    httr::add_headers("LANG" = "en", "ID" = "null"),
    httr::accept_json(),
    config = httr::config(ssl_verifypeer = FALSE)
  )

  years <- jsonlite::fromJSON(httr::content(http_response, "text")) %>%
    janitor::clean_names() %>%
    tibble::as_tibble()

  return(years)
}
