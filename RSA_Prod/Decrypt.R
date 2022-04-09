# R Script to Decrypt information
# ONLY FOR EDUCATIONAL PURPOSES
# UDEMY Course: "Cryptography is more fun with R!"
# (C) 2017,2022 Vladimir Zhbanko,
# Join/Share with https://www.udemy.com/course/keep-your-secrets-under-control/?referralCode=5B78D58E7C06AFFD80AE

# Used Libraries:
library(openssl)
library(magrittr)
library(readr)


#### DECRYPT ####
# path to keys on USB Stick

who_user <-  normalizePath(Sys.getenv('USERPROFILE'), winslash = '/')

pathPrvKeyUSB <- file.path("F:/private.key")
pathPubKeyUSB <- file.path("F:/public.key")
pathPasswFILE <- file.path(who_user, "Documents", "reserved.csv")
pathEncryFILE <- file.path(who_user, "Documents", "reserved.encr")
pathEncryBCKP <- file.path("G:/My Drive/0_reservedbackup/reserved.encr")

# read file with Encrypted Information (from Computer File System to R Environment)
if(file.exists(pathEncryFILE)) {
	secret_encrypted <- read_rds(pathEncryFILE)
	} else {
	# attempt to use file from backup folder
	secret_encrypted <- read_rds(pathEncryBCKP)		   
	}

# decrypting the list from R Environment
decrypt_envelope(data = secret_encrypted$data,
                 iv = secret_encrypted$iv,
                 session = secret_encrypted$session,
                 key = pathPrvKeyUSB,
                 password = "") %>% 
  # getting back original object in a form of the data frame
  unserialize() %>% 
  # writing file back
  write_csv(pathPasswFILE)

# remove encrypted object
if(file.exists(pathPasswFILE)) {
	
	file.remove(pathEncryFILE)}

# remove secret_encrypted object
rm(secret_encrypted)
