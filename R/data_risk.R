#' Get parameters and codes for risk data from TBB
#'
#' @param categories Data Categories
#'
#' @param periods Data Periods
#'
#'
#' @return A tibble
#'
#' @examples
#'
#' \dontrun{
#' dt <- data_risk()
#' }
#'
#' @export
#'
data_risk <- function(categories = NULL, periods = NULL) {
  if (!is.null(categories)) {
    categories <- paste(categories, collapse = ", ")
  } else {
    categories <- ""
  }

  if (!is.null(periods)) {
    periods <- paste(periods, collapse = ", ")
  } else {
    periods <- ""
  }

  request_body <- paste0(
    '{"route":"kkbDegerler","paramKategoriler":[',
    categories, '],"paramYillar":[',
    periods, '],"paramRaporAdlari":[]}'
  )


  riskdata <- httr::POST("https://verisistemi.tbb.org.tr/api/router",
    body = request_body,
    httr::add_headers("LANG" = "tr", "ID" = "null"),
    httr::accept_json(),
    config = httr::config(ssl_verifypeer = FALSE)
  ) %>%
    httr::content(as = "text") %>%
    jsonlite::fromJSON() %>%
    dplyr::select(
      .data$DONEM, .data$YIL, .data$AY, .data$UK_RAPOR,
      .data$RAPOR_ADI, .data$RAPOR_ADI_EN, .data$UK_KATEGORI,
      .data$KATEGORI, .data$KATEGORI_EN, .data$ALT_KATEGORI_1,
      .data$ALT_KATEGORI_1_EN, .data$ALT_KATEGORI_2,
      .data$ALT_KATEGORI_2_EN, .data$TUTAR, .data$ADET,
      .data$TEKIL_KISI_SAYISI,
      tidyselect::everything()
    ) %>%
    dplyr::arrange(
      .data$RAPOR_ADI, .data$KATEGORI, .data$ALT_KATEGORI_1,
      .data$ALT_KATEGORI_2
    ) %>%
    janitor::clean_names() %>%
    tibble::as_tibble()
}
