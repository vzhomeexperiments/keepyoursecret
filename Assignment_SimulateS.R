# R Script to Encrypt/Decrypt information
# ONLY FOR TRAINING PURPOSES
# UDEMY Course: "Cryptography is more fun with R!"
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

## Task 7 - Verify if provided public.key is the one corresponding to your private.key
# read both keys and extract objects
public_keyI <- read_key("private.key", "udemy")$pubkey
public_keyV <- read_pubkey("public.key")
# identicality check
identical(public_keyI, public_keyV)

## Task 8 - Find what is exactly different
# use $fingerprint of the list to find out...
public_keyI$fingerprint
public_keyV$fingerprint

