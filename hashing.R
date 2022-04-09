# hash - generating random passwords
# (C) 2017,2022 Vladimir Zhbanko,
# Join/Share with https://www.udemy.com/course/keep-your-secrets-under-control/?referralCode=5B78D58E7C06AFFD80AE
library(openssl)
library(magrittr)
library(readr)

# check help
?openssl::hashing

# this is 'googleable' what you should not do!
"john" %>% sha512()

# generate password string without a key can be risky
"specific string" %>% sha512()

# generate password string the way you can reproduce and more secure
"specific string" %>% sha512(key = "123456")

# generate unique password, introducing randomness of the current time (you must know exact date and exact time to reproduce)
paste(Sys.Date(), "Cryptography is more fun using R!") %>% as.character.Date() %>% sha512(key = as.character(Sys.time()))

# generate password but take your desired piece start/end position and write to the file
Sys.Date() %>% as.character.Date() %>% sha512(key = as.character(Sys.time())) %>%
  substring(first = 3, last = 23) %>% as.data.frame.character() %>%   write_tsv("p.txt")

### what about function? ###
generate_password <- function(salt = "Cryptography is cool!", pass_begin = 3, pass_end = 23, file_name = "p.txt") {
  require(openssl)
  require(tidyverse)
  paste(Sys.Date(), salt) %>% 
    as.character.Date() %>%
    sha512(key = as.character(Sys.time())) %>%
    substring(first = pass_begin, last = pass_end) %>%
    as.data.frame.character() %>%
    write_tsv(file_name)
  print("Password was written to the file: p.txt")
}

# using function
generate_password()

