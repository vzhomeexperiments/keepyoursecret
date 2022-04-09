### Productionize this script
# (C) 2017,2022 Vladimir Zhbanko,
# Join/Share with https://www.udemy.com/course/keep-your-secrets-under-control/?referralCode=5B78D58E7C06AFFD80AE

### what about function? ###
generate_password <- function(salt = "Cryptography is cool!", 
                              pass_begin = 3, pass_end = 23, 
                              file_name = "C:/01_RSA/p.txt") {
  require(openssl)
  require(magrittr)
  require(readr)
  
  paste(Sys.Date(), salt) %>% 
    as.character.Date() %>%
    sha512(key = as.character(Sys.time())) %>%
    substring(first = pass_begin, last = pass_end) %>%
    as.data.frame.character() %>%
    write_tsv(file_name)
  print("Password was written to the file C:/01_RSA/p.txt")
}

# using function
generate_password()
