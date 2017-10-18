# R Script to Encrypt/Decrypt information
# ONLY FOR TRAINING PURPOSES. RISK OF LOOSING INFORMATION. ALWAYS TRY ON DUMMY DATA FIRST
# UDEMY Course: "Keep Your Secrets Under Your Control"
# (C) 2017 Vladimir Zhbanko, vz.home.experiments@gmail.com
# Enjoying the code? Join the course https://udemy.com/keep-secret-under-control

# Install packages (uncomment code if necessary)
# install.packages("openssl")
# install.packages("tidyverse")

# Used Libraries:
library(openssl)
library(tidyverse)

#### Create PRIVATE KEY  ####
# generate your private key (NB: make sure to do back up copy!!!)
private_key <- rsa_keygen(bits = 1234)

# understand structure of the private key
str(private_key)

# understand class of the object
class(private_key)

# try using other functions to generate key pairs ec_keygen...
ecKey521 <- ec_keygen(curve = "P-521")
ecKey384 <- ec_keygen(curve = "P-384")
ecKey256 <- ec_keygen(curve = "P-256")

# study structure of those keys...
str(ecKey256)
str(ecKey384)
str(ecKey521)

# try using other functions to generate key pairs dsa_keygen...
dsaKey1024 <- dsa_keygen(bits = 1024)
dsaKey2024 <- dsa_keygen(bits = 2024)

# structure of these file
str(dsaKey1024)
str(dsaKey2024)

#### Create PRIVATE KEY and write it to R-Project File System ####
# generate your private key (NB: make sure to do back up copy!!!)
rsa_keygen(bits = 1234) %>% 
  # function writes your private key to the file, optional to specify passphrase
  write_pem(path = "private.key", password = "udemy")


