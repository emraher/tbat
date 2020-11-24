#' Get list of banks data from TBB
#'
#' @return A tibble
#'
#' @examples
#'
#' \dontrun{
#' dt <- banks_summary()
#' }
#'
#' @export
#'

banks_summary <- function() {
  doc <- "https://www.tbb.org.tr/en/modules/banka-bilgileri/banka_sube_bilgileri.asp" %>%
    xml2::read_html()

  banks <- doc %>%
    rvest::html_table() %>%
    `[[`(1) %>%
    tibble::as_tibble() %>%
    janitor::clean_names() %>%
    dplyr::mutate(banks = as.numeric(stringr::str_replace_all(banks, "-", NA_character_)))

  return(banks)
}
