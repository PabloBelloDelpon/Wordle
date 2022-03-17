### WORDLE HELPER FUNCTIONS 

###--- Query the academic twitter API
library(academictwitteR)
b_token <- readRDS(here("others","academic_bearer_token.RDS"))

query_twitter <- function(id, n) {
  suppressWarnings(
  tibble(academictwitteR::get_all_tweets(query = paste("Wordle", id," "),
                                         exact_phrase = TRUE,
                                         start_tweets =  "2021-09-20T00:00:00Z",
                                         end_tweets = "2022-03-17T00:00:00Z",
                                         bearer_token = b_token,
                                         n = n, 
                                         is_retweet = FALSE, 
                                         is_quote = FALSE,
                                         is_reply = FALSE
  )))
}

###--- Filter garbage tweets that are not Wordles

is_valid_wordle_tweet <- function(tweet, wordle_id) {
  tweet <- str_replace_all(tweet, "Y", "y")
  tweet <- str_replace_all(tweet, "🟩", "Y")
  
  tweet <- str_replace_all(tweet, "M", "m")
  tweet <- str_replace_all(tweet, "🟨", "M")
  
  tweet <- str_replace_all(tweet, "N", "n")
  tweet <- str_replace_all(tweet, "⬜", "N")
  tweet <- str_replace_all(tweet,"⬛", "N")
  
  
  # a <- wordle_id - 20
  # b <- wordle_id + 20
  # c <- sapply(a:b, function(i){
  #   str_detect(tweet,as.character(i))
  # })
  
  # if(sum(c) != 1) {
  #   return(FALSE)
  # }
  
  test1 <- str_detect(tweet, paste0("Wordle ", wordle_id," "))
  test2 <- str_detect(tweet, "Wordle \\d+ [2-6]/6\n\n([YMN]){5}\n")
  
  test_df <- cbind(test1,test2)
  
  return(rowSums(test_df) == 2)
}



###--- Set up an access key for twitter
read_quiet <- quietly(read_csv)
set_key <- function(key_n, bearer = TRUE) {
  
  secrets <- read_quiet("/Users/pablobellodelpon/Desktop/IAS/Social Influence/data/tokens/secrets.csv")
  secrets <- secrets$result
  api_key <- secrets[key_n,]$api_key
  api_secret_key <- secrets[key_n,]$api_secret_key
  access_token <- secrets[key_n,]$access_token
  access_secret <- secrets[key_n,]$access_secret
  
  
  # Create the token
  token <- rtweet::create_token(
    consumer_key = api_key,
    consumer_secret = api_secret_key,
    access_token = access_token,
    access_secret = access_secret,
    set_renv = FALSE)
  
  if(bearer == TRUE) {
    token <- rtweet::bearer_token(token)
  }
  
  return(token)
  
}