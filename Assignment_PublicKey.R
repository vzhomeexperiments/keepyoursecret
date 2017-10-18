# R Script to Encrypt/Decrypt information
# ONLY FOR TRAINING PURPOSES
# UDEMY Course: "Keep Your Secrets Under Your Control"
# (C) 2017 Vladimir Zhbanko, vz.home.experiments@gmail.com
# Enjoying the code? Join the course https://udemy.com/keep-secret-under-control

# Used Libraries:
library(openssl)
library(tidyverse)

#### KEY MANAGEMENT ####

# Public Key is a part of the Private Key...

## Task 1 - Read your Private Key from the file
# check if private.key object is not exist and create a new private.key
if(!file.exists("private.key")){
  rsa_keygen(bits = 2099) %>% 
    # function writes your private key to the file, optional to specify passphrase
    write_pem(path = "private.key", password = "udemy")} else {
      print("You are attempting to overwrite your Private Key. Manually remove your key first!")
    }

# read your file 'private.key' and assign it to the object private_key:
private_key <- read_key(file = "...", password = "...") 

## Task 2 - Review the structure of the Private Key
# use function str() to reveal structure of the object 'private_key'
str(...)

## Task 3 - Visualize 'hash' or fingerprint of your UNIQUE private key
# simply type object 'private_key' and execute code by presseing CTRL/CMD + ENTER


# store this fingerprint to the variable 'hash'
hash <- private_key$

# this element 'hash' will help us later to manager our keys. We must make sure that we are managing our keys in a sound order!!!
hash

## Task 4 - Extract Public Key from our Private Key
# extract element '$pubkey' of the private_key and assign it to the 'public_key' object
public_key <- private_key$

# review structure of that public key
str(public_key)

## Task 5 - Write Public Key object 'public_key' to the file named 'public.key'
# use function write_pem() provide required arguments...
write_pem(..., "...")

## Task 6 - Review code generating 'public.key' file in 'one liner'
# notice that with the 'pipe' element '%>%' you can create your 'public.key' file without generating 'private_key' object
read_key(file = "private.key", password = "udemy") %>% `[[`("pubkey") %>% write_pem("public.key")

## Task 7 - Clear R Environment!
# Don't forget to clear your environment from passwords, etc
remove(list = ls())

# Delete .History file if present
# Clean Console by clicking on console and typing CTRL+L
# Clean History tab
