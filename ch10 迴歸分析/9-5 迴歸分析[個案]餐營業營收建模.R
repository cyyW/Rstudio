library(tidyverse)
library(knitr)

setwd("C:/Users/USER/Desktop/R語言/Rstudio/ch10 迴歸分析/working directory ch10")
SalesData <- read.csv('Restaurant_Sales.csv')
kable(SalesData[1:10,])
as_tibble(SalesData[1:10,])

# 1.探索性資料分析(簡單的視覺化，根據不同變數建立假說)
## 1-1各店的銷售分配 盒鬚圖
SalesData$Store_Name <- as.factor(SalesData$Store_Name)
ggplot(data = SalesData) + 
geom_boxplot(aes( x= Store_Name, y= Sales, colour = Store_Name)) + 
  labs( x = 'Store',
        y = 'Sales',
        title = 'Sales Distribution by Store')
ggsave("C:/Users/USER/Desktop/R語言/Rstudio/ch10 迴歸分析/圖片/9-5/1-1各店的銷售分配 盒鬚圖.png", width = 10, height = 10, dpi = 600)

## 1-2各區域的銷售分配 盒鬚圖
ggplot(data = SalesData) + 
geom_boxplot(aes( x = Region, y = Sales, colour = Region)) + 
  labs( x = 'Region',
        y = 'Sales',
        title = 'Sales Distribution by Region')
ggsave("C:/Users/USER/Desktop/R語言/Rstudio/ch10 迴歸分析/圖片/9-5/1-2各區域的銷售分配 盒鬚圖.png", width = 10, height = 10, dpi = 600)

## 1-3各門市類型的銷售分配 盒鬚圖
ggplot(data = SalesData) + 
geom_boxplot(aes( x = Type, y = Sales, colour = Type)) + 
  labs( x = 'Type',
        y = 'Sales',
        title = 'Sales Distribution by Type')
ggsave("C:/Users/USER/Desktop/R語言/Rstudio/ch10 迴歸分析/圖片/9-5/1-3各門市類型的銷售分配 盒鬚圖.png", width = 10, height = 10, dpi = 600)

## 1-4各店間的平假日銷售分配 盒鬚圖
ggplot(data = SalesData) + 
geom_boxplot(aes( x = Weekday, y = Sales, colour = Weekday)) + 
  facet_wrap(~ Store_Name) + # 依店分圖
  labs( x = 'Weekday',
        y = 'Sales',
        title = 'Sales Distribution by Weekday')
ggsave("C:/Users/USER/Desktop/R語言/Rstudio/ch10 迴歸分析/圖片/9-5/1-4各店間的平假日銷售分配 盒鬚圖.png", width = 10, height = 10, dpi = 600)

SalesData$Month <- factor(SalesData$Month, levels = c('Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'))

## 1-5各店間的月份銷售分配 折線圖
SalesData$Month <- factor(SalesData$Month, levels = c('Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'))

SalesDataMonth <- SalesData %>%
 group_by(Store_Name, Month) %>%
 summarise(SalesMean = mean(Sales))

ggplot(data = SalesDataMonth,
       aes( x = Month, y = SalesMean, group = Store_Name)) + 
  geom_line() + geom_point() + 
  facet_wrap(~ Store_Name) + # 依店分圖
  labs( x = 'Month',
        y = 'Sales',
        title = 'Sales Distribution by Month')
ggsave("C:/Users/USER/Desktop/R語言/Rstudio/ch10 迴歸分析/圖片/9-5/1-5各店間的月份銷售分配 折線圖.png", width = 10, height = 10, dpi = 600)

# 2.迴歸分析，透過觀察模型狀況進行變數評估 ，lm(Y ~ X, data = )

## 依區域分開建模，區域(Region)之間的營業額有較明顯的差異 
DataA <- SalesData %>% # A 區域資料
  filter( Region %in% 'A')
DataB <- SalesData %>% # B 區域資料
  filter( Region %in% 'B')

## 驗證假說一：門市類型的差異
Model.A.Type <- lm( Sales ~ Type, data = DataA) 
Model.B.Type <- lm( Sales ~ Type, data = DataB)
summary(Model.A.Type) # Adjusted R-squared:  0.7206, p-value: < 2.2e-16
summary(Model.B.Type) # Adjusted R-squared:  0.4543, p-value: < 2.2e-16

## 驗證假說二：假日的差異
Model.A.Week <- lm( Sales ~ Weekday, data = DataA)
Model.B.Week <- lm( Sales ~ Weekday, data = DataB)
summary(Model.A.Week) # Adjusted R-squared:  0.09658, p-value: < 2.2e-16
summary(Model.B.Week) # Adjusted R-squared: -0.001373 , p-value: 0.9862 (差)

## 驗證假說三：月份的差異
Model.A.Month <- lm( Sales ~ Month, data = DataA)
Model.B.Month <- lm( Sales ~ Month, data = DataB)
summary(Model.A.Month) # Adjusted R-squared:  0.01032, p-value: 0.07117
summary(Model.B.Month) # Adjusted R-squared:  0.0748, p-value: 4.239e-10


# 3.納入上述顯著變數並檢視目前模型的解釋能力
Model.A <- lm( Sales ~ Type + Weekday + Month, data = DataA)
Model.B <- lm( Sales ~ Type + Month, data = DataB)
summary(Model.A) #  Adjusted R-squared:  0.8403, p-value: < 2.2e-16
summary(Model.B) #  Adjusted R-squared:  0.5362, p-value: < 2.2e-16


# 4.用視覺化圖表來檢視目前的成果(3.)
## 店1營收(預測的上界及下界偏窄，估計是對部分變數的影響有輕估或有缺少的關鍵變數)
ggplot( data = DataA[1:365,]) + 
  geom_point( aes(x = c(1:365),y = Sales)) + 
  geom_line( aes( x = c(1:365),
                  y = Model.A$fitted.values[1:365], # 訓練後預測的營收
                  colour = 'red')) +
  labs( x = 'Day1 to Day365',
        y = 'Sales',
        title = 'Store1 Sales: Actual vs Predicted')
ggsave("C:/Users/USER/Desktop/R語言/Rstudio/ch10 迴歸分析/圖片/9-5/4-1 店1營收預測 折線圖.png", width = 10, height = 10, dpi = 600)

## 店2的營收(與店1預測結果狀況相近)
ggplot( data = DataB[1:365,]) + 
  geom_point( aes(x = c(1:365),y = Sales)) + 
  geom_line( aes( x = c(1:365),
                  y = Model.B$fitted.values[1:365], # 訓練後預測的營收
                  colour = 'red')) +
  labs( x = 'Day1 to Day365',
        y = 'Sales',
        title = 'Store2 Sales: Actual vs Predicted')
ggsave("C:/Users/USER/Desktop/R語言/Rstudio/ch10 迴歸分析/圖片/9-5/4-2 店2的營收預測 折線圖.png", width = 10, height = 10, dpi = 600)


# 5.加入新資訊(變數)的資料集 SalesDataRenew
SalesDataRenew <- read.csv('Restaurant_Sales_Renew.csv')
kable( SalesDataRenew[1:10,])

## 檢視新變數對營收的影響
Model.Holiday <- lm( Sales ~ Holiday, data = SalesDataRenew)

Event <- ifelse( SalesDataRenew$Store1_Event %in% 1 | SalesDataRenew$Store2_Event %in% 1, 1, 0) # 兩間百貨公司活動設為一個 Event
Model.Event <- lm( SalesDataRenew$Sales ~ Event)

summary(Model.Holiday) # Adjusted R-squared:  0.003987, p-value: 0.009007
summary(Model.Event) # Adjusted R-squared:  0.03957, p-value: 1.024e-14


# 6.將全部資料進行建模遇測分析 (部分月份不夠顯著)
Model.All <- lm( Sales ~ ., data = SalesDataRenew[,-1]) # . 點代表全部
summary(Model.All) # Adjusted R-squared:   0.82, p-value: < 2.2e-16

## 店1的營收預測 折線圖 (可以預測出營收較高的部分，但預測整體有過高的趨勢)
ggplot( data = SalesDataRenew[1:365,]) + 
  geom_point( aes(x = c(1:365), y = Sales)) + 
  geom_line( aes( x = c(1:365),
                  y = Model.All$fitted.values[1:365],
                  colour = 'red')) +
  labs( x = 'Day1 to Day365',
        y = 'Sales',
        title = 'Store1 Sales: Actual vs Predicted')
ggsave("C:/Users/USER/Desktop/R語言/Rstudio/ch10 迴歸分析/圖片/9-5/6-1 (ALL)店1的營收預測 折線圖.png", width = 10, height = 10, dpi = 600)

## 店2的營收預測 折線圖
ggplot( data = SalesDataRenew[366:730,]) + 
geom_point( aes(x = c(1:365), y = Sales)) + 
  geom_line( aes( x = c(1:365),
                  y = Model.All$fitted.values[366:730],
                  colour = 'red')) +
  labs( x = 'Day1 to Day365',
        y = 'Sales',
        title = 'Store2 Sales: Actual vs Predicted')
ggsave("C:/Users/USER/Desktop/R語言/Rstudio/ch10 迴歸分析/圖片/9-5/6-2 (ALL)店2的營收預測 折線圖.png", width = 10, height = 10, dpi = 600)

## 四間店 的營收預測 折線圖 (2及4店明顯整體過高，3有點過底)
ggplot( data = SalesDataRenew) + 
geom_point( aes(x = c(1:1460), y = Sales)) + 
  geom_line( aes( x = c(1:1460),
                  y = Model.All$fitted.values,
                  colour = 'red')) +
  labs( x = 'Day',
        y = 'Sales',
        title = 'Store Sales: Actual vs Predicted')
ggsave("C:/Users/USER/Desktop/R語言/Rstudio/ch10 迴歸分析/圖片/9-5/6-3 (ALL)四間店的營收預測 折線圖.png", width = 10, height = 10, dpi = 600)

## Beta Coefficients 長條圖 (觀察模型預測各變數的影響)
Beta <- cbind(
  names(Model.All$coefficients), # 影響變數名
  Model.All$coefficients # 影響程度
) %>% 
  as.data.frame() 

colnames(Beta) <- c('Name', 'Value') # 欄位賦名
Beta$Value <- Beta$Value %>% as.character() %>% as.numeric() # character(字串)、numeric(數值)

Beta <- Beta %>%
  arrange(desc(Value)) # Value 大到小排序

ggplot( data = Beta) + 
  geom_bar(aes( x = factor(Name, levels = as.character(Beta$Name)), 
                y = Value, 
                fill = Name),stat = 'identity') +   
    labs( x = 'Variable',
          y = 'Beta Coefficient',
          title = 'Beta Coefficient of Model.All') + coord_flip() + theme_bw() # coord_flip 轉置
ggsave("C:/Users/USER/Desktop/R語言/Rstudio/ch10 迴歸分析/圖片/9-5/6-4 Beta Coefficients 長條圖.png", width = 10, height = 10, dpi = 600)


# 7.用更新資料分區域預測，並添加 交互作用(interaction)
## 觀察到不同門市類型的平假日表現可能有所不同，添加交互變數 Type * Weekday
DataRenewA <- SalesDataRenew %>% filter( Region %in% 'A')
DataRenewB <- SalesDataRenew %>% filter( Region %in% 'B')

Model.A.All <- lm( Sales ~ .+ Type * Weekday, data = DataRenewA[,-c(1,2)])  # 變數相乘 交互
Model.B.All <- lm( Sales ~ .+ Type * Weekday , data = DataRenewB[,-c(1,2)]) # 去除前兩欄

summary(Model.A.All) # Adjusted R-squared:  0.8688, p-value: < 2.2e-16
summary(Model.B.All) # Adjusted R-squared:  0.7687, p-value: < 2.2e-16

## RegionA 預測 折線圖 (修復了先前的誤差)
ggplot( data = DataRenewA) + 
  geom_point( aes(x = c(1:730), y = Sales)) + 
  geom_line( aes( x = c(1:730),
                  y = Model.A.All$fitted.values,
                  colour = 'red'))
ggsave("C:/Users/USER/Desktop/R語言/Rstudio/ch10 迴歸分析/圖片/9-5/7-1 RegionA 預測 折線圖.png", width = 10, height = 10, dpi = 600)

## RegionB 預測 折線圖
ggplot( data = DataRenewB) + 
  geom_point( aes(x = c(1:730), y = Sales)) + 
  geom_line( aes( x = c(1:730),
                  y = Model.B.All$fitted.values,
                  colour = 'red'))
ggsave("C:/Users/USER/Desktop/R語言/Rstudio/ch10 迴歸分析/圖片/9-5/7-2 RegionB 預測 折線圖.png", width = 10, height = 10, dpi = 600)


# 8.探討模型的準確度及誤差
## RMSE 衡量誤差 (Root-Mean-Square Error)
RMSE <- function( predict, actual){ # RMSE function
  result <- sqrt(mean((predict - actual) ^ 2)) # 均方根誤差
  return(result)
}
## RegionA模型的 RMSE : 4743.127
cat('RegionA模型的RMSE：\n',RMSE(Model.A.All$fitted.values, DataRenewA$Sales),'\n',sep = '')

## RegionB模型的 RMSE : 2057.058
cat('RegionB模型的RMSE：\n',RMSE(Model.B.All$fitted.values, DataRenewB$Sales),'\n',sep ='')

## MAPE 衡量誤差 (Mean Absolute Percentage Error)
MAPE <- function( predict, actual){
  result <- mean(abs((predict - actual)/actual)) %>% round(3) * 100 # (誤差比例)絕對值平均
  return(result)
}
## RegionA模型的 MAPE：7.8%
cat('RegionA模型的MAPE：\n',MAPE(Model.A.All$fitted.values, DataRenewA$Sales),'%','\n',sep='')

## RegionB模型的 MAPE：7.3%
cat('RegionB模型的MAPE：\n',MAPE(Model.B.All$fitted.values, DataRenewB$Sales),'%','\n',sep='')


# 9.營業目標及展店的營收估計 : 透過誤差函數計算的誤差估計營收 
## 店1 一月份
January <- tibble( 'Day' = c(1:31),
                   'Sales_Upperbound' = Model.A.All$fitted.values[1:31] * 1.08,
                   'Sales_Lowerbound' = Model.A.All$fitted.values[1:31] * 0.92)

## 店1一月每日誤差範圍 線圖
ggplot( data = January)  +
  geom_segment(aes(x=Day, xend=Day, 
                   y=Sales_Upperbound, yend=Sales_Lowerbound)) +
  geom_point(  aes( x = Day,
                    y = Sales_Upperbound,
               colour = "Upper")) +
  geom_point( aes( x = Day, 
                   y = Sales_Lowerbound,
              colour = 'Lower')) + 
  labs( x = 'Day in January',
        y = 'Prediction Interval',
        title = 'Predicted Sales in January')
ggsave("C:/Users/USER/Desktop/R語言/Rstudio/ch10 迴歸分析/圖片/9-5/9.店1一月每日誤差範圍 線圖.png", width = 10, height = 10, dpi = 600)
