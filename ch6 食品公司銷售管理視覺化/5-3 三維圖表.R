setwd("C:/Users/USER/Desktop/R語言/Rstudio/ch6 食品公司銷售管理視覺化/working directory ch6")

library(tidyverse)
library(knitr) #幫助我們畫出好看的表格

SalesTable <- read_csv('SalesTable.csv')
ClientTable <- read_csv('ClientTable.csv')
ProductTable <- read_csv('ProductTable.csv')

#三表合併
SalesTable_new <- SalesTable %>%
  left_join(ClientTable, by = "Client_ID") %>%
  left_join(ProductTable, by = "Product_ID")

# knitr-kable，畫出好圖表(value在右為數字，value在左為類別)
kable(SalesTable_new[1:10,]) # knitr

# 將 id 轉換資料型態為 factor
SalesTable_new$Agency <- as.factor(SalesTable_new$Agency)
SalesTable_new$Product_ID <- as.factor(SalesTable_new$Product_ID)
SalesTable_new$Client_ID <- as.factor(SalesTable_new$Client_ID)
kable(SalesTable_new[1:10,]) 


# 1.不同客戶之下，不同產品的總銷售額
# 分組(顧客、產品)，的總銷售額
SalesTableClient <- SalesTable_new %>%
  group_by(Client_Name, Product_Name) %>%
  summarise(Sales_sum = sum(Sales))
kable(SalesTableClient[1:10,])

# 三圍(客戶、產品、銷售總額) 直方圖(geom_bar)
ggplot(SalesTableClient) +
  geom_bar(aes(x = Product_Name, y = Sales_sum), 
           stat = 'identity') +
  facet_wrap( ~ Client_Name) # 第三維 圖片類別


# 2.各經銷商，不同產品的總銷售額
# 分組(經銷、產品)，的總銷售額
SalesTableAgency <- SalesTable_new %>%
  group_by(Agency, Product_Name) %>%
  summarise(Sales_sum = sum(Sales))
kable(SalesTableClient[1:10,])

# 三圍(經銷、產品、銷售總額) 直方圖(geom_bar)
ggplot(SalesTableAgency) +
  geom_bar(aes(x = Product_Name, y = Sales_sum), 
           stat = 'identity') +
  facet_wrap( ~ Agency) # 第三維 圖片類別