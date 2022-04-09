# R Script to Encrypt information
# ONLY FOR EDUCATIONAL PURPOSES
# UDEMY Course: "Cryptography is more fun with R!"
# (C) 2017,2022 Vladimir Zhbanko,
# Join/Share with https://www.udemy.com/course/keep-your-secrets-under-control/?referralCode=5B78D58E7C06AFFD80AE

### Function Generating Password ###
library(lazytrade)

?util_generate_password

library(stringr)
library(magrittr)
library(openssl)
library(readr)

who_user <-  normalizePath(Sys.getenv('USERPROFILE'), winslash = '/')
dir <- file.path(who_user, 'Documents', 'p.txt')

#generate longer password with special symbols
lazytrade::util_generate_password(salt = 'my random text', pass_len = 10, special_symbols = TRUE) %>% 
  readr::write_csv(dir)

