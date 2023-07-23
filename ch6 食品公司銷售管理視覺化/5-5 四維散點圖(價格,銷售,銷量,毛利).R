setwd("C:/Users/USER/Desktop/R語言/Rstudio/ch6 食品公司銷售管理視覺化/working directory ch6")
library(tidyverse)
library(knitr)

# 建立 SalesTable_new 圖表
alesTable <- read_csv('SalesTable.csv')
ClientTable <- read_csv('ClientTable.csv')
ProductTable <- read_csv('ProductTable.csv')

SalesTable_new <- SalesTable %>%
  left_join(ClientTable, by = "Client_ID") %>%
  left_join(ProductTable, by = "Product_ID")

SalesTable_new$Agency <- as.factor(SalesTable_new$Agency)
SalesTable_new$Product_ID <- as.factor(SalesTable_new$Product_ID)
SalesTable_new$Client_ID <- as.factor(SalesTable_new$Client_ID)


# 建立 MarginTable 圖表
MarginTable <- read_csv('SalesTable_WithCost.csv')
MarginTable$Product_ID <- as.factor(MarginTable$Product_ID)
MarginTable$Margin_Rate <- round(MarginTable$Margin_Rate, 3)
kable(MarginTable)

# SalesTableMargin 圖表 (SalesTable_new、MarginTable)，兩表 Product_ID 相同的資料合併
SalesTableMargin <- SalesTable_new %>%
  inner_join(MarginTable, by = 'Product_ID')
kable(SalesTableMargin[1:10,])

# ProductSalesTable，SalesTableMargin 資料處理
ProductSalesTable <- SalesTableMargin %>%
  group_by(Product_Name) %>% # 依產品名稱分組
  summarise( Sales = sum(Sales),
             Sales_Amount = sum(Sales_Amount),
             Margin_Rate = mean(Margin_Rate)) %>%
  mutate( Price = Sales/Sales_Amount, #  建單價欄位
          Margin_Group = ifelse( Margin_Rate > 0.7, 'Top', # 建立毛利等級欄位 
                           ifelse( Margin_Rate >= 0.5 & Margin_Rate < 0.7, 'Normal', 'Bad'))) %>%
  arrange(desc(Sales)) 
kable(ProductSalesTable[1:10,])  

# 1.繪製散狀圖，(MarginPlot <- )是用於 plotly 套件所加，不用可拿掉
MarginPlot <- ggplot( data = ProductSalesTable,
        aes( x = Sales_Amount,
             y = Price,
             colour = Margin_Group)) + # 依毛利等級上色
  geom_point(alpha = 0.9) +
  geom_point(aes(size = Sales)) + # 點大小，依銷售金額
  geom_text(aes(label = Product_Name), vjust = -3, size = 2, colour = 'black') + # 標籤，產品名稱
  geom_vline( aes( xintercept = mean(Sales_Amount))) + # 垂直線，平均銷售數量
  geom_hline( aes( yintercept = mean(Price))) + # 水平線，平均單價
  labs( title = 'Price, Sales_Amount, Sales and Margin') + 
  theme_bw()

# 2. plotly 套件，圖表互動
install.packages("plotly")

library(plotly)

ggplotly(MarginPlot)