#' obtain metadata from Crossref
#' required libraries
require(tidyverse)
require(rcrossref)
require(jsonlite)
#' load elsevier price list, only investigate hybrid journals
els_jns_df <- readr::read_csv("data/elsevier_apc_list.csv") %>%
  filter(oa_type == "Hybrid")
#' Call Crossref. First, the publication volume and the various license urls will be fetched
jn_facets <- purrr::map(els_jns_df$issn, .f = purrr::safely(function(x) {
  tt <- rcrossref::cr_works(
    filter = c(
      issn = x,
      from_pub_date = "2015-01-01",
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
jn_facets_df <- purrr::map_df(jn_facets, "result") 
#' backup
jsonlite::stream_out(jn_facets_df, file("data/journal_facets.json"))
#' now check for oa licenses
hybrid_licenses <- jn_facets_df %>%
  select(journal_title, publisher, license_refs) %>%
  tidyr::unnest() %>%
  mutate(license_ref = tolower(.id)) %>%
  select(-.id) %>%
  mutate(hybrid_license = ifelse(grepl("creativecommons",
    license_ref), TRUE, FALSE)) %>%
  filter(hybrid_license == TRUE) %>%
  left_join(jn_facets_df, by = c("journal_title" = "journal_title", "publisher" = "publisher"))
#' I now know, whether and which open licenses were used by the journal in the period 
#' 2015:2019.
#' Next, I want to validate that these 
#' licenses were not issued for delayed open access articles by 
#' additionally using  the self-explanatory filter `license.url` 
#' I also obtain parsed metadata for these hybrid open
#'  access articles stored as list-column. metadata fields we pare are 
#'  defined in `cr_md_fields`
cr_md_fields <- c("URL", "member", "created", "license", 
                  "ISSN", "container-title", "issued", "approved", 
                  "indexed", "accepted", "DOI", "funder", "published-print", 
                  "subject", "published-online", "link", "type", "publisher", 
                  "issn-type", "deposited", "content-created")
cr_license <- purrr::map2(hybrid_licenses$license_ref, hybrid_licenses$issn,
                          .f = purrr::safely(function(x, y) {
                            u <- x
                            issn <- y
                            names(issn) <-rep("issn", length(issn))
                            tmp <- rcrossref::cr_works(filter = c(issn, 
                                                                  license.url = u, 
                                                                  type = "journal-article",
                                                                  from_pub_date = "2015-01-01", 
                                                                  until_pub_date = "2019-12-31"),
                                                       cursor = "*", cursor_max = 5000L, 
                                                       limit = 1000L,
                                                       select = cr_md_fields) 
                            tibble::tibble(
                              issn =  list(issn),
                              license = u,
                              md = list(tmp$data)
                            )
                          }))
#' into one data frame!
cr_license_df <- cr_license %>% 
  purrr::map_df("result") 
#' export results, large file, which won't be tracked with GIT
dplyr::bind_rows(cr_license_df) %>% 
  jsonlite::stream_out(file("data/hybrid_license_md.json"))
#' lighter dataset for text mining purposes
tdm_df <- cr_license_df %>% 
  unnest(md) %>% 
  select(link, doi, license, issn, container.title, issued) %>% 
  unnest() 
#' get delayed oa  articles (<= 31 days)
immediate_dois <- cr_license_df %>%
  unnest(md) %>% 
  select(doi, license1) %>% 
  unnest() %>% 
  filter(grepl("creativecommons", URL), delay.in.days <= 31)
tdm_df %>%
  filter(doi %in% immediate_dois$doi) %>%
  write_csv("data/elsevier_hybrid_oa_tdm_links.csv")
