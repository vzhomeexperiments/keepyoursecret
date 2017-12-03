# ONLY FOR TRAINING PURPOSES
# UDEMY Course: "Cryptography is more fun with R!"
# (C) 2017 Vladimir Zhbanko, vz.home.experiments@gmail.com
# Enjoying the code? Join the course https://udemy.com/keep-secret-under-control

# Used Libraries:
library(openssl)
library(tidyverse)


#### ENCRYPT ####
# You can encrypt both using private or public key
# NB: Make sure you have valid copy of Private Key matching your Public Key

## WHAT YOU WANT TO ENCRYPT???
secret <- "Pass-Word-1234"

## Encrypting the secret and storing that to file "password.Encrypted"
if(identical(read_pubkey("public.key")$fingerprint,
             read_key("private.key", password = "simple")$pubkey$fingerprint)) {
  secret %>% 
    # serialize the object
    serialize(connection = NULL) %>% 
    # encrypt the object
    encrypt_envelope("public.key") %>% 
    # write encrypted data to File
    write_rds("password.Encrypted") } else { print("You are attempting to encrypt without having proper copy of Private Key")}

## remove secret
remove(list = ls())

## clean console and history...