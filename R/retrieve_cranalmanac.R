#' Get the list of all the names of all the links
#'
#' @param cran_rxiv_pkg_parent_tbl the table of parent package names
#'
#' @return list of urls of all archived CRAN packages
#' @export
#'
#' @examples
#'
#' \dontrun{
#' cran_rxiv_pkg_parent_tbl <- cran_rxiv_pkgs()
#' cran_rxiv_pkg_name_link(cran_rxiv_pkg_parent_tbl)
#' }
#'
cran_rxiv_pkg_name_link <- function(cran_rxiv_pkg_parent_tbl){

  cran_rxiv_link <- "https://cran.r-project.org/src/contrib/Archive/"

  cran_rxiv_link_names <- purrr::map2(cran_rxiv_link,
                                      cran_rxiv_pkg_parent_tbl$pkg_name,
                                      paste0)

  cran_rxiv_link_names

}

#' Get all CRAN archived packages, version numbers, and when they were last modified
#'
#' @param cran_rxiv_pkg_parent_tbl
#' @param n Number of packages to retrieve, the default is 100, if you leave this as NULL it will try (and possibly fail) to retrieve all packages
#'
#' @return
#' @export
#'
#' @examples
#' cran_rxiv_pkg_parent_tbl <- cran_rxiv_pkg_parent()
#' # get 200 packages
#' cran_rxiv_pkg_child_tbl_200 <- cran_rxiv_pkg_children(cran_rxiv_pkg_parent_tbl,
#' n = 200)
#'
cran_rxiv_pkg_children <- function(cran_rxiv_pkg_parent_tbl,
                                   n = 100){

  cran_rxiv_pkg_name_link <- cran_rxiv_pkg_name_link(cran_rxiv_pkg_parent_tbl)

cran_rxiv_link <- "https://cran.r-project.org/src/contrib/Archive/"

# go into each link and then create a tidy format
scrape_cran_rxiv <- function(cran_rxiv_pkg_name_link){
  xml2::read_html(cran_rxiv_pkg_name_link) %>%
    rvest::html_table() %>%
    .[[1]] %>%
    tail(-2) %>%
    head(-1) %>%
    .[,-1]
}

if (!is.null(n)){

  cran_rxiv_pkg_name_link <- cran_rxiv_pkg_name_link[1:n]


  scraped_cran_rxiv_pkgs <- purrr::map_dfr(cran_rxiv_pkg_name_link,
                                           scrape_cran_rxiv)

} else if (is.null(n)){

  scraped_cran_rxiv_pkgs <- purrr::map_dfr(cran_rxiv_pkg_name_link,
                                           scrape_cran_rxiv)
}

return(tidy_scraped_cran_rxiv(scraped_cran_rxiv_pkgs))

}


#' Clean up the output of cran_rxiv_pkg_children
#'
#' This function is used inside
#'
#' @param cran_rxiv_pkg_children
#'
#' @return data.frame with columns
tidy_scraped_cran_rxiv <- function(cran_rxiv_pkg_children){
  cran_rxiv_pkg_children %>%
    janitor::clean_names() %>%
    tidyr::separate(col = name,
                    into = c("pkg_name",
                             "version"),
                    sep = "_") %>%
    dplyr::mutate(version = stringr::str_replace(string = version,
                                                 pattern = ".tar.gz",
                                                 replacement = "")) %>%
    dplyr::mutate(
      last_modified = as.POSIXct(strptime(last_modified,
                                          format = "%Y-%m-%d %H:%M"))) %>%
    tibble::as_tibble() %>%
    # drop description
    dplyr::select(-description)
}
