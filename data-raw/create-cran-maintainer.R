url_cran <- "https://cran.r-project.org/"

url_cre <- "web/checks/check_summary_by_maintainer.html#summary_by_maintainer"

url_cran_pkg_by_cre <- paste0(url_cran, url_cre)

cran_pkg_by_cre <- url_cran_pkg_by_cre %>%
  xml2::read_html() %>%
  rvest::html_table()

cran_pkg_maint <- cran_pkg_by_cre %>%
  .[[1]] %>%
  as_tibble() %>%
  naniar::replace_with_na_at(.vars = "Maintainer",
                             condition = ~.x=="") %>%
  tidyr::fill(Maintainer, .direction = "down") %>%
  dplyr::select(Maintainer,
                Package) %>%
  dplyr::rename(maintainer = Maintainer,
                pkg = Package) %>%
  tidyr::separate(col = maintainer,
                  into = c("name", "email"),
                  sep = "<") %>%
  dplyr::mutate(name = stringr::str_trim(name, side = "right")) %>%
  dplyr::select(-email) %>%
  dplyr::mutate(name = gsub(x = name, pattern = "'", replacement = '')) %>%
  dplyr::mutate(name = gsub(x = name, pattern = '"', replacement = ''))

use_data(cran_pkg_maint, overwrite = TRUE)
