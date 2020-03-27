#install stuff do not run unless first time and you dont have the libraries
install.packages("remotes")
remotes::install_github("rstudio/tensorflow")
library(tensorflow)
install_tensorflow()
install.packages("keras")
install.packages("tfdatasets")
install.packages("tidyverse")
install.packages("rsample")
install.packages("pins")
install.packages("Metrics")
install.packages("haven")


#setup libary
library(tensorflow)
install_tensorflow()
library(tensorflow)
tf$abs(-1)
library(keras)
library(tfdatasets)
library(tidyverse)
library(rsample)
library(pins)
library(Metrics)

caravan_insurance_challenge <- read_sas("Rstudio data/import.sas7bdat", )
#Split data and then remove orgin from tables
df <- caravan_insurance_challenge


split <- split(df, df$ORIGIN)
train <- subset(split$train, select = -c(ORIGIN) )
test <- subset(split$test, select = -c(ORIGIN) )

# then we split the training set into validation and training
split <- initial_split(train, prop = 4/5)
train <- training(split)
val <- testing(split)

#Create an input pipeline using tfdatasets 
df_to_dataset <- function(df, shuffle = TRUE, batch_size = 64) {
  ds <- df %>% 
    tensor_slices_dataset()
  
  if (shuffle)
    ds <- ds %>% dataset_shuffle(buffer_size = nrow(df))
  
  ds %>% 
    dataset_batch(batch_size = batch_size)
}

batch_size <- 5
train_ds <- df_to_dataset(train, batch_size = batch_size)
val_ds <- df_to_dataset(val, shuffle = FALSE, batch_size = batch_size)
test_ds <- df_to_dataset(test, shuffle = FALSE, batch_size = batch_size)

train_ds %>% 
  reticulate::as_iterator() %>% 
  reticulate::iter_next() %>% 
  str()

#Create the feature spec
spec <- spec <- feature_spec(train_ds, CARAVAN ~ .) 
step_numeric_column(
  all_numeric(),
  normalizer_fn = scaler_standard()
) %>% 

spec_prep <- fit(spec)
# error I get where I'm lost in how to fix it 
#| Preparing 72 batches/s [932 batches in 00:00:12]Error in step_numeric_column(all_numeric(), normalizer_fn = scaler_standard()) %>%  : 
#invalid (NULL) left side of assignment

