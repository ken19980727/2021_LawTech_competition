rm(list=ls());gc()
library(rvest)
library(dplyr)
library(glue)
library("RSelenium")

remDr <- remoteDriver(remoteServerAddr = "localhost", port = 4444, browserName = "chrome")
url = 'https://www.fsc.gov.tw/ch/home.jsp?id=131&parentpath=0%2C2'
remDr$open()
remDr$navigate(url)
webElem <- remDr$findElement("css", "body")
Sys.sleep(2)

penalty_cases = c()
for (p in 2:20){
  print(p)
  for (i in seq(from = 6,to = 34 ,by = 2)){
    print(i)
    x_link = '//*[@id="messageform"]/div[3]/div[{i}]/div[4]/a'
    btn <- remDr$findElement(using = 'xpath', value = glue(x_link))
    remDr$mouseMoveToLocation(webElement = btn)
    Sys.sleep(1)
    remDr$mouseMoveToLocation(webElement = btn)
    remDr$click()
    Sys.sleep(3)
    
    x_article = '//*[@id="maincontent"]'
    webElem <- remDr$findElement(using = 'xpath', value = x_article)
    text = webElem$getElementText() %>% unlist()
    text2 = paste(strsplit(text , '\n') %>% unlist(), collapse = ' ')
    
    penalty_cases = append(penalty_cases , text2)
    Sys.sleep(0.1)
    remDr$goBack()
    Sys.sleep(2)
  }
  page_link = '//*[@id="messageform"]/div[5]/nav/ul/li[{p}]/a'
  p_btn <- remDr$findElement(using = 'xpath', value = glue(page_link))
  remDr$mouseMoveToLocation(webElement = p_btn)
  Sys.sleep(1)
  remDr$click()
  Sys.sleep(3)
}

write.table(penalty_cases,file="penalty_cases2.txt",fileEncoding = 'utf-8',append = T)