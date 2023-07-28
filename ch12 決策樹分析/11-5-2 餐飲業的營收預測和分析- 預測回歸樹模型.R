library("tidyverse")
library('knitr')

# 資料載入
setwd("C:/Users/USER/Desktop/R語言/Rstudio/ch12 決策樹分析/working directory ch12")
SalesData  <- read.csv("Restaurant_Sales_Renew.csv", sep = ',')
head(SalesData, 5)

# 區域A的迴歸樹模型
library(rpart)
library(rpart.plot)

SalesDataA <- SalesData %>% filter(Region %in% "A")
Model.A.All <- rpart( Sales ~ ., 
                      data = SalesDataA[,-c(1,2)]) # 去除1、2欄

rpart.plot(Model.A.All)

# 區域B的迴歸樹模型
SalesDataB <- SalesData %>% filter( Region %in% 'B')
Model.B.All <- rpart( Sales ~ ., 
                      data = SalesDataB[,-c(1,2,4)])

rpart.plot(Model.B.All)

# 衡量預測成果(誤差)
## RMSE
RMSE <- function( predict, actual){
  result <- sqrt(mean((predict - actual) ^ 2))
}
cat('RegionA模型的RMSE：\n',RMSE(predict(Model.A.All, SalesDataA), SalesDataA$Sales),'\n',sep = '') # 5389.392
cat('RegionB模型的RMSE：\n',RMSE(predict(Model.B.All, SalesDataB), SalesDataB$Sales),'\n',sep ='') # 2335.283

## MAPE
MAPE <- function( predict, actual){
  result <- mean(abs((predict - actual)/actual)) %>% round(3) * 100
}
cat('RegionA模型的MAPE：\n',MAPE(predict(Model.A.All, SalesDataA), SalesDataA$Sales),'%','\n',sep='') # 9.3%
cat('RegionB模型的MAPE：\n',MAPE(predict(Model.B.All, SalesDataB), SalesDataB$Sales),'%','\n',sep='') # 8.2%

# 決策樹剪枝(增枝)
Model.B.Tune <- rpart( Sales ~ ., 
                      data = SalesDataB[,-c(1,2)],
                      cp = 0.005) # 將其調小

rpart.plot(Model.B.Tune)

## RMSE
RMSE <- function( predict, actual){
  result <- sqrt(mean((predict - actual) ^ 2))
}
cat('RegionB模型的RMSE：\n',RMSE(predict(Model.B.Tune, SalesDataB), SalesDataB$Sales),'\n',sep = '') # 2198.875

## MAPE
MAPE <- function( predict, actual){
  result <- mean(abs((predict - actual)/actual)) %>% round(3) * 100
}
cat('RegionB模型的MAPE：\n',MAPE(predict(Model.B.Tune, SalesDataB), SalesDataB$Sales),'%','\n',sep='') # 7.7%