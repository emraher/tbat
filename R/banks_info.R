#' Get list of banks info data from TBB
#'
#' @param date Optional Date in DD/MM/YY format
#'
#' @return A tibble
#'
#' @examples
#'
#' \dontrun{
#' dt <- banks_info()
#' }
#'
#' @export
#'

banks_info <- function(date = format(Sys.time(), "%d/%m/%Y")) {
  url <- paste0("https://www.tbb.org.tr/en/modules/banka-bilgileri/banka_Listesi.asp?tarih=", date)

  doc <- url %>%
    xml2::read_html()

  to_drop <- c(
    "The Banking System in Turkey",
    "Deposit Banks",
    "State-owned Deposit Banks",
    "Privately-owned Deposit Banks",
    "Banks Under the Deposit Insurance Fund",
    "Foreign Banks",
    "Foreign Banks Founded in Turkey",
    "Foreign Banks Having Branches in Turkey",
    "Development and Investment Banks",
    "State-owned Development and Investment Banks",
    "Privately-owned Development and Investment Banks",
    "Foreign Development and Investment Banks"
  )

  "%not_in%" <- function(x, y) !("%in%"(x, y))

  res <- doc %>%
    rvest::html_table() %>%
    `[[`(1) %>%
    tibble::as_tibble() %>%
    dplyr::filter(.data$`Bank Name` %not_in% to_drop) %>%
    janitor::clean_names()

  return(res)
}
