# 讀取資料
setwd("C:/Users/USER/Desktop/R語言/Rstudio/ch3/working directory")
library(readr)
stock.data <- read_csv("TWSE_Stock Data_2012-2017.csv")
print(stock.data)

# 問題 2 gather 
stock.data.colnames <- colnames(stock.data)

stock.data <- stock.data %>%
  gather(
    key = "date",                    
    value = "price",
    stock.data.colnames[3:ncol(stock.data)])
head(stock.data)

# 問題 3 spread
stock.data <- stock.data %>%
  spread(
    key = "type",
    value = "price")
head(stock.data)

# 問題 4 seperate函數 拆分日期
stock.data <- stock.data %>%
  separate(col = "date", 
           into = c("year", "month", "day"),
           sep = "/",
           convert = TRUE)
head(stock.data)