# R Script to Encrypt/Decrypt information
# ONLY FOR TRAINING PURPOSES
# UDEMY Course: "Keep Your Secrets Under Your Control"
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

## Task 1 - Check your File System for the file with Encrypted Information:
# Review code below that will delete object with encrypted information
if(file.exists("PasswordList.Encrypted")){file.remove("PasswordList.Encrypted")}

## Task 2 - Encrypting with 'public.key' - review code
# Encrypt with PUBLIC key may be required when encryption process is executed by your collaborator
read_csv("PasswordsLIST.csv") %>% 
  # serialize the object
  serialize(connection = NULL) %>% 
  # encrypt the object
  encrypt_envelope("public.key") %>% 
  # write encrypted data to File
  write_rds("PasswordList.Encrypted")

## Task 3 - Encrypting with 'private.key' suggested when you encrypt information yourself
# you can reduce risk of loosing information if you encrypt with your private key...
read_csv("PasswordsLIST.csv") %>%
  # serialize the object
  serialize(connection = NULL) %>%
  # encrypt the object, NB: R will interactively ask you password
  encrypt_envelope("private.key") %>%
  # write encrypted data to File
  write_rds("PasswordList.Encrypted")

## Task 4 - Removing original file in clear text if the encrypted object is created
# check first if encrypted data is exist and we have our 'private.key' with us!!!
if(file.exists("PasswordList.Encrypted") &&
   file.exists("private.key")) {file.remove("PasswordsLIST.csv")}

## Task 5 - Encrypt data contained in the object 'mtcars'...
# use provided code snippets and encrypt dataframe 'mtcars'. Name the encrypted file as 'mtcars.Encrypted'
