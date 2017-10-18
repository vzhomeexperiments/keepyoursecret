# R Script to Encrypt/Decrypt information
# ONLY FOR TRAINING PURPOSES
# UDEMY Course: "Keep Your Secrets Under Your Control"
# (C) 2017 Vladimir Zhbanko, vz.home.experiments@gmail.com
# Enjoying the code? Join the course https://udemy.com/keep-secret-under-control

# Used Libraries:
library(openssl)
library(tidyverse)

# -------------------------------------------------------------------------------------------
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
# -------------------------------------------------------------------------------------------

# -------------------------------------------------------------------------------------------
#### ENCRYPT (from previous lectures) ####
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
# -------------------------------------------------------------------------------------------

# -------------------------------------------------------------------------------------------
#### DECRYPT ####

## Task 1 - read your encrypted secret object 'mtcars.Encrypted'.
# read file with encrypted information to R Environment, assign it to the object 
secret_encrypted <- read_rds("mtcars.Encrypted")

## Task 2 - review what is inside this object
# view the structure of the object 'secret_encrypted' with str() function
str(secret_encrypted)

## Task 3 - decrypt this object with 'private.key' file
# provide required arguments to the function decrypt_envelope()
secret_serialized <- decrypt_envelope(data = secret_encrypted$data,
                                      iv = secret_encrypted$iv,
                                      session = secret_encrypted$session,
                                      key = "private.key",
                                      password = "udemy") 

## Task 4 - Unserialize the object
# Use function unserialize() and assign the result to the object secret_mtcars
secret_mtcars <- unserialize(secret_serialized) 

## Task 5 - Compare objects: are they identical?
# use function identical() to compare the two objects
identical(mtcars, secret_mtcars)

# -------------------------------------------------------------------------------------------
