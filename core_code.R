# R Script to Encrypt/Decrypt information
# ONLY FOR TRAINING PURPOSES. RISK OF LOOSING INFORMATION. ALWAYS TRY ON DUMMY DATA FIRST
# UDEMY Course: "Cryptography is more fun with R!"
# (C) 2017 Vladimir Zhbanko, vz.home.experiments@gmail.com
# Enjoying the code? Join the course https://udemy.com/keep-secret-under-control

# Used Libraries:
library(openssl)
library(tidyverse)

#### KEY MANAGEMENT (from previous lectures) ####

# check if private.key object is not exist...
if(!file.exists("private.key")){
  rsa_keygen(bits = 2099) %>% 
    # function writes your private key to the file, optional to specify passphrase
    write_pem(path = "private.key", password = "udemy")} else {
      print("You are attempting to overwrite your Private Key. Manually remove your key first!")
    }

# generate your public key (NB: optional. Use Private Key to encrypt/decrypt)
read_key(file = "private.key", password = "udemy") %>% 
  # extract element of the list and write to file
  `[[`("pubkey") %>% write_pem("public.key")

#### ENCRYPT ####
# You can encrypt both using private or public key
# NB: Make sure you have valid copy of Private Key matching your Public Key

# before running code we remove encrypted information
if(file.exists("PasswordList.Encrypted")){file.remove("PasswordList.Encrypted")}

## Encrypt with PUBLIC key (e.g. send this code to collaborator)
read_csv("PasswordsLIST.csv") %>% 
  # serialize the object
  serialize(connection = NULL) %>% 
  # encrypt the object
  encrypt_envelope("public.key") %>% 
  # write encrypted data to File
  write_rds("PasswordList.Encrypted")

# ## Encrypt with PRIVATE key (e.g. use this code yourself)
# read_csv("PasswordsLIST.csv") %>% 
#   # serialize the object
#   serialize(connection = NULL) %>% 
#   # encrypt the object, NB: R will interactively ask you password
#   encrypt_envelope("private.key") %>% 
#   # write encrypted data to File
#   write_rds("PasswordList.Encrypted")


# NB: remove original file with secrets
# check first if encrypted data is exist
if(file.exists("PasswordList.Encrypted")) {file.remove("PasswordsLIST.csv")}

