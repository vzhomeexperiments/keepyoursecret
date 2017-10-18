# R Script to Encrypt/Decrypt information
# ONLY FOR TRAINING PURPOSES
# UDEMY Course: "Keep Your Secrets Under Your Control"
# (C) 2017 Vladimir Zhbanko, vz.home.experiments@gmail.com
# Enjoying the code? Join the course https://udemy.com/keep-secret-under-control

# Used Libraries:
library(openssl)
library(tidyverse)

#### KEY MANAGEMENT ####
# generate your private key (NB: make sure to do back up copy!!!)
rsa_keygen(bits = 2099) %>% 
  write_pem(path = "private.key", password = "udemy")


# generate your public key (NB: optional. Use Private Key to encrypt/decrypt)
read_key(file = "private.key", password = "udemy") %>% 
  # extract element of the list and write to file
  `[[`("pubkey") %>% write_pem("public.key")
