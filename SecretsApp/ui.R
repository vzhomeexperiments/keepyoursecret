# Project for Creating Shiny App to enable data encryption
#
# (C) 2017 Vladimir Zhbanko github: vzhomeexperiments/...

# ui.R
library(shinydashboard)
library(shiny)
library(DT)
# 
dashboardPage(
  dashboardHeader(title = "Keep Your Secret Under Your Control"),
  dashboardSidebar(
    # Elements on the Sidebar of the App
    fileInput(inputId = "inputPK", label = "Load Your Private Key", multiple = FALSE, accept = "*private.key", width = NULL,
              buttonLabel = "Browse...", placeholder = "No file selected"),
    passwordInput(inputId = "inpPassw", label = "Type Passphrase of your Private Key"),
    fileInput(inputId = "inputEData", label = "Load Information to decrypt", multiple = F, accept = "e-*.data", width = NULL,
              buttonLabel = "Browse...", placeholder = "No file selected"),
    actionButton(inputId = "actButDec", label = "Decrypt"),
    actionButton(inputId = "actButEnc", label = "Encrypt"),
    div(style="display:inline-block;width:65%;text-align: right;",downloadButton(outputId = "downloadEData",label = "Encrypted Data")),
    helpText("Browse to your private key to enable encryption process.",
             "App can encrypt/decrypt provided information,",
             "files with encrypted data are stored in the computer file system.",
             "App can also help you to generate your Private Key", 
             " and facilitate entry of information (e.g. passwords)")
  ),
  dashboardBody(
    
    mainPanel(
      # Elements of the Dashboard: header and tabset panel
      infoBox(title = "WARNING: Use at your won risk",
              value = "Only for Demonstration Purposes, use only Dummy Data", 
              subtitle = "App to generate Private/Public Keys, encrypt passwords using openssl library",
              icon = icon("key"), color = "aqua", width = 40,
              href = NULL, fill = FALSE),
      tabsetPanel(
        # TAB VIEW DECRYPTED
        tabPanel(title = "View", icon = icon("upload"),
                 "All records stored",
                 fluidRow(column(12,  dataTableOutput(outputId = "viewPasswords", width = 400))),
                 # action button aim: when user click save information about seal quality into the database in SQL Server          
                 fluidRow(column(6, fileInput(inputId = "importPassw", label = "Import csv", multiple = F, 
                                              placeholder = "No file selected", accept = 'text/csv'),
                                    # refresh button must bring all data to the datatable
                                    actionButton(inputId = "refresh", label = "refresh", icon = icon("refresh"))),
                          column(5, numericInput("numLineDelete", "Line to Erase",value = 1,min = 1),
                                 actionButton('eraseLine', "Erase Selected", icon = icon("eraser")),
                                 downloadButton(outputId = 'downloadTable',label = 'Download')))), 

        # TAB ADD TO ENCRYPT -> here user can view and add information to be encrypted
        tabPanel(title = "Add", icon = icon("save"),
                 fluidRow(column(4, textInput(inputId = "txtInputUser", label = "UserName")),
                          column(4, textInput(inputId = "txtInputEmail", label = "Email")),
                          column(4, textInput(inputId = "txtInputPass", label = "Password")),
                          column(4, textInput(inputId = "txtInputDesc", label = "Description"))),
                 "Summary of one Record", # User is able to see added record before submitting it
                 fluidRow(column(12,  dataTableOutput(outputId = "viewOneRow", width = 400)),
                          column(2, actionButton(inputId = "butSaveRow", label = "Add Record", icon = icon("download"))))
                 
                 ),
        # TAB KEY MANAGEMENT
        tabPanel(title = "Keys", icon = icon("cog"),
                 # here user should be able to create new private key and download it as a file
                 "Specify your key properties",
                 fluidRow(column(3, sliderInput(inputId = "keybits", label = "Key Bits", min = 1000, max = 5000,value = 2048)),
                          column(4, textInput(inputId = "keyname", label = "Key File Name", value = "private.key")),
                          column(4, textInput(inputId = "passphrase", label = "Key File Passphrase"))),
                 # adding action buttons enabling key generation and downloading it as a file
                 "Create and download your key",
                 fluidRow(column(4, downloadButton(outputId = "downloadPrvKey",label = "1. Get Private Key")),
                          column(4, downloadButton(outputId = "downloadPubKey", label = "2. Get Public Key")),
                          column(4, actionButton(inputId = "delKey", label = "3. Erase Private Key from R", icon = icon("trash"))))
                 ),
        # TAB HELP
        tabPanel(title = "Help", icon = icon("question"),
                 # here user can refresh information about the app, how to use it, etc
                 "Regularly review the functionality and refresh how to use this ShinyApp!!!",
                 hr(),
                 "1. Decryption Process:",
                 helpText("1a. Load your Private Key from file->",
                          "1b. Type passphrase to your Private Key (if present)->",
                          "1c. Load your Encrypted data from file->",
                          "1d. Press button 'Decrypt'->",
                          "1e. Your information will appear in the tab: 'View Decrypted'"),
                 hr(),
                  "2. Encryption Process:",
                 helpText("2a. Load your Private/Public Key from file->",
                          "2b. Type passphrase to your Private Key (if present)->",
                          "2c. Verify your Information in tab 'View Decrypted'->",
                          "2d. Press button 'Encrypt'->",
                          "2e. Download your encrypted file with button 'Download Encrypted Data'"),
                 hr(),
                 "3. Key Management:",
                 helpText("3a. Make sure to decrypt all information using existing Private Key->",
                          "3b. Select properties of your new Private Key->",
                          "3c. Download Private Key first and then Public Key->",
                          "3d. Delete Key from R Environment")
                 )
      )  
    )
  )
)
# end of ui.R