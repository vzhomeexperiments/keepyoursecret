# generating keys with openssl
# ONLY FOR TRAINING PURPOSES
# UDEMY Course: "Cryptography is more fun with R!"
# (C) 2017 Vladimir Zhbanko, vz.home.experiments@gmail.com
# Enjoying the code? Join the course https://udemy.com/keep-secret-under-control
# library openssl
library(openssl)

## ========== KEY Management ============
# generates the private key
key <- rsa_keygen(bits = 2048)
# write key to the text file
write_der(key, "key.me")
# OPTION1: save this file to the local machine and distribute to the users, let them load file when using app
# OPTION2: keep this file in the project folder (not be compliant...)

# this generates public key from the private one
pubkey <- as.list(key)$pubkey

# Removes private key from the Environment
rm(key)

## ========== ENCRYPT Password //Run this procedure every 3 months// =========
# add password, run the line and delete the string...
password <- "66666"

# serialize and encrypt the password
out <- encrypt_envelope(serialize(password, NULL), pubkey)

# write the list to the server folder (this is containing ecrypted data)
saveRDS(out, file = "public.data")

# remove password, ecrypted data and public key from environment
rm(password, out, pubkey)

## =========== DECRYPT
# OPTION2: read the key from the folder
# read file with data from file //place this code to the server script
out <- readRDS("public.data")
# decrypted password
orig <- unserialize(decrypt_envelope(out$data, out$iv, out$session, read_key("key.me",der = TRUE)))

# OPTION1: read the provided file from the user, use Shiny inputFile Function
