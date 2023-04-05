#' Get regional data from TBB
#'
#' @param years Years
#'
#' @param regions Region Codes
#'
#' @param parameters Data Codes
#'
#' @return A tibble
#'
#' @examples
#'
#' \dontrun{
#' dt <- data_region(years = c(2000))
#' }
#'
#' @export
#'

data_region <- function(years = NULL, regions = NULL, parameters = NULL) {
  url <- "https://verisistemi.tbb.org.tr/api/router"

  if (!is.null(years)) {
    years <- paste(years, collapse = ", ")
  } else {
    years <- ""
  }

  if (!is.null(regions)) {
    regions <- paste(regions, collapse = ", ")
  } else {
    regions <- ""
  }

  if (!is.null(parameters)) {
    parameters <- paste(parameters, collapse = ", ")
  } else {
    parameters <- ""
  }

  request_body <- paste0(
    '{"route":"blgDegerler","paramYillar":[', years,
    '],"paramBolgeler":[', regions,
    '],"paramParametreler":[', parameters,
    "]}"
  )

  http_response <- httr::POST(url,
    body = request_body,
    httr::add_headers("LANG" = "tr", "ID" = "null"),
    httr::accept_json(),
    config = httr::config(ssl_verifypeer = FALSE)
  )

  dat <- jsonlite::fromJSON(httr::content(http_response, "text")) %>%
    janitor::clean_names()

  params <- params_region()

  dat <- dplyr::left_join(dat, params,
    by = c("il_bolge_key", "parametre_uk", "unique_key")
  ) %>%
    dplyr::select(
      .data$yil, .data$tr_adi, .data$en_adi, .data$parametre,
      .data$parametre_en, .data$toplam, .data$tp_deger,
      .data$yp_deger, tidyselect::everything()
    ) %>%
    dplyr::arrange(.data$yil, .data$tr_adi, .data$parametre) %>%
    janitor::clean_names() %>%
    tibble::as_tibble()

  return(dat)
}
