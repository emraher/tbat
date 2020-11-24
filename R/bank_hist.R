#' Get Historical Bank info from TBB
#'
#' @return A tibble
#'
#' @examples
#'
#' \dontrun{
#' dt <- bank_hist()
#' }
#'
#' @export
#'
bank_hist <- function() {
  hist_operating <- openxlsx::read.xlsx("https://www.tbb.org.tr/en/Content/Upload/Dokuman/48/Historical_Data_about_Banks_Operating_in_Turkey.xlsx")

  hist_operating_dat <- hist_operating %>%
    purrr::set_names(hist_operating[2, ]) %>%
    dplyr::rename("bank" = 1) %>%
    tidyr::drop_na(.data$`Historical Data`) %>%
    dplyr::slice(-1) %>%
    dplyr::mutate(dplyr::across(tidyselect::everything(),
      .fns = as.character
    )) %>%
    janitor::clean_names()

  hist_closed <- openxlsx::read.xlsx("https://www.tbb.org.tr/en/Content/Upload/Dokuman/49/Historical_Data_about_Closed_Banks.xlsx")

  hist_closed_dat <- hist_closed %>%
    purrr::set_names(hist_closed[2, ])

  names(hist_closed_dat)[1] <- "bank"

  hist_closed_dat <- hist_closed_dat %>%
    tidyr::drop_na(.data$`Historical Data`) %>%
    tidyr::drop_na(.data$bank) %>%
    dplyr::select(1:3) %>%
    dplyr::mutate(dplyr::across(tidyselect::everything(),
      .fns = as.character
    )) %>%
    janitor::clean_names() %>%
    dplyr::rename("establish_year" = 2)


  hist_data <- dplyr::bind_rows(hist_operating_dat, hist_closed_dat) %>%
    tibble::as_tibble()


  return(hist_data)
}
