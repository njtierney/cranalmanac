# create data containing the current pkg name and version of all packages on CRAN
# this should be used with

  cran_current_link <- "https://cran.r-project.org/src/contrib/"

  message("Downloading the CRAN archives, this might take a minute or so")
  # get the text from the CRAN archives page
  cran_current_html_table <- xml2::read_html(cran_current_link) %>%
    rvest::html_table()

  beepr::beep(4)

cran_current_pkg_tbl <- cran_current_html_table %>%
    # get the dataframe out of the list
    .[[1]] %>%
    # drop the top two rows
    tail(-106) %>%
    # drop the last row
    head(-1) %>%
    # drop the first empty column
    .[,-1] %>%
    # drop the Size and Description cols, as they are empty
    .[ ,-c(3,4)] %>%
    dplyr::rename(pkg_name = Name,
                  last_modified = `Last modified`) %>%
    tibble::as_tibble() %>%
    tidyr::separate(col = pkg_name,
                    into = c("pkg_name",
                             "version"),
                    sep = "_") %>%
    dplyr::mutate(version = stringr::str_replace(string = version,
                                                 pattern = ".tar.gz",
                                                 replacement = "")) %>%
  dplyr::mutate(
    last_modified = as.POSIXct(strptime(last_modified,
                                        format = "%Y-%m-%d %H:%M")))


use_data(cran_current_pkg_tbl, overwrite = TRUE)
# an alternative way to get similar info (without the date) is:
    #
    # library(magrittr)
    #
    # cran_pkg_vers_tbl <- available.packages() %>%
    #   tibble::as_tibble() %>%
    #   dplye::select(Package, Version) %>%
    #   dplye::rename(pkg_name = Package,
    #                 version = Version)
