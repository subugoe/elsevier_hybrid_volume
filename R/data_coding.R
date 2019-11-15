# create the main dataset
library(tidyverse)
library(jsonlite)
hybrid_df <- readr::read_csv("data/els_hybrid_info_normalized.csv") %>%
  mutate(issued_year = as.character(issued_year))
cr_facets <- jsonlite::stream_in(file("data/journal_facets.json"), verbose = FALSE)

hybrid_all<- cr_facets %>%
  unnest(year_published) %>%
  rename(year = .id, article_volume = V1) %>%
  filter(year > 2014) %>%
  distinct(issn, year, article_volume, journal_title) %>%
  right_join(hybrid_df, by = c("issn", "year" = "issued_year")) 
# data coding
hybrid_all %>%
  select(doi, license, issued, issued_year = year, 
         issn, journal_title, journal_volume = article_volume,
         tdm_link = URL, oa_sponsor_type, oa_sponsor_name, oa_archive,
         host, tld, suffix, domain, subdomain) %>% 
  write_csv("data/elsevier_hybrid_oa_df.csv")

