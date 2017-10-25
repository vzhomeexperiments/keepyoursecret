# Used Libraries:
library(openssl)
library(tidyverse)


#### ENCRYPT ####
# You can encrypt both using private or public key
# NB: Make sure you have valid copy of Private Key matching your Public Key

pathPrvKeyUSB <- file.path("D:/private.key")
pathPubKeyUSB <- file.path("D:/public.key")

## Encrypting the secret and storing that to file "password.Encrypted"
if(identical(read_pubkey(pathPubKeyUSB)$fingerprint,
             read_key(pathPrvKeyUSB, password = "simple")$pubkey$fingerprint)) {
  read_csv(file.path("C:/00_RSA", "passwords.csv")) %>% 
    # serialize the object
    serialize(connection = NULL) %>% 
    # encrypt the object
    encrypt_envelope(pathPubKeyUSB) %>% 
    # write encrypted data to File
    write_rds(file.path("C:/00_RSA", "password.Encrypted")) } else { print("You are attempting to encrypt without having proper copy of Private Key")}

## remove secret
remove(list = ls())

## clean non encrypted file if encrypted file does exist and history...
if(file.exists(file.path("C:/00_RSA", "password.Encrypted"))) {file.remove(file.path("C:/00_RSA", "passwords.csv"))}