
# (C) 2017 Vladimir Zhbanko 
# Udemy Course: "Keep Your Secrets Under Your Control"

library(shiny)
library(DT)
library(openssl)
library(tidyverse)

#=======================================
# CONTENT               #
# =======================================  
# 1. generatePrivateKey
# 2. storeData
# 3. saveDataGlobal
# 4. decryptData
# 5. joinData
# 6. encryptData
# 7. inputPK 
# 8. inputEData
# 9. oneRow
#10. viewData
#11. responses
#12. downloadTable
#13. downloadPrvKey
#14. downloadPubKey
#15. delKey
#16. lineToDelete
#17. eraseLine
#18. importPassw
#19. dataFromImport
#20. dataFromSingleEntry
#21. dataFromDecryption
#22. viewPasswords
# =======================================
# DEFINE GLOBAL FUNCTIONS               #
# =======================================  
#
#
#--------------------------------------------------------------------
# function that generates private key and write it to the file
generatePrivateKey <- function(keyBits = 2099, keyPath = "private.key", passphrase = "udemy") {
  openssl::rsa_keygen(bits = keyBits) %>% 
    write_pem(path = paste(Sys.Date(), keyPath, sep = ""), password = passphrase)
}

#--------------------------------------------------------------------
# function that save data from DT() to csv file of the temp_folder directory and also check for duplicates 
# -- use this function to store data to the file
# -- function also remove duplicate records from table
storeData <- function(data, directoryName, fileName) {
  
  # store only unique records
  # non duplicates
  nonDuplicate <- data[!duplicated(data), ]
  # Write the file to the local system
  write.csv(
    x = nonDuplicate,
    file = file.path(directoryName, fileName), 
    row.names = FALSE, quote = FALSE, append = TRUE, col.names = FALSE
  )
}

#--------------------------------------------------------------------
# function that write data to global directory called "responses"
# -- use this function to append data to the existing table
# -- data will be stored in the global object 'responses'
saveDataGlobal <- function(data) {
  
  if (exists("responses")) {    # get data from global environment is it's exist there
    responses <<- rbind(responses, data)
  } else {
    responses <<- data                # <<- this saves to the global environment
  }
}

#--------------------------------------------------------------------
# function that decrypt information from user
# -- function gets the encrypted file, private key and return obtained result
# -- function write result to the file 'decrypted'
decryptData <- function(fileName, privateKey, passPhrase) {
  outputDir <- "temp_folder"  
  # read file with Encrypted Information (from Computer File System to R Environment)
  secret_encrypted <- read_rds(fileName)
  
  # decrypting the list from R Environment
  decrypt_envelope(data = secret_encrypted$data,
                   iv = secret_encrypted$iv,
                   session = secret_encrypted$session,
                   key = privateKey,
                   password = passPhrase) %>% 
    # getting back original object in a form of the data frame
    unserialize() %>% 
    # write dataframe to the csv file
    storeData(outputDir, "decrypted.csv")
  
  # remove secret_encrypted object
  rm(secret_encrypted)
}

#--------------------------------------------------------------------
# function that joins and delete available information to encrypt
# three souces of information are available:
# 1. From imported file, 2. from single entry, 3. from decrypted file, 4. previously combined
joinData <- function(){
  outputDir <- "temp_folder"  
  files <- c("imported.csv","singlerow.csv","decrypted.csv")
  #join data from all files and delete original files
  for (i in 1:3){
    if(file.exists(file.path(outputDir, files[i]))){
      # store
      if(exists("df_joined")){
        df_joined <- df_joined %>% 
          bind_rows(read_csv(file.path(outputDir, files[i]))) 
      } else {
        df_joined <- read_csv(file.path(outputDir, files[i]))
      }
       # delete
       file.remove(file.path(outputDir, files[i]))
    }  
    
  }
  # return joined dataframe
  saveDataGlobal(df_joined)
  return(df_joined)
  
}

#--------------------------------------------------------------------
# function that encrypt information from user
# -- function uses the data present in the file and encrypt them using private key
# -- funciton writes information to the folder
encryptData <- function(privateKey, passphrase) {
  outputDir <- "temp_folder"  
  # retrieve public key from private one
  pubKey <- read_key(file = privateKey, password = passphrase) %>% 
    # extract element of the list
    `[[`("pubkey")
  
  # join data collected by user
  joinData() %>% 
    # serialize the object
    serialize(connection = NULL) %>% 
    # encrypt the object
    encrypt_envelope(pubKey) %>% 
    # write encrypted data to File
    write_rds(file.path(outputDir, "PasswordList.Encrypted"))
  
}




shinyServer(function(input, output, session) {

  # =======================================
  # DEFINE GLOBAL VARIABLES               #
  # =======================================
  outputDir <- "temp_folder"  
  
  #==================================================  
  # Run once in the event of loading file... with Private Key
  observeEvent(input$inputPK, {
    # Read file
    inFilePK <- input$inputPK
    
    # TDL more secure way is needed (e.g. if wrong file is entered)
    if (is.null(inFilePK))
      return(NULL)
    
    # # store private key into global environment
    # privateKey <- read_key(file = inFilePK$datapath, password = input$passphrase)

  })
  #==================================================  
  #==================================================  
  # Run once in the event of loading file... with Encrypted Data
  observeEvent(input$inputEData, {
    # Read file EF -> "Encrypted File"
    inFileEF <- input$inputEData
    
    # TDL more secure way is needed (e.g. if wrong file is entered)
    if (is.null(inFileEF))
      return(NULL)
    
    # store encrypted data to the file 'temp_folder/decrypted.csv'
    decryptData(fileName = inFileEF$datapath, privateKey = inFilePK$datapath, passPhrase = input$passphrase)
    
  })
  #==================================================    
  
  
  
  
  # ==========================================
  # Objects located in the Tab Add to Encrypt #
  # ==========================================
  ## **-------------- **
  # Object DF will contain the results of the password input. Object can be accessed in the code using DF() notation
  oneRow <- reactive({
    # Data frame 
    data.frame(UserName = as.character(input$txtInputUser), 
               Email = as.character(input$txtInputEmail), 
               Password = as.character(input$txtInputPass),
               Description = input$txtInputDesc,
               stringsAsFactors = F)
  })
  ## **-------------- **
  

  
  # function that visualizes the current table results if it's stored in GLobal Environment
  viewData <- function() {
    if (exists("responses")) {
      responses
    }
  }
  
  # Visualize responses in the interactive tables, refresh when some buttons are pressed...
  output$responses <- renderDataTable({
    # change in reactive inputs below will refresh data  
    input$butSaveRow
    input$refresh
    
    viewData()
  })     
  ## *****-------------- *****     
  
  ## ******-------------- ******     
  # show the action button that will enable the data table save to the SQL Database
  # refreshData <- eventReactive(input$refresh, {
  #   
  #   # code that brings all available decrypted files to very one file
  #   # this file will be used for visualizing data in the table
  #   # 
  #   joinData()
  #   
  # })
  ## ******-------------- ******       
  
  ## **-------------- **
  # output to download file of Decrypted Information (secret)
  output$downloadTable <- downloadHandler(
    filename = function() { 
      paste("Data-", Sys.Date(), '.csv', sep='') 
    },
    content = function(file) {
      write.csv(df, file)
    }
  )
  ## **-------------- **
  
  # ==========================================
  # Objects located in the Tab Key Management #
  # ==========================================

  ## **-------------- **
  # output to download file with Private Key
  output$downloadPrvKey <- downloadHandler(
    filename = function() { 
      paste(Sys.Date(), input$keyname, sep="") 
    },
    content = function(file) {
      # generate the key
      generatePrivateKey(keyBits = input$keybits, keyPath = input$keyname, passphrase = input$passphrase)
      file.copy(paste(Sys.Date(), input$keyname, sep = ""), file)
    }
  )
  ## **-------------- **
  ## **-------------- **
  # output to download file with Public Key
  output$downloadPubKey <- downloadHandler(
    filename = function() { 
      paste(Sys.Date(), input$keyname, "Pub", sep="") 
    },
    content = function(file) {
      # generate the key
      k <- read_key(file = paste(Sys.Date(), input$keyname, sep=""), password = input$passphrase)
      write_pem(k$pubkey, path = paste(Sys.Date(), input$keyname, "Pub", sep = ""))
      file.copy(paste(Sys.Date(), input$keyname, "Pub", sep = ""), file)
    }
  )
  ## **-------------- **
  ## **-------------- **
  # Now user must press the button to delete the key from R Environment
  observeEvent(input$delKey, {
    # user deletes the key once sure that it's saved
    file.remove(paste(Sys.Date(), input$keyname, sep = ""))
  })
  
  
  ## **-------------- **
  
  ## ****-------------- **** 
  # get value of the input number that indicate which line to delete
  lineToDelete <- reactive({ lineToDelete <- input$numLineDelete})
  # pressing button will delete single line inside of the response object
  observeEvent(input$eraseLine, {
    # delete the first element of the table
    responses <- responses[-lineToDelete(), ]
  })
  ## ****-------------- **** 

  ## ****** ---------------*******
  # Uploading data using the app
  observeEvent(input$importPassw, {
    pFile <- input$importPassw
    if (is.null(pFile))
      return()
    # TDL: add fail safe (wrong file, etc)
  })
  ## ******---------------********
  # this will bring data from imported file from user
  dataFromImport <- eventReactive(input$importPassw, {
    # return data from imported file on request
    req(input$importPassw)
    # save to dataframe
    df_imported <- read_csv(input$importPassw$datapath)
    # store this data persistently... (temporary, further on shall be removed)
    storeData(data = df_imported, directoryName = outputDir, fileName = "imported.csv")
    # join the data we have already
    df_imported <- joinData()
    return(df_imported)
  })
  
  ## *****-------------- *****   
  # this will bring data stored by user (one line)
  dataFromSingleEntry <- eventReactive(input$butSaveRow, {
    # save data file to temp directory (temporary, further on shall be removed)
    storeData(data = DF(), directoryName = outputDir, fileName = "singlerow.csv")
    # join the data we have already
    df_single <- joinData()
    return(df_single)
  })
  
  # ## *****-------------- *****   
  # # this will bring decrypted data from file
  # dataFromDecryption <- eventReactive(input$butSaveRow, {
  #   # save data file to temp directory (temporary, further on shall be removed)
  #   saveData(data = DF(), directoryName = outputDir, fileName = "decrypted.csv")
  #   # join the data we have already
  #   df_decrypted <- joinData()
  #   return(df_decrypted)
  # })
  # 
  # ================================= 
  # visualize the table that user loads
  output$viewPasswords <- renderDataTable({
  # data coming from imported files
    input$refresh
    input$butSaveRow
    
    joinData()
  })    
  
  ## ****-------------- ****   
  # output the results of the data input as a datatable vector
  output$viewOneRow <- renderDataTable({ oneRow()  })
  ## ****-------------- ****   
  

})