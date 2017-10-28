# Used Libraries:
library(openssl)
library(tidyverse)


#### ENCRYPT ####
# You can encrypt both using private or public key
# NB: Make sure you have valid copy of Private Key matching your Public Key

pathPrvKeyUSB <- file.path("/Volumes/PRIVATE/private.key")
pathPubKeyUSB <- file.path("/Volumes/PRIVATE/public.key")
pathPasswFILE <- file.path("/Users/Slava1/Desktop/00_RSA", "passwords.csv")
pathEncryFILE <- file.path("/Users/Slava1/Desktop/00_RSA", "password.Encrypted")

## Encrypting the secret and storing that to file "password.Encrypted"
if(identical(read_pubkey(pathPubKeyUSB)$fingerprint,
             read_key(pathPrvKeyUSB, password = "simple")$pubkey$fingerprint)) {
  read_csv(pathPasswFILE) %>% 
    # serialize the object
    serialize(connection = NULL) %>% 
    # encrypt the object
    encrypt_envelope(pathPubKeyUSB) %>% 
    # write encrypted data to File
    write_rds(pathEncryFILE) } else { print("You are attempting to encrypt without having proper copy of Private Key")}

## clean non encrypted file if encrypted file does exist and history...
if(file.exists(pathEncryFILE)) {file.remove(pathPasswFILE)}

## remove variables
remove(list = ls())
