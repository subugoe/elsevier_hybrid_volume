library(tidyverse)
#' extract domains
library(urltools)
els_df <- readr::read_csv("data/elsevier_oa_info.csv")
emails_df <- els_df %>%
  mutate(email = tolower(email)) %>%
  #filter(!is.na(email)) %>% 
  mutate(domain = map_chr(email, function(x) str_split(x, "@") %>% 
                            unlist() %>% 
                            tail(1)))
mail_split <- urltools::suffix_extract(emails_df$domain) %>%
  inner_join(emails_df, by = c("host" = "domain")) %>%
  distinct() %>%
  mutate(tld = tld_extract(host)$tld) %>%
  select(-email)
#' add bibliographic metadata
elsevier_md <- readr::read_csv("data/elsevier_hybrid_oa_tdm_links.csv") %>%
  inner_join(mail_split, by = c("URL" = "tdm_url")) %>%
  mutate(issued_normalized = lubridate::parse_date_time(issued, c('y', 'ymd', 'ym'))) %>%
  mutate(issued_year = lubridate::year(issued_normalized))
#' backup
write_csv(elsevier_md, "data/els_hybrid_info_normalized.csv")
