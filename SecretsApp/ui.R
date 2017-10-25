# Udemy Course: "Keep Your Secrets Under Your Control"
# Project for Creating Shiny App to enable data encryption
#
# (C) 2017 Vladimir Zhbanko github: https://github.com/vzhomeexperiments/keepyoursecret
# https://www.udemy.com/keep-your-secrets-under-control

# ui.R
library(shinydashboard)
library(shiny)
library(DT)
# 
dashboardPage(
  dashboardHeader(title = "Keep Your Secret Under Your Control"),
  dashboardSidebar(
    
    helpText("App to generate your Private and Public Key")
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

                 "Key Management:",
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