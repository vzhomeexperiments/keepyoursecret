# ONLY FOR TRAINING PURPOSES
# UDEMY Course: "Cryptography is more fun with R!"
# (C) 2017 Vladimir Zhbanko, vz.home.experiments@gmail.com
# Enjoying the code? Join the course https://udemy.com/keep-secret-under-control

# Used Libraries:
library(openssl)
library(tidyverse)


#### DECRYPT ####
# path to keys on USB Stick
pathPrvKeyUSB <- file.path("D:/private.key")
pathPubKeyUSB <- file.path("D:/public.key")

# read file with Encrypted Information (from Computer File System to R Environment)
secret_encrypted <- read_rds(file.path("C:/00_RSA", "password.Encrypted"))

# decrypting the list from R Environment
decrypt_envelope(data = secret_encrypted$data,
                 iv = secret_encrypted$iv,
                 session = secret_encrypted$session,
                 key = pathPrvKeyUSB,
                 password = "simple") %>% 
  # getting back original object in a form of the data frame
  unserialize() %>% 
  # writing file back
  write_csv(file.path("C:/00_RSA", "passwords.csv"))

# remove encrypted object
if(file.exists(file.path("C:/00_RSA", "passwords.csv"))) {file.remove(file.path("C:/00_RSA", "password.Encrypted"))}

# remove secret_encrypted object
rm(secret_encrypted)
