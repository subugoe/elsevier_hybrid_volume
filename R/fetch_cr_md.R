#' obtain metadata from Crossref
#' required libraries
require(tidyverse)
require(rcrossref)
#' load elsevier price list, only investigate hybrid journals
els_jns_df <- readr::read_csv("data/elsevier_apc_list.csv") %>%
  filter(oa_type == "Hybrid")
#' Call Crossref. First, the publication volume and the various license urls used
jn_facets <- purrr::map(els_jns_df$issn[2:5], .f = purrr::safely(function(x) {
  tt <- rcrossref::cr_works(
    filter = c(
      issn = x,
      from_pub_date = "2013-01-01",
      until_pub_date = "2019-12-31",
      type = "journal-article"
    ),
    # being explicit about facets improves API performance!
    facet = "license:*,published:*,container-title:*,publisher-name:*",
    # less api traffic
    select = "DOI"
  )
  if (!is.null(tt)) {
    tibble::tibble(
      issn = x,
      year_published = list(tt$facets$published),
      license_refs = list(tt$facets$license),
      journal_title = tt$facets$`container-title`$.id[1],
      publisher = tt$facets$publisher$.id[1]
    )
  } else {
    NULL
  }
}))
