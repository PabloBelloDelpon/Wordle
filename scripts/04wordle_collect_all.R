library(here)
library(academictwitteR)
library(tidyverse)
source(here("scripts","helper_functions_wordle.R"))

b_token <- readRDS(here("others","academic_bearer_token.RDS"))


res <- count_all_tweets(query = "Wordle",
                        start_tweets =  "2021-12-15T00:00:00Z",
                        end_tweets = "2021-12-16T00:00:00Z",
                        bearer_token = b_token
                                  )






###--- 
start_tweets <-  "2021-12-15T00:00:00Z"
end_tweets <- "2021-12-16T00:00:00Z"
wordle_ids <- c(1:50)
n_tweets <- 100

for(i in wordle_ids) {
  
  tweets <- query_twitter(i,n_tweets,start_tweets = start_tweets,end_tweets = end_tweets)
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


