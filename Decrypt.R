# Used Libraries:
library(openssl)
library(tidyverse)


#### DECRYPT ####
# read file with Encrypted Information (from Computer File System to R Environment)
secret_encrypted <- read_rds("password.Encrypted")

# decrypting the list from R Environment
decrypt_envelope(data = secret_encrypted$data,
                 iv = secret_encrypted$iv,
                 session = secret_encrypted$session,
                 key = "private.key",
                 password = "simple") %>% 
  # getting back original object in a form of the data frame
  unserialize() 

# remove secret_encrypted object
rm(secret_encrypted)
