# ONLY FOR TRAINING PURPOSES
# UDEMY Course: "Keep Your Secrets Under Your Control"
# (C) 2017 Vladimir Zhbanko, vz.home.experiments@gmail.com
# Enjoying the code? Join the course https://udemy.com/keep-secret-under-control

# Used Libraries:
library(openssl)
library(tidyverse)

# Scenario: Information Reciever!!!

# Instructions:
# A. Generate Private and Public Keys
# B. Send your Public Key to info Sender
# C. Once recieved - decrypt information

#### KEY MANAGEMENT ####
# generate your private key (NB: make sure to do back up copy!!!)
rsa_keygen(bits = 2099) %>% 
  write_pem(path = "private.key", password = "simple")
# generate your public key (NB: optional. Use Private Key to encrypt/decrypt)
read_key(file = "private.key", password = "simple") %>% 
  # extract element of the list and write to file
  `[[`("pubkey") %>% write_pem("public.key")


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
