<!-- README.md is generated from README.Rmd. Please edit that file -->
cranalmanac
===========

The goal of cranalmanac is to provide some interesting datasets from CRAN, on the current packages, when they were updated, and when packages were archived.

Example
-------

In this example, we are going to look at some of the example data, which includes the archived package names

Using this data, we can look at the rate at which CRAN packages are maintained

``` r
library(cranalmanac)
library(dplyr)
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union

cran_rxiv_pkg_a <-cran_rxiv_pkg_child_tbl_a %>%
  select(-size) %>% 
  mutate(type = "archived") %>%
  bind_rows({
    cran_current_pkg_tbl %>%
      filter(grepl("^A|^a",pkg_name)) %>%
      mutate(type = "cran")
  }) %>%
  arrange(pkg_name, desc(last_modified))
```

``` r
cran_rxiv_pkg_a
#> # A tibble: 1,062 x 4
#>    pkg_name    version last_modified       type    
#>    <chr>       <chr>   <dttm>              <chr>   
#>  1 A3          1.0.0   2015-08-16 23:05:00 cran    
#>  2 A3          0.9.2   2013-03-26 19:58:00 archived
#>  3 A3          0.9.1   2013-02-07 10:00:00 archived
#>  4 abbyyR      0.5.1   2017-04-13 00:30:00 cran    
#>  5 abc         2.1     2015-05-05 11:34:00 cran    
#>  6 abc.data    1.0     2015-05-05 11:34:00 cran    
#>  7 ABC.RAP     0.9.0   2016-10-20 10:52:00 cran    
#>  8 ABCanalysis 1.2.1   2017-03-13 14:31:00 cran    
#>  9 ABCanalysis 1.1.2   2016-08-23 14:57:00 archived
#> 10 ABCanalysis 1.1.1   2016-06-15 10:59:00 archived
#> # ... with 1,052 more rows
```

``` r

cran_rxiv_pkg_a %>%
  group_by(pkg_name) %>%
  summarise(n_versions = n(),
            start_date = min(last_modified),
            last_date = max(last_modified),
            reign = last_date - start_date)
#> # A tibble: 523 x 5
#>    pkg_name    n_versions start_date          last_date           reign   
#>    <chr>            <int> <dttm>              <dttm>              <time>  
#>  1 A3                   3 2013-02-07 10:00:00 2015-08-16 23:05:00 920.586…
#>  2 abbyyR               1 2017-04-13 00:30:00 2017-04-13 00:30:00 0       
#>  3 abc                  1 2015-05-05 11:34:00 2015-05-05 11:34:00 0       
#>  4 abc.data             1 2015-05-05 11:34:00 2015-05-05 11:34:00 0       
#>  5 ABC.RAP              1 2016-10-20 10:52:00 2016-10-20 10:52:00 0       
#>  6 ABCanalysis          7 2015-02-13 11:27:00 2017-03-13 14:31:00 759.127…
#>  7 abcdeFBA             1 2012-09-15 15:13:00 2012-09-15 15:13:00 0       
#>  8 ABCExtremes          1 2013-05-15 10:45:00 2013-05-15 10:45:00 0       
#>  9 ABCoptim             4 2013-11-05 18:00:00 2017-11-06 09:55:00 1461.66…
#> 10 ABCp2                3 2013-04-10 17:04:00 2016-02-04 11:27:00 1029.72…
#> # ... with 513 more rows



cran_rxiv_pkg_a %>%
  group_by(pkg_name) %>%
  summarise(n_versions = n(),
            start_date = min(last_modified),
            last_date = max(last_modified),
            reign = last_date - start_date) %>%
  filter(reign > 365) %>%
  mutate(update_rate = n_versions / as.numeric(reign),
         update_rate = if_else(is.infinite(update_rate),
                               0,
                               update_rate)) %>%
  arrange(desc(update_rate))
#> # A tibble: 66 x 6
#>    pkg_name   n_versions start_date          last_date           reign    
#>    <chr>           <int> <dttm>              <dttm>              <time>   
#>  1 ACEt                9 2016-02-14 18:48:00 2017-05-07 22:51:00 448.2104…
#>  2 ARES                6 2006-10-02 21:59:00 2007-10-30 19:56:00 392.8729…
#>  3 AICcmodavg         43 2009-09-03 15:49:00 2017-06-20 01:35:00 2846.406…
#>  4 AHR                 6 2015-07-03 12:50:00 2016-08-28 15:20:00 422.1041…
#>  5 AdaptGauss          7 2015-10-09 11:36:00 2017-03-15 17:12:00 523.2333…
#>  6 AssetPric…          7 2012-11-07 08:44:00 2014-06-13 06:17:00 582.9395…
#>  7 ASMap              12 2014-09-24 12:12:00 2017-09-14 18:13:00 1086.250…
#>  8 AMCP                4 2016-02-12 01:05:00 2017-02-18 21:22:00 372.8451…
#>  9 ARTP2               5 2016-02-11 08:27:00 2017-05-24 09:05:00 468.0680…
#> 10 AbsFilter…          6 2016-01-04 18:16:00 2017-09-21 15:39:00 625.9326…
#> # ... with 56 more rows, and 1 more variable: update_rate <dbl>
```
