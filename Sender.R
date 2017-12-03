# ONLY FOR TRAINING PURPOSES
# UDEMY Course: "Keep Your Secrets Under Your Control"
# (C) 2017 Vladimir Zhbanko, vz.home.experiments@gmail.com
# Enjoying the code? Join the course https://udemy.com/keep-secret-under-control

# Used Libraries:
library(openssl)
library(tidyverse)

# Scenario: Information Sender!!!

# Instructions:
# A. Get Public Key
# B. Encrypt Password
# C. Send 'password.Encrypted'

#### ENCRYPT ####
# You can encrypt both using private or public key
# NB: Make sure you have valid copy of Private Key matching your Public Key

## WHAT YOU WANT TO ENCRYPT???
secret <- "Pass-Word-1234"

  secret %>% 
    # serialize the object
    serialize(connection = NULL) %>% 
    # encrypt the object
    encrypt_envelope("public.key") %>% 
    # write encrypted data to File
    write_rds("password.Encrypted") 
  
## remove secret
remove(list = ls())

## clean console and history...