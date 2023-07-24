library(tidyverse)
library(knitr)

# 載入資料
setwd("C:/Users/USER/Desktop/R語言/Rstudio/ch9 集群分析/working directory ch9")
GameLog <- read.csv('Game_Log.csv')
UserTable <- read.csv('User_Table.csv')

kable(GameLog[1:10,])
kable(UserTable[1:10,])

# 整理合併資料
GameTable <- GameLog %>%
  group_by(User_Id) %>%
  summarise(
    Min_Aft = mean(Min_Aft),
    Min_Eve = mean(Min_Eve),
    Min_Mid = mean(Min_Mid),
    Buy_Coin = mean(Buy_Coin),
    Buy_Dia = mean(Buy_Dia),
    Buy_Car = mean(Buy_Car)) %>%
  inner_join(UserTable, by = "User_Id")

kable(GameTable[1:10,])
summary(GameTable)

# 資料標準化
## 連續數值變數標準化「以最大最小值為1和0的尺度中」
GameTable <- GameTable[,2:7] %>%
  mutate(
    Aft = (Min_Aft - min(Min_Aft)) / (max(Min_Aft)-min(Min_Aft)),
    Eve = (Min_Eve - min(Min_Eve)) / (max(Min_Eve)-min(Min_Eve)),
    Mid = (Min_Mid - min(Min_Mid)) / (max(Min_Mid)-min(Min_Mid)),
    Coin = (Buy_Coin - min(Buy_Coin)) / (max(Buy_Coin)-min(Buy_Coin)),
    Dia = (Buy_Dia - min(Buy_Dia)) / (max(Buy_Dia)-min(Buy_Dia)),
    Car = (Buy_Car - min(Buy_Car)) / (max(Buy_Car)-min(Buy_Car))
  ) %>% cbind(
    GameTable[,c(8,9)] # 將第八第九列資料和併(剩餘類別資料)
  )
kable(GameTable[1:10,])

## 類別變數標準化 用 model.matrix() 「轉換為1和0」
DummyTable <- model.matrix( ~ Identity + Telecom, data = GameTable) #(~欄位, data = 表格)
kable(DummyTable[1:10,])

## 標準化資料表 -> GameTabl
GameTable <- cbind(
  GameTable[, -c(1:6,13,14)], # 數值，只取標準化資料
  DummyTable[, -1] # 類別，去除截距欄(Intercept)
)
kable(GameTable[1:5,])

# 資料探索
## cor 觀察變數間的相關性
library(reshape2)

CorMatrix <- melt(cor(GameTable))
kable(CorMatrix[ 1:5,])

## 1.變數相關性 熱密度圖
ggplot( data = CorMatrix) +
        
  geom_tile(aes(Var1, Var2,fill = value), colour = "white") + 
  
  scale_fill_gradient2(low = "firebrick4", high = "steelblue") +
  
  guides(fill=guide_legend(title="Correlation")) +

  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1),
        axis.title = element_blank())
ggsave("C:/Users/USER/Desktop/R語言/Rstudio/ch9 集群分析/圖片/8-5/1.變數相關性 熱密度圖.png", width = 10, height = 10, dpi = 600)

## 階層分析法 : 大概可分三到四群
set.seed(500)
Distance <- dist(GameTable, method = 'euclidean') # dist()函數計算歐式距離

hclust(Distance, method = 'complete') %>% plot() # hclust() 群聚分析 2.階層分析法 

# 資料建模與分析
## 分三群
set.seed(500) 
K <- kmeans(GameTable,3) #kmeans 分三群

ClusterResult <- cbind(
  GameTable,
  K$cluster # 各玩家族群
) %>% as.data.frame()
ClusterResult[1:10,]

colnames(ClusterResult)[ncol(ClusterResult)] <- 'Cluster' #改欄名

table(ClusterResult$Cluster) # 查看各群數量

## 連續變數分配
ClusterResultForPlot <- ClusterResult %>%
  gather( key = Continuous_Variable, # 連續變數欄
          value = Normalized_Value, # 標準化 values
          - c(IdentityNovice, IdentityVeteran, Telecomother, Cluster)) # 不須動作的欄
ClusterResultForPlot[1:5,]

ClusterResultForPlot$Continuous_Variable <-  # 轉換變數型態為 factor
  ClusterResultForPlot$Continuous_Variable %>% factor( levels = c('Mid','Aft','Eve','Coin','Dia','Car'))
kable(ClusterResultForPlot[1:5,])

## 各群玩家特徵 盒鬚圖 ## 族群1 感覺分不夠細
ggplot( data = ClusterResultForPlot) + 
  geom_boxplot( aes( x = Continuous_Variable, # 連續變數
                     y = Normalized_Value), # 標準化 數值
                size = 0.7) +
  facet_wrap( ~ Cluster) # 多圖，依族群(Cluster)
ggsave("C:/Users/USER/Desktop/R語言/Rstudio/ch9 集群分析/圖片/8-5/3.各群玩家特徵(三群) 盒鬚圖.png", width = 10, height = 10, dpi = 600)


# 分為四群
set.seed(500) 
K <- kmeans(GameTable,4)

ClusterResult <- cbind(
  GameTable,
  K$cluster
) %>% as.data.frame()

colnames(ClusterResult)[ncol(ClusterResult)] <- 'Cluster'

table(ClusterResult$Cluster)

## 連續變數分配
ClusterResultForPlot <- ClusterResult %>%
  gather( key = Continuous_Variable, # 連續變數欄
          value = Normalized_Value, # 標準化 values
          - c(IdentityNovice, IdentityVeteran, Telecomother, Cluster)) # 不須動作的欄
ClusterResultForPlot[1:5,]

ClusterResultForPlot$Continuous_Variable <-  # 轉換變數型態為 factor
  ClusterResultForPlot$Continuous_Variable %>% factor( levels = c('Mid','Aft','Eve','Coin','Dia','Car'))
kable(ClusterResultForPlot[1:5,])

## 各群玩家特徵 盒鬚圖 (四群)
ggplot( data = ClusterResultForPlot) + 
  geom_boxplot( aes( x = Continuous_Variable, # 連續變數
                     y = Normalized_Value), # 標準化 數值
                size = 0.7) +
  facet_wrap( ~ Cluster) # 多圖，依族群(Cluster)
ggsave("C:/Users/USER/Desktop/R語言/Rstudio/ch9 集群分析/圖片/8-5/4.各群玩家特徵(四群) 盒鬚圖.png", width = 10, height = 10, dpi = 600)

## 群體特徵描述 - 類別變數
## 再重新製作一次 GameTableResult 避免資料渾雜
GameTableResult <-  GameLog %>% # 遊戲數據
  group_by(User_Id) %>% # 依玩家分組
  summarise(
    Min_Aft = mean(Min_Aft),
    Min_Eve = mean(Min_Eve),
    Min_Mid = mean(Min_Mid),
    Buy_Coin = mean(Buy_Coin),
    Buy_Dia = mean(Buy_Dia),
    Buy_Car = mean(Buy_Car)
  ) %>%
  inner_join(UserTable, by = 'User_Id') %>% # 依玩家合併玩家資料
    cbind( K$cluster) %>%  # 合併分群結果
    as.data.frame()

colnames(GameTableResult)[ncol(GameTableResult)] <- 'Cluster' # 更改欄位名稱
kable(GameTableResult[1:5,])
summary(GameTableResult)

## 各群(玩家身份)累計次數 直調圖
ggplot( data = GameTableResult) +
  geom_bar( aes( x = Identity)) + 
  facet_wrap( ~ Cluster)
ggsave("C:/Users/USER/Desktop/R語言/Rstudio/ch9 集群分析/圖片/8-5/5.各群(玩家身份)累計次數 直調圖.png", width = 10, height = 10, dpi = 600)


## 各群(電信業者)累計次數 直調圖
ggplot( data = GameTableResult) +
  geom_bar( aes( x = Telecom)) + 
  facet_wrap( ~ Cluster)
ggsave("C:/Users/USER/Desktop/R語言/Rstudio/ch9 集群分析/圖片/8-5/6.各群(電信業者)累計次數 直調圖.png", width = 10, height = 10, dpi = 600)


# 分群結果的視覺化 - 納入主成份分析
## 使用行為(連續變數)的分群 散佈圖
library(ggfortify) # install.packages("ggfortify")
set.seed(500)
autoplot(kmeans(GameTable[,1:6], 4), data  = GameTable) #data = 標準化資料 # autoplot() 在绘制k-means聚类的时候，默认使用主成分分析（Principal Component Analysis，PCA）来对数据进行降维
ggsave("C:/Users/USER/Desktop/R語言/Rstudio/ch9 集群分析/圖片/8-5/7.使用行為(連續變數)的分群 散佈圖.png", width = 10, height = 10, dpi = 600)

GameTable[1:5,]