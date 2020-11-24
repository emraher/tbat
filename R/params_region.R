#' Get parameters and codes for regional data from TBB
#'
#' @return A tibble
#'
#' @examples
#'
#'
#' \dontrun{
#' dt <- params_region()
#' }
#'
#' @export
#'

params_region <- function() {

  url <- "https://verisistemi.tbb.org.tr/api/router"

  http_response <- httr::POST(url,
                             body = '{"route":"blgParametrelerAll"}',
                             httr::add_headers("LANG" = "tr", "ID" = "null"),
                             httr::accept_json())

  parameters <- jsonlite::fromJSON(httr::content(http_response, "text"))

  http_response <- httr::POST(url,
                             body = '{"route":"blgBolgelerAll"}',
                             httr::add_headers("LANG" = "tr", "ID" = "null"),
                             httr::accept_json())

  region_codes <- jsonlite::fromJSON(httr::content(http_response, "text")) %>%
    dplyr::rename("IL_BOLGE_KEY" = "KEY")

  dat <-  dplyr::left_join(region_codes, parameters,
                           by = c("TR_ADI", "EN_ADI", "IL_BOLGE_KEY")) %>%
    dplyr::select(.data$UNIQUE_KEY, .data$TR_ADI, .data$EN_ADI,
                  .data$IL_BOLGE_KEY, .data$PARAMETRE, .data$PARAMETRE_EN,
                  .data$PARAMETRE_UK, tidyselect::everything()) %>%
    dplyr::arrange(.data$ORDER_NO) %>%
    janitor::clean_names() %>%
    tibble::as_tibble()

  return(dat)

}
