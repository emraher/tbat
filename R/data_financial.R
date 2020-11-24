#' Get financial tables data from TBB
#'
#' @param periods Period codes from periods_financial() KEY column
#'
#' @param tables Table codes from tables_financial() UNIQUE_KEY column
#'
#' @param banks Bank codes from banks_financial() BANKA_KODU column
#'
#' @param groups Group codes from groups_financial() GRUP_NO column
#'
#' @return A tibble
#'
#' @examples
#'
#' \dontrun{
#' dt <- data_financial()
#' }
#'
#' @export
#'
data_financial <- function(periods,
                           tables,
                           banks = NULL,
                           groups = NULL) {
  if (missing(periods)) stop("You need to specify at least one period!")
  if (missing(tables)) stop("You need to specify at least one table!")

  if (is.null(banks) & is.null(groups)) stop("You need to specify either a bank or a group!")

  if (!is.null(banks)) {
    banks_body <- paste(banks, collapse = ", ")
  } else {
    banks_body <- ""
  }

  if (!is.null(groups)) {
    groups_body <- paste(groups, collapse = ", ")
  } else {
    groups_body <- ""
  }


  periods_body <- paste(periods, collapse = ", ")
  tables_body <- paste(tables, collapse = ", ")

  request_body <- paste0(
    '{"route":"degerler","donemler":[', periods_body,
    '],"maliTablolar":[', tables_body,
    '],"bankalar":[', banks_body,
    '],"bankaGruplari":[', groups_body,
    "]}"
  )



  dat <- httr::POST("https://verisistemi.tbb.org.tr/api/router",
    body = request_body,
    httr::add_headers("LANG" = "tr", "ID" = "null"),
    httr::accept_json()
  ) %>%
    httr::content("text") %>%
    jsonlite::fromJSON() %>%
    janitor::clean_names() %>%
    dplyr::left_join(banks_financial(), by = "banka_kodu") %>%
    dplyr::rename("banka_tr_adi" = "tr_adi") %>%
    dplyr::select(
      .data$banka_tr_adi, .data$yil, .data$ay, .data$tp_deger,
      .data$yp_deger, .data$toplam, tidyselect::everything()
    )

  if (is.null(banks) & !is.null(groups)) {
    dat <- dat %>%
      dplyr::left_join(groups_financial(),
        by = c("banka_kodu" = "grup_no")
      ) %>%
      dplyr::select(-.data$banka_tr_adi) %>%
      dplyr::rename("banka_tr_adi" = "tr_adi") %>%
      dplyr::rename("banka_eng_adi" = "eng_adi") %>%
      dplyr::left_join(tables_financial(bank_code = groups),
        by = "unique_key"
      ) %>%
      dplyr::select(
        .data$banka_tr_adi, .data$banka_eng_adi, .data$yil,
        .data$ay, .data$tr_adi, .data$banka_kodu,
        .data$root_tr_adi, .data$toplam, .data$tp_deger,
        .data$yp_deger, .data$banka_grup,
        tidyselect::everything()
      ) %>%
      tibble::as_tibble() %>%
      janitor::clean_names() %>%
      dplyr::mutate(banka_tr_adi = stringr::str_trim(.data$banka_tr_adi))
  } else if (!is.null(banks) & is.null(groups)) {
    dat <- dat %>%
      dplyr::left_join(tables_financial(bank_code = banks), by = "unique_key") %>%
      dplyr::select(
        .data$banka_tr_adi, .data$yil, .data$ay, .data$tr_adi,
        .data$banka_kodu, .data$root_tr_adi, .data$toplam,
        .data$tp_deger, .data$yp_deger, .data$banka_grup,
        tidyselect::everything()
      ) %>%
      tibble::as_tibble() %>%
      janitor::clean_names()
  } else {
    stop("Cannot select both banks and groups at the same time. I'm working on this and will fix it soon!")
  }

  return(dat)
}
