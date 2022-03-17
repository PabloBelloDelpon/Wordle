library(tidyverse)
library(lubridate)


files <- list.files(here("data"),full.names = TRUE,pattern = ".RDS")


tbl <- 
  files %>% 
  map_dfr(readRDS)


tbl %>%
  mutate(tweet_date = as_date(tweet_date)) %>% 
  count(tweet_date) %>% 
  ggplot(aes(tweet_date,n, group = 1)) +
  geom_line()
  
 