library(tidyverse)
library(hrbrthemes)
wordle_results <- readRDS("~/Desktop/my_stuff/projects/Wordle/wordle_results.RDS")
tweets <- read_csv("tweets.csv")


p1 <- 
  wordle_results %>% 
  mutate(perc_dem = n_dem/(n_dem + n_rep)* 100) %>%
  ggplot(aes(perc_dem)) +
  geom_histogram(bins = 50) +
  theme_modern_rc(plot_title_size = 15,
                 axis_title_size = 14) +
  labs(title = "Politicians' accounts followed by Wordle players",
       y = "Number of  Users",
       x = "Percentage Democrats")

ggsave(plot = p1 , filename = "p1.png",dpi=900)


###---

dates <- 
  tweets %>%
  count(tweet_date) 


dates %>% 
  filter(tweet_date == max(tweet_date) | tweet_date == min(tweet_date))
  arrange(desc(n))

  dates %>% 
  ggplot(aes(tweet_date,n, group = 1)) +
  geom_line()

  
  


# Data
# wordle_tweets <- read_csv("tweets.csv")
# users <- unique(wordle_tweets$tweet_username)
# users <- split(users, ceiling(seq_along(users)/80000))
# key <- 1
# 
# 
# 
# user_profs <- 
#   lapply(users, function(x){
#     
#   token <- set_key(key_n = key,bearer = FALSE) # Create token 
#   print(paste("Using API keys number:", key))
#   users_profiles <- lookup_users(x,token = token)
#   key <<- key + 1
#   
#   return(users_profiles)
#   
# })
# 
# user_profs <- rbindlist(user_profs)
# user_ids <- user_profs$user_id
# saveRDS(user_profs, "wordle_users.RDS")
# 