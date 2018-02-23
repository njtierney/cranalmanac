# create the data of the "parent" level and "child" level of the CRAN archived
# data.
# We start with the letter A, because it's currently limited

library(cranalmanac)

# get the parent package data
cran_rxiv_pkg_parent_tbl <- cran_rxiv_pkg_parent()

# get t200 packages
cran_rxiv_pkg_child_tbl_200 <- cran_rxiv_pkg_children(cran_rxiv_pkg_parent_tbl,
                                                      n = 200)

# subset these to the letter A -------------------------------------------------

cran_rxiv_pkg_child_tbl_a <- cran_rxiv_pkg_child_tbl_200 %>%
  filter(grepl("^a|^A", pkg_name))

cran_rxiv_pkg_parent_tbl_a <- cran_rxiv_pkg_parent_tbl %>%
  filter(grepl("^a|^A", pkg_name))

use_data(cran_rxiv_pkg_child_tbl_a)
use_data(cran_rxiv_pkg_parent_tbl_a)
