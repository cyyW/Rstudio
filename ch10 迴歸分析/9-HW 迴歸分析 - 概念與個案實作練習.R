library(tidyverse)
library(knitr)

setwd("C:/Users/USER/Desktop/R語言/Rstudio/ch10 迴歸分析/working directory ch10")
SalesData <- read.csv('Restaurant_Sales_Renew.csv')
kable(SalesData[1:5,])

## 題目一 ##
# 篩選出 RegionB 的資料
DataB <- SalesData %>%
  filter(Region == "B")
kable(DataB[1:5,])

# 建立回歸模型並分析
Model.B<- lm( Sales ~ Type + Weekday + Holiday + Store2_Event + Type*Weekday + Type*Holiday, 
              data = DataB)
summary(Model.B)

## 題目二 ##
# Beta Coefficients 長條圖
Beta <- cbind(
  names(Model.B$coefficients), # 影響變數名
  Model.B$coefficients # 影響程度
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
ggsave("C:/Users/USER/Desktop/R語言/Rstudio/ch10 迴歸分析/圖片/9-HW/Beta Coefficients 長條圖.png", width = 10, height = 10, dpi = 600)

# MAPE 衡量誤差
MAPE <- function( predict, actual){
  result <- mean(abs((predict - actual)/actual)) %>% round(3) * 100 # (誤差比例)絕對值平均
  return(result)
}

cat('RegionA模型的MAPE：\n',MAPE(Model.B$fitted.values, DataB$Sales),'%','\n',sep='')

