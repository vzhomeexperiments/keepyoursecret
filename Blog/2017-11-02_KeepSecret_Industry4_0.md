Why to bother?
--------------

Have your heard this term 'password chaos'? This is when you exposed to necessity to keep creating stronger passwords, not re-using them across resourses, replacing them every now and then and so on. The only solution seems to be using special programs to encrypt/decrypt your passwords. Of course there are programs designed to do this, but why not to use one extra program if you can do that all with R Statistical Software?

Cryptography
------------

Go to internals of **Cryptography** is something really not for everybody. It smells complex math and must be a lot of code behind... It's something related to conspiracy stories, spy scandals and so on. But it's also exciting new technologies like blockchain, new businesses, new opportunity! Sometimes people are even using this technology without even noticing it...

Public Key Cryptography
-----------------------

**Public Key Cryptography** is a type of Cryptographic system that uses set's of keys Public and Private. These keys in combination with a fixed algorithm are used to Encrypt aka Lock information or Decrypt aka Unlock information. Let's have a quick summary of what are those and how they are made. I will be using and R package **openssl** to demonstrate that. For the sake of make things 'easy' and not generating intermediate objects I will also load **tidyverse** package

``` r
library(openssl)
library(tidyverse)
```

    ## Loading tidyverse: ggplot2
    ## Loading tidyverse: tibble
    ## Loading tidyverse: tidyr
    ## Loading tidyverse: readr
    ## Loading tidyverse: purrr
    ## Loading tidyverse: dplyr

    ## Warning: package 'purrr' was built under R version 3.4.1

    ## Conflicts with tidy packages ----------------------------------------------

    ## filter(): dplyr, stats
    ## lag():    dplyr, stats

### Private Key

Private Key is generated from a large random number. In R you can specify this number lenght, too short is not allowed.. It can be easily generated in R and written as a file persistently. You can specify how 'big' your key should be with a 'bits' argument. Password argument is optional, but highly recommended and is required to 'unlock' private key from file:

``` r
# generate your private key (NB: make sure to do back up copy!!!)
rsa_keygen(bits = 2099) %>% 
  write_pem(path = "my_key.pem", password = "")
```

Just for the sake to understand what is that 'animal' we can read it back and see how this key is composed:

``` r
read_key("my_key.pem",password = "") %>% str()
```

    ## List of 4
    ##  $ type  : chr "rsa"
    ##  $ size  : int 2099
    ##  $ pubkey:List of 5
    ##   ..$ type       : chr "rsa"
    ##   ..$ size       : int 2099
    ##   ..$ ssh        : chr "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABBwYVZo0UP ..."
    ##   ..$ fingerprint:Classes 'hash', 'md5'  raw [1:16] 6f 52 3b 3c ...
    ##   ..$ data       :List of 2
    ##   .. ..$ e:Class 'bignum'  raw [1:3] 01 00 01
    ##   .. ..$ n:Class 'bignum'  raw [1:263] 06 15 66 8d ...
    ##  $ data  :List of 8
    ##   ..$ e :Class 'bignum'  raw [1:3] 01 00 01
    ##   ..$ n :Class 'bignum'  raw [1:263] 06 15 66 8d ...
    ##   ..$ p :Class 'bignum'  raw [1:132] 03 b5 57 9f ...
    ##   ..$ q :Class 'bignum'  raw [1:132] 01 a3 f8 1f ...
    ##   ..$ d :Class 'bignum'  raw [1:263] 01 6d 63 f2 ...
    ##   ..$ dp:Class 'bignum'  raw [1:132] 01 fe 66 5c ...
    ##   ..$ dq:Class 'bignum'  raw [1:132] 00 b7 2b 79 ...
    ##   ..$ qi:Class 'bignum'  raw [1:132] 01 c2 ec 9e ...

You can already notice object ***p**u**b**k**e**y* \* \**w**h**i**c**h**h**a**s**a* \* \*data** elements that are exactly the same as elements of the data elements of the **private key**

**Takeaway \#1** : Private Key contains Public Key

### Public Key

Public Key is a list that contains 'numbers' that are exactly same as the elements of the Private Key. These elements are used by the algorythm to **Encrypt** information. Think we use those numbers to deliberately mix our information in a way that we can 'unmix' them later... Back to reality! All we need now is to extract this element and store it to the file!

``` r
# generate your public key (NB: optional. Use Private Key to encrypt/decrypt)
read_key(file = "my_key.pem", password = "") %>% 
  # extract element of the list and write to file
  `[[`("pubkey") %>% write_pem("my_key.pub")
```

Here you go! Check out the file **my\_key.pub**. You can send it to your friends that can encrypt information that you and only you can read... (if you have corresponding private key of course)

### Encrypt with Public Key

Just as a simple example I would encrypt text string "Hello World" and save this result as a file:

``` r
## Encrypt with PUBLIC key (e.g. send this code to collaborator)
"Hello World" %>% 
  # serialize the object
  serialize(connection = NULL) %>% 
  # encrypt the object
  encrypt_envelope("my_key.pub") %>% 
  # write encrypted data to File
  write_rds("message.enc")
```

If you notice, I must 'serialize' my message before I can encrypt:

``` r
## Encrypt with PUBLIC key (e.g. send this code to collaborator)
"Hello World" %>% 
  # serialize the object
  serialize(connection = NULL) %>% head(10)
```

    ##  [1] 58 0a 00 00 00 02 00 03 04 00

This vector of numbers can be encrypt with function **encrypt\_envelope()** passing as an argument your file with a **public key**

``` r
"Hello World" %>% 
  # serialize the object
  serialize(connection = NULL) %>% 
  # encrypt the object
  encrypt_envelope("my_key.pub") %>% str()
```

    ## List of 3
    ##  $ iv     : raw [1:16] 6f 3e 69 50 ...
    ##  $ session: raw [1:263] 00 34 5f 98 ...
    ##  $ data   : raw [1:48] 4e 8d 34 5d ...

You always get a list of raw vectors as an R object. We can store this object using **read\_rds()** function

### Read it back... decrypt

Decrypting this secret is easy. Just have a look on this chunk that does it for you:

``` r
# read file with Encrypted Information (from Computer File System to R Environment)
secret_encrypted <- read_rds("message.enc")

# decrypting the list from R Environment
decrypt_envelope(data = secret_encrypted$data,
                 iv = secret_encrypted$iv,
                 session = secret_encrypted$session,
                 key = "my_key.pem",
                 password = "") %>% 
  # getting back original object in a form of the data frame
  unserialize() 
```

    ## [1] "Hello World"

``` r
# remove secret_encrypted object
rm(secret_encrypted)
```

Conclusion
----------

Let's make some statistics:

| Operation  | Number of lines of code  |
|------------|--------------------------|
| keys       | 2                        |
| encrypt    | 4                        |
| decrypt    | 4                        |
| ---------- | ------------------------ |
| Total      | 10                       |

With just 10 lines of code you can create your keys, store them to the file, encrypt and decrypt your information!

postscriptum
------------

beyong the theory I have also studied different simple ways to exploit this concept. The material is quite big so I packed that to the e-learning course. Feel free to check this out at []()
