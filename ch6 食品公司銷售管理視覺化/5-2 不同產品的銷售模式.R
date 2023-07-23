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


# 1.個產品銷售的分配 盒鬚圖(geom_boxplot)
ggplot( data = SalesTable_new) + 
  geom_boxplot(aes( x = Product_Name, y = Sales, colour = Product_Name)) +
  labs(title = 'Sales Distribution by Product', x = 'Product',) + 
  theme_bw()


# 2.個產品過去一個月的總銷售數量 直方圖(geom_bar)
# 每個產品(分組)的總銷售量(大到小)排名
SalesTableAmount <- SalesTable_new %>%
  group_by(Product_Name) %>%
  summarise(Amount_Sum = sum(Sales_Amount)) %>%
  arrange(desc(Amount_Sum))
kable(SalesTableAmount)

# Total Sales_Amount by Product 直方圖(geom_bar)
ggplot(SalesTableAmount) +
  geom_bar(aes(x = Product_Name, y = Amount_Sum, fill = Product_Name), 
           stat = "identity") +
  scale_x_discrete(limits = SalesTableAmount$Product_Name) +
  labs(title = 'Total Sales_Amount by Product', x = "Product", y ='Sales_Amount in total') +
  theme_bw()
