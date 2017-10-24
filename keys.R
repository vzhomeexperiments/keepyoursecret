# Used Libraries:
library(openssl)
library(tidyverse)

#### KEY MANAGEMENT ####
# generate your private key (NB: make sure to do back up copy!!!)
rsa_keygen(bits = 2099) %>% 
  write_pem(path = "private.key", password = "simple")
# generate your public key (NB: optional. Use Private Key to encrypt/decrypt)
read_key(file = "private.key", password = "simple") %>% 
  # extract element of the list and write to file
  `[[`("pubkey") %>% write_pem("public.key")

