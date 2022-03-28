library(tidyverse)
library(here)
library(data.table)
source(here("scripts","helper_functions_wordle.R"))



###--- Set up 
# 1st of january was wordle 195
wordle_ids <- 100:270
n_tweets <- 10000# Number of tweets per day/wordle id
start_tweets =  "2021-09-20T00:00:00Z"
end_tweets = "2022-03-17T00:00:00Z"
###--- 
done <- list.files(here("data"))
done <- done[str_detect(done,".RDS")]
done <- str_remove(done,"wordle_")
done <- as.integer(str_remove(done,".RDS"))
wordle_ids <- wordle_ids[!wordle_ids %in% done]


###--- Loop over ids/days

for(i in wordle_ids) {
  
  tweets <- query_twitter(i,n_tweets,start_tweets,end_tweets)
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




i_now <- 280
now <- as.Date("2022-03-26")
start <- as.Date("2021-12-15")

diff <- now - start
i_start <- i_now - as.numeric(diff)
