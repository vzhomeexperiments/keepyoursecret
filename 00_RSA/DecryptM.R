# Used Libraries:
library(openssl)
library(tidyverse)

#### DECRYPT ####
# path to keys on USB Stick
pathPrvKeyUSB <- file.path("/Volumes/PRIVATE/private.key")
pathPubKeyUSB <- file.path("/Volumes/PRIVATE/public.key")
pathPasswFILE <- file.path("/Users/Slava1/Desktop/00_RSA", "passwords.csv")
pathEncryFILE <- file.path("/Users/Slava1/Desktop/00_RSA", "password.Encrypted")

# read file with Encrypted Information (from Computer File System to R Environment)
secret_encrypted <- read_rds(pathEncryFILE)

# decrypting the list from R Environment
decrypt_envelope(data = secret_encrypted$data,
                 iv = secret_encrypted$iv,
                 session = secret_encrypted$session,
                 key = pathPrvKeyUSB,
                 password = "simple") %>% 
  # getting back original object in a form of the data frame
  unserialize() %>% 
  # writing file back
  write_csv(pathPasswFILE)

# remove encrypted object
if(file.exists(pathPasswFILE)) {file.remove(pathEncryFILE)}

# remove secret_encrypted object
rm(secret_encrypted)
