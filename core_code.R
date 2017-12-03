# R Script to Encrypt/Decrypt information
# ONLY FOR TRAINING PURPOSES. RISK OF LOOSING INFORMATION. ALWAYS TRY ON DUMMY DATA FIRST
# UDEMY Course: "Cryptography is more fun with R!"
# (C) 2017 Vladimir Zhbanko, vz.home.experiments@gmail.com
# Enjoying the code? Join the course https://udemy.com/keep-secret-under-control

# Used Libraries:
library(openssl)
library(tidyverse)

#### KEY MANAGEMENT ####
# generate your private key (NB: make sure to do back up copy!!!)

  # check if private.key object is not exist...
  if(!file.exists("private.key")){
    rsa_keygen(bits = 2099) %>% 
    # function writes your private key to the file, optional to specify passphrase
    write_pem(path = "private.key", password = "udemy")} else {
      print("You are attempting to overwrite your Private Key. Manually remove your key first!")
    }

