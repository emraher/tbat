#' Get parameters and codes for risk data from TBB
#'
#' @return A tibble
#'
#' @examples
#'
#' \dontrun{
#' dt <- categories_risk()
#' }
#'
#' @export
#'
categories_risk <- function() {
  categories <- httr::POST("https://verisistemi.tbb.org.tr/api/router",
    body = '{"filters":[],"route":"kkbKategorilerAll"}',
    httr::add_headers("LANG" = "tr", "ID" = "null"),
    httr::accept_json()
  ) %>%
    httr::content(as = "text") %>%
    jsonlite::fromJSON() %>%
    dplyr::select(
      .data$UK_RAPOR, .data$RAPOR_ADI, .data$RAPOR_ADI_EN,
      .data$UK_KATEGORI, .data$KATEGORI, .data$KATEGORI_EN,
      .data$ALT_KATEGORI_1, .data$ALT_KATEGORI_1_EN,
      .data$ALT_KATEGORI_2, .data$ALT_KATEGORI_2_EN,
      tidyselect::everything()
    ) %>%
    dplyr::arrange(
      .data$RAPOR_ADI, .data$KATEGORI, .data$ALT_KATEGORI_1,
      .data$ALT_KATEGORI_2
    ) %>%
    janitor::clean_names() %>%
    tibble::as_tibble()

  return(categories)
}
