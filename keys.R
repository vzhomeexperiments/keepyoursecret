# Used Libraries:
library(openssl)
library(tidyverse)

#### KEY MANAGEMENT ####
# save that to USB Key (Windows)
pathPrvKeyUSB <- file.path("D:/private.key")
pathPubKeyUSB <- file.path("D:/public.key")
# generate your private key (NB: make sure to do back up copy!!!)
rsa_keygen(bits = 2099) %>% 
  write_pem(path = pathPrvKeyUSB, password = "simple")
# generate your public key (NB: optional. Use Private Key to encrypt/decrypt)
read_key(file = pathPrvKeyUSB, password = "simple") %>% 
  # extract element of the list and write to file
  `[[`("pubkey") %>% write_pem(pathPubKeyUSB)

