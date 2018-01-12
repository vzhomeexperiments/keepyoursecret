### Productionize this script

### what about function? ###
generate_password <- function(salt = "Cryptography is cool!", pass_begin = 3, pass_end = 23, file_name = "C:/01_RSA/p.txt") {
  require(openssl)
  require(tidyverse)
  paste(Sys.Date(), salt) %>% 
    as.character.Date() %>%
    sha512(key = as.character(Sys.time())) %>%
    substring(first = pass_begin, last = pass_end) %>%
    as.data.frame.character() %>%
    write_tsv(file_name)
}

# using function
generate_password()
