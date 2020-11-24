#' Get Historical General Manager info from TBB
#'
#' @return A tibble
#'
#' @examples
#'
#' \dontrun{
#' dt <- gm_hist()
#' }
#'
#' @export
#'
gm_hist <- function() {
  hist_gm_operating <- openxlsx::read.xlsx("https://www.tbb.org.tr/en/Content/Upload/Dokuman/50/General_Managers_in_Banks_Operating_in_Turkey.xlsx")

  hist_gm_operating_dat <- hist_gm_operating %>%
    purrr::set_names(hist_gm_operating[2, ]) %>%
    dplyr::rename("bank" = 1) %>%
    tidyr::drop_na(.data$bank) %>%
    dplyr::slice(-1) %>%
    dplyr::mutate(dplyr::across(tidyselect::everything(),
      .fns = as.character
    )) %>%
    tidyr::pivot_longer(-.data$bank, names_to = "year", values_to = "gm") %>%
    dplyr::arrange(.data$bank, .data$year) %>%
    dplyr::group_by(.data$bank) %>%
    tidyr::fill("gm", .direction = "down") %>%
    dplyr::ungroup() %>%
    dplyr::mutate(
      closed_date = NA,
      year = stringr::str_remove_all(.data$year, "[:alpha:]"),
      year = as.numeric(.data$year),
      closed = 0
    ) %>%
    dplyr::select(
      .data$bank, .data$closed, .data$closed_date,
      tidyselect::everything()
    ) %>%
    janitor::clean_names()

  hist_gm_closed <- openxlsx::read.xlsx("https://www.tbb.org.tr/en/Content/Upload/Dokuman/51/General_Managers_of_the_Closed_Banks.xlsx")

  hist_gm_closed_dat <- hist_gm_closed %>%
    dplyr::select(-c(.data$X49:.data$X52))

  names(hist_gm_closed_dat) <- unlist(c("bank", hist_gm_closed_dat[2, -1]))

  hist_gm_closed_dat <- hist_gm_closed_dat %>%
    tidyr::drop_na(.data$bank) %>%
    dplyr::slice(-1) %>%
    dplyr::mutate(dplyr::across(tidyselect::everything(),
      .fns = as.character
    )) %>%
    dplyr::rename("closed_date" = 2) %>%
    tidyr::pivot_longer(-c(.data$bank, .data$closed_date),
      names_to = "year", values_to = "gm"
    ) %>%
    dplyr::arrange(.data$bank, .data$year) %>%
    dplyr::group_by(.data$bank) %>%
    tidyr::fill("gm", .direction = "down") %>%
    dplyr::mutate(
      closed_date = as.numeric(.data$closed_date),
      year = as.numeric(.data$year),
      gm = ifelse(.data$year > .data$closed_date, NA, .data$gm),
      closed = 1
    ) %>%
    dplyr::select(
      .data$bank, .data$closed, .data$closed_date,
      tidyselect::everything()
    )


  gm_data <- dplyr::bind_rows(hist_gm_operating_dat, hist_gm_closed_dat)


  return(gm_data)
}
