#' tdm oa fulltext foroa sponsorhip info
#' required libraries
require(tidyverse)
require(crminer)
library(xml2)
hybrid_df <- readr::read_csv("data/elsevier_hybrid_oa_tdm_links.csv")  
elsevier_tdm <- hybrid_df %>%
  filter(content.type == "text/xml",
         intended.application == "text-mining",
         content.version == "vor") -> elsevier_tdm
elsevier_tdm %>%
  sample_n(100) %>%
  .$URL -> sample_urls
#' defining a parsing function
elsevier_parse <- function(tdm_url) {
  req <- crminer::crm_xml(tdm_url)
  email <- xml2::xml_find_first(req, "//ce:e-address") %>% 
    xml2::xml_text()
  oa_sponsor_name <- xml2::xml_find_first(req, "//d1:coredata//d1:openaccessSponsorName") %>% 
    xml2::xml_text()
  oa_sponsor_type <- xml2::xml_find_first(req, "//d1:coredata//d1:openaccessSponsorType") %>% 
    xml2::xml_text()
  oa_article <- xml2::xml_find_first(req, "//d1:coredata//d1:openaccessArticle") %>% 
    xml2::xml_text()
  oa_type <- xml2::xml_find_first(req, "//d1:coredata//d1:openaccessType") %>% 
    xml2::xml_text()
  oa_archive <- xml2::xml_find_first(req, "//d1:coredata//d1:openArchiveArticle") %>% 
    xml2::xml_text()
  data_frame(email,
                      oa_sponsor_name, oa_sponsor_type, oa_article, oa_type, oa_archive, 
                      tdm_url)
}
#' call and mine
elsevier_oa_info <- purrr::map(elsevier_tdm$URL, .f = purrr::safely(elsevier_parse))
elsevier_oa_info_df <- purrr::map_df(elsevier_oa_info, "result")
#' backup
write_csv(elsevier_oa_info_df, "data/elsevier_oa_info.csv")
#' redo mining for updated dois
elsevier_old <- read_csv("data/elsevier_oa_info.csv")
hybrid_df <- readr::read_csv("data/elsevier_hybrid_oa_tdm_links.csv")  
elsevier_tdm <- hybrid_df %>%
  filter(content.type == "text/xml",
         intended.application == "text-mining",
         content.version == "vor") %>% 
  filter(!URL %in% elsevier_old$tdm_url)
elsevier_oa_update <- purrr::map(elsevier_tdm$URL, .f = purrr::safely(elsevier_parse))
elsevier_oa_update_df <- purrr::map_df(elsevier_oa_update, "result")
bind_rows(elsevier_old, elsevier_oa_update_df) %>% 
  write_csv("data/elsevier_oa_info.csv")

