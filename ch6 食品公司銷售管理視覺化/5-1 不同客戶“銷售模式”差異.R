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


# 1.單價/銷售數量 散點圖
# 先取得個別價格
SalesTablePrice <- SalesTable_new %>%
  mutate(Unit_Price = Sales/Sales_Amount)
SalesTablePrice

# gglot 畫散點圖(geom_point)
ggplot(data = SalesTablePrice) + 
  geom_point(aes(x = Unit_Price, 
                 y = Sales_Amount, 
                 color = 'red',  # color 用於點及線的顏色 point, line, boxplot
                 alpha = 0.5)) + 
  theme_bw()  

# 2.客戶銷售的分配 盒鬚圖(geom_boxplot)
ggplot(data = SalesTable_new) + 
  geom_boxplot(aes(x = factor(Client_Name), y = Sales, color = Client_Name)) +
  labs(x = "Client_Name", title = "Sales distribution by Client")+
  theme_bw()  


# 3.查看過去一個月客戶的總銷售量 直方圖(geom_bar)
# 每個客戶(分組)的總銷售量(大到小)
SalesTable_Sum <- SalesTable_new %>%
    group_by(Client_Name) %>%
    summarise(Sales_Sum = sum(Sales)) %>%
    arrange(desc(Sales_Sum))

# Total Sales by Client 直方圖(geom_bar)
ggplot(data = SalesTable_Sum) + 
  geom_bar(aes(x = Client_Name, y = Sales_Sum, fill = Client_Name), # fill 用於面填滿的顏色 bar
           stat = "identity") + # stat = "identity" 用於指定該長條的（高度值）由資料中的原始值直接提供，預設為 stat="count"
  scale_x_discrete(limits = SalesTable_Sum$Client_Name) + # scale_x_discrete() 函數用於調整 x 軸上的類別變數的顯示方式。參數 limits 是用於指定 x 軸上要顯示的特定類別順序或限制類別的範圍。
  labs(x = "Client", y = "Sales in total" ,title = "Total Sales by Client")+
  theme_bw()  


# 4.過去一個月的每位客戶的單價分配 盒鬚圖(geom_boxplot)
ggplot(data = SalesTablePrice) + 
  geom_boxplot(aes(x = factor(Client_Name), y = Unit_Price, color = Client_Name)) +
  labs(title = "Unit_Price by Client", x = "Client", y = 'Unit_Price in total')+
  theme_bw()  