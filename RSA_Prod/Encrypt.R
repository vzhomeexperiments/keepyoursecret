# R Script to Encrypt information
# ONLY FOR EDUCATIONAL PURPOSES
# UDEMY Course: "Cryptography is more fun with R!"
# (C) 2017,2022 Vladimir Zhbanko,
# Join/Share with https://www.udemy.com/course/keep-your-secrets-under-control/?referralCode=5B78D58E7C06AFFD80AE

# Used Libraries:
library(openssl)
library(magrittr)
library(readr)

#### ENCRYPT ####
# You can encrypt both using private or public key
# NB: Make sure you have valid copy of Private Key matching your Public Key

# Place csv file with information to encrypt 'reserved.csv' to the folder Documents

who_user <-  normalizePath(Sys.getenv('USERPROFILE'), winslash = '/')

pathPrvKeyUSB <- file.path("F:/private.key")
pathPubKeyUSB <- file.path("F:/public.key")
pathPasswFILE <- file.path(who_user, "Documents", "reserved.csv")
pathEncryFILE <- file.path(who_user, "Documents", "reserved.encr")
pathEncryBCKP <- file.path("G:/My Drive/0_reservedbackup/reserved.encr")

## Encrypting the secret and storing that to file "password.Encrypted"
if(identical(read_pubkey(pathPubKeyUSB)$fingerprint,
             read_key(pathPrvKeyUSB, password = "")$pubkey$fingerprint)) {
  read_csv(pathPasswFILE) %>% 
    # serialize the object
    serialize(connection = NULL) %>% 
    # encrypt the object
    encrypt_envelope(pathPubKeyUSB) %>% 
    # write encrypted data to File
    write_rds(pathEncryFILE) } else { print("You are attempting to encrypt without having proper copy of Private Key")}

## clean non encrypted file if encrypted file does exist and history...
if(file.exists(pathEncryFILE)) {
  # keeping copy of encrypted data in G.Drive Folder
  file.copy(pathEncryFILE, pathEncryBCKP, overwrite = TRUE)
  # removing local file
  file.remove(pathPasswFILE)}

## remove secret
remove(list = ls())
