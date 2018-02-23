#' Get CRAN archived package names and when they were last modified
#'
#' @return a data.frame of the pkg name, and when it was last modified
#'
#' @export
#'
#' @examples
#'
#' \dontrun{
#' cran_rxiv_pkg_parent_tbl <- cran_rxiv_pkgs()
#' }
cran_rxiv_pkg_parent <- function(){

  cran_rxiv_link <- "https://cran.r-project.org/src/contrib/Archive/"

  message("Downloading the CRAN archives, this might take a minute or so")
  # get the text from the CRAN archives page
  cran_rxiv_html_table <- xml2::read_html(cran_rxiv_link) %>%
    rvest::html_table()

  beepr::beep(4)

  cran_rxiv_html_table %>%
  # get the dataframe out of the list
    .[[1]] %>%
  # drop the top two rows
  tail(-2) %>%
  # drop the last row
  head(-1) %>%
  # drop the first empty column
  .[,-1] %>%
  # drop the Size and Description cols, as they are empty
  .[ ,-c(3,4)] %>%
  dplyr::rename(pkg_name = Name,
         last_modified = `Last modified`) %>%
  tibble::as_tibble()

}
