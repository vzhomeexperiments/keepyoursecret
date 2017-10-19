# R Script to Encrypt/Decrypt information
# ONLY FOR TRAINING PURPOSES
# UDEMY Course: "Keep Your Secrets Under Your Control"
# (C) 2017 Vladimir Zhbanko, vz.home.experiments@gmail.com
# Enjoying the code? Join the course https://udemy.com/keep-secret-under-control

# Used Libraries:
library(openssl)
library(tidyverse)

## Task 1 - Place required objects into R Project Folder (alternatively use Lecture10 branch)
# provided public, private keys

## Task 2 - Check presence of Public Key in the R Project Folder
# Use function file.exists() to verify if file 'public.key' does exist
file.exists("public.key")

# do the same for the 'private.key'
file.exists("private.key")

## Task 3 - Create dummy data object
# Assign to 'DummyData' content of 'mtcars' dataframe
DummyData <- mtcars

## Task 4 - Encrypt your 'DummyData'
# Use available 'public.key' file and create encrypted object 'dummy.Encrypted'
DummyData %>% 
  # serialize the object
  serialize(connection = NULL) %>% 
  # encrypt the object
  encrypt_envelope("public.key") %>% 
  # write encrypted data to File
  write_rds("dummy.Encrypted")

## Task 5 - Delete 'SuperSecret' non encrypted info object 'DummyData'
# Use function 'remove()' or 'rm()' to delete object from R Environment
rm(DummyData)

## Task 6 - Attempt to Decrypt 'dummy.Encrypted
# use code snippet to decrypt the object
secret_encrypted <- read_rds("dummy.Encrypted")

# decrypting the list from R Environment
DummyData <- decrypt_envelope(data = secret_encrypted$data,
                 iv = secret_encrypted$iv,
                 session = secret_encrypted$session,
                 key = "private.key",
                 password = "udemy") %>% 
  # getting back original object in a form of the data frame
  unserialize() 

# remove secret_encrypted object
rm(secret_encrypted)




# ------------------------------------------------------------------------------------
#### KEY MANAGEMENT ####
# generate your private key (NB: make sure to do back up copy!!!)
rsa_keygen(bits = 2099) %>% 
  write_pem(path = "private.key", password = "udemy")
# generate your public key (NB: optional. Use Private Key to encrypt/decrypt)
read_key(file = "private.key", password = "udemy") %>% 
  # extract element of the list and write to file
  `[[`("pubkey") %>% write_pem("public.key")

# ------------------------------------------------------------------------------------
#### ENCRYPT ####
# You can encrypt both using private or public key
# NB: Make sure you have valid copy of Private Key matching your Public Key

# before running code we remove encrypted information
if(file.exists("PasswordList.Encrypted")){file.remove("PasswordList.Encrypted")}

## Encrypt with PUBLIC key (e.g. send this code to collaborator)
read_csv2("PasswordList.csv") %>% 
  # serialize the object
  serialize(connection = NULL) %>% 
  # encrypt the object
  encrypt_envelope("public.key") %>% 
  # write encrypted data to File
  write_rds("PasswordList.Encrypted")

## Encrypt with PRIVATE key (e.g. use this code yourself)
read_csv2("PasswordList.csv") %>% 
  # serialize the object
  serialize(connection = NULL) %>% 
  # encrypt the object
  encrypt_envelope("private.key") %>% 
  # write encrypted data to File
  write_rds("PasswordList.Encrypted")


# NB: remove original file with secrets
# check first if encrypted data is exist
if(file.exists("PasswordList.Encrypted")) {file.remove("PasswordList.csv")}

# ------------------------------------------------------------------------------------
#### DECRYPT ####
# read file with Encrypted Information (from Computer File System to R Environment)
secret_encrypted <- read_rds("PasswordList.Encrypted")

# decrypting the list from R Environment
decrypt_envelope(data = secret_encrypted$data,
                 iv = secret_encrypted$iv,
                 session = secret_encrypted$session,
                 key = "private.key",
                 password = "udemy") %>% 
  # getting back original object in a form of the data frame
  unserialize() %>% 
  # write dataframe to the csv file
  write_csv("PasswordList.csv")

# remove secret_encrypted object
rm(secret_encrypted)
