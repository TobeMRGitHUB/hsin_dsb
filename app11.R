###################SERVER######################
library(shiny)
library(shinydashboard)
library(RPostgreSQL)
library(dplyr)
library(DT)

db <- 'postgres' 

host_db <- "dfw-knuth-psql.cg2604rnrtbz.us-east-1.rds.amazonaws.com"

db_port <- 5432   # or any other port specified by the DBA

db_user <-  'postgres'

db_password <- 'rI6uQKivwyr0Q89VbhHD'
drv <- dbDriver("PostgreSQL")
#drv <- dbDriver("PostgreSQL")
con <- dbConnect(drv, dbname = db, host=host_db, port=db_port, user=db_user, password=db_password)
default_query <- "SELECT * FROM load_from_s3.locations"




ui=shinyUI(dashboardPage(
  dashboardHeader(title = "TEST TOBE"),
  
  #dashboardSidebar(width = 300),
  
  dashboardSidebar(width = 1
    
    #sidebarMenu(
     # selectInput("Model", "Choose  model:",c("Random forest"))
    #)
    
  ),
  dashboardBody(
    
    tabsetPanel(
      tabPanel("Table",
               
               column(12,box(height =400,width = 800, solidHeader = FALSE, status = "success",
                            DT::dataTableOutput("table1")))
               
      )))))


server <- function(input, output, session){
  output$table1<-DT::renderDataTable({
    map_data = dbGetQuery(con, default_query)%>%
      group_by(location_name) 
    map_data
  })
}

shinyApp(ui = ui, server = server)