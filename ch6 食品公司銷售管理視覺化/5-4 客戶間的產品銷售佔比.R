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

# 客戶間的產品銷售佔比 
# 1.分層的長條圖(Stacked bar)
Product <- SalesTable_new %>%
  group_by(Client_Name, Product_Name) %>%
  summarise(Sales = sum(Sales)) %>%
  mutate(Propor = round(Sales / sum(Sales),1)*100) # round(x, digits = 第幾位)是一個用於四捨五入數字


ggplot(Product) +
  geom_bar(aes(x = Client_Name, y = Sales, fill = Product_Name), # fill 分層內容
           stat = 'identity', alpha = 0.8) +
  geom_text(aes(x = Client_Name, y = Sales,  # 設定標籤(geom_text )
                label = paste(Propor,'%', sep='')), # 標籤文字 
            position = position_stack(vjust = 0.5), size = 3) +  #  hjust 和 vjust 參數來微調文字的水平和垂直位置
            theme_bw()                                                     # 調整 size 來控制標籤大小theme_bw()

 

# 2. 幾何圖層矩陣占比圖 (geom_rect) 
Product <- SalesTable_new %>%
  group_by(Client_Name, Product_Name) %>%
  summarise(Sales = sum(Sales))

# 轉換表格 spread，每個客戶每個產品的總銷售額(Col:Product_Name, value:Sales)
ClientProductTable <- Product %>%
  spread( key = Product_Name, 
          value = Sales) %>%
  data.frame()

# 創 Block 函數計算(X軸的比例、Y軸的比例、文字的位置、作圖(geom_rect))
Block <- function(ClientProductTable){
  
  ClientProductTable$x_Percentage <- c() # 創建變數 x_Percentage
  
  # X軸的比例
  for (i in 1:nrow(ClientProductTable)) { #得到每一個客戶購買的產品金額在總產品金額中的百分比，填充到 x_percentage 欄位的第 i 列
    ClientProductTable$x_percentage[i] <- rowSums(ClientProductTable[i,-1], na.rm = T) / sum(rowSums(ClientProductTable[,-1], na.rm = T))} # 例 :[2, -1] ，[取row2, 去col1]
  
  ## x_max : x軸各資料的上界，x_min : x軸各資料的下界
  ClientProductTable$x_max <- cumsum(ClientProductTable$x_percentage) # 計算 x_max ，cumsum() 用於計算向量的累計和 例: 1,2,3,4 -> 1,3,6,10
  ClientProductTable$x_min <- ClientProductTable$x_max - ClientProductTable$x_percentage # 計算 x_min，用 x_max - x_x_percentage
  ClientProductTable$x_percentage <- NULL # 刪除 x_percentage 
  

  Percentage <- ClientProductTable %>%
    gather( key =  Product_Name, # values : A,B,C,D,F,G,H,J,K,L,N,O,P,Q,R
            value = Sales,  # values : A...R 底下的值
            -c(Client_Name, x_min,x_max)) # -c(colnames)，不去改動的 col 及其 values  # 剩餘要動 A,B,C,D,F,G,H,J,K,L,N,O,P,Q,R
  
  Percentage[,5] <- ifelse(Percentage[,5] %in% NA, 0, Percentage[,5]) # sales 中是 NA 的改0，否則保持
  
  # Y軸的比例 
  ## 得 y_max、y_min
  Percentage <- Percentage %>%
    group_by(Client_Name) %>%
    mutate(y_max = round(cumsum(Sales) / sum(Sales) * 100)) %>%
    mutate(y_min = round((y_max - Sales / sum(Sales) * 100)))

   
  # 文字的位置 ，放 max 及 min 中間
  Percentage <- Percentage %>%
    mutate( x_text = x_min + (x_max - x_min)/2, 
            y_text = y_min + (y_max - y_min)/2)
  # 文字的值(百分比)
  Percentage <- Percentage %>%
    group_by(Client_Name) %>%
    mutate(Proportion = round( Sales / sum(Sales),2) * 100) 
  

  # 作圖
  ggplot(Percentage, 
         aes(ymin = y_min, ymax = y_max, xmin = x_min, xmax = x_max, 
             fill = Product_Name)) +
    geom_rect(colour = I("grey"), alpha = 0.9) + 
    geom_text(aes(x = x_text, y = y_text,  # 貼標籤(百分比)
              label = ifelse( Client_Name %in% levels(factor(Client_Name))[1] & Proportion != 0,  # %in% ，用於檢查一個元素是否在一個向量或一個集合中。它返回一個邏輯向量
                              paste(Product_Name, " - ", Proportion, "%", sep = ""),              # levels，因子（factor）變數中所有但不重複的因子
                              ifelse(Proportion != 0, paste( Proportion,"%", sep = ""), paste(NULL)))), size = 2.5) + 
    geom_text(aes(x = x_text, y = 103, # 貼產品名稱
                  label = paste(Client_Name)), size = 3) + 
    labs( title = 'Sales Distribution by Client & Product',
          x = 'Client',
          y = 'Product') + 
    theme_bw()
}

Block(ClientProductTable)

# 根據 Percentage 資料框中的 Client_Name 和 Proportion 欄位來設定標籤內容。
# 如果 Client_Name 是第一個類別（levels(factor(Client_Name))[1]）(如果有這個 Client_Name)，
# 且 Proportion 不等於 0，
# 則顯示 Product_Name 與 Proportion 的值，
# 接著如果 Proportion 不等於 0，
# 只顯示 Proportion 的值
# 否則都不顯示。


# 3.資瞭取捨，客戶分為Big、Middle 和 Small，分別作圖以利完整呈現
## 資料預處理，只呈現 Middle(BB、DD、HH)
ClientMiddle <- Product %>%
  filter( Client_Name %in% 'BB' | Client_Name %in% 'DD' | Client_Name %in% 'HH')
kable(ClientMiddle)

ClientProductTable <- ClientMiddle %>%
  spread( key = Product_Name, 
          value = Sales) %>%
  data.frame()
kable(ClientProductTable)
## 用前面製作的 "Block函數"  繪製 "幾何圖層矩陣占比圖" 
Block(ClientProductTable)














