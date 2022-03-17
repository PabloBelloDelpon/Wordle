library(tidyverse)
library(here)
library(data.table)
source(here("scripts","helper_functions_wordle.R"))



###--- Set up 
# 1st of january was wordle 195
wordle_ids <- 100:270
n_tweets <- 10000# Number of tweets per day/wordle id

###--- 
done <- list.files(here("data"))
done <- done[str_detect(done,".RDS")]
done <- str_remove(done,"wordle_")
done <- as.integer(str_remove(done,".RDS"))
wordle_ids <- wordle_ids[!wordle_ids %in% done]


###--- Loop over ids/days

for(i in wordle_ids) {
  
  tweets <- query_twitter(i,n_tweets)
  valid_wordle <- is_valid_wordle_tweet(tweets$text,i)
  tweets <- tweets[valid_wordle == TRUE,]
  tweets <- 
    tweets %>% 
    select(tweet_id = id, 
           tweet_date = created_at, 
           user_id = author_id, 
           tweet_text = text) %>% 
    mutate(wordle_id = i,
           collected_at = Sys.time())
  
  save_to <- here("data",paste0("wordle_",i,".RDS"))
  saveRDS(tweets, save_to)
  print(paste("Finished with wordle:", i))
  
  if(i %% 10 == 0) {gc()}
}


