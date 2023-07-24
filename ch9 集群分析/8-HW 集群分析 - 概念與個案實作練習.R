# 載入資料
library(tidyverse)
library(knitr)
setwd("C:/Users/USER/Desktop/R語言/Rstudio/ch9 集群分析/working directory ch9")
GameLog <- read.csv('Game_Log.csv')
UserTable <- read.csv('User_Table.csv')
kable(GameLog[1:10,])
kable(UserTable[1:10,])

## 題目一 ##
# 合併資料集，計算各時段的平均遊玩時間及各項目的平均購買金額 -> GameTable
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
kable(GameTable[1:5,])


# 資料標準化(連續變數) -> GameTable_T
GameTable_T <- GameTable[,2:7] %>% 
  transmute(
    Aft = (Min_Aft - min(Min_Aft)) / (max(Min_Aft)-min(Min_Aft)),
    Eve = (Min_Eve - min(Min_Eve)) / (max(Min_Eve)-min(Min_Eve)),
    Mid = (Min_Mid - min(Min_Mid)) / (max(Min_Mid)-min(Min_Mid)),
    Coin = (Buy_Coin - min(Buy_Coin)) / (max(Buy_Coin)-min(Buy_Coin)),
    Dia = (Buy_Dia - min(Buy_Dia)) / (max(Buy_Dia)-min(Buy_Dia)),
    Car = (Buy_Car - min(Buy_Car)) / (max(Buy_Car)-min(Buy_Car))
  ) 
kable(GameTable_T[1:5,])

# 集群分析 分三群 -> k
set.seed(500) 
K <- kmeans(GameTable_T, 3)

# 將分群結果和併至主完整資料集 -> ClusterResult
ClusterResult <- cbind(
  GameTable,
  K$cluster
) %>% as.data.frame()
colnames(ClusterResult)[ncol(ClusterResult)] <- 'Cluster'
kable(ClusterResult[1:5,])

# 過濾出族群一資料，並輸出下午的遊玩時間和購買金幣金之中位數
ClusterResult_1 <- ClusterResult %>%
  filter(Cluster == 1)%>%
  summarise( Aft_Median = median(Min_Aft),
             Coin_Median = median(Buy_Coin))
kable(ClusterResult_1)


## 題目二 ##
# 1.分群結果視覺化： 散佈圖
library(ggfortify) # install.packages("ggfortify")
set.seed(500)
autoplot(K, data  = GameTable_T) 
ggsave("C:/Users/USER/Desktop/R語言/Rstudio/ch9 集群分析/圖片/8-HW/1.分群結果視覺化： 散佈圖.png", width = 10, height = 10, dpi = 600)

# 2.分群特徵分布視覺化：盒鬚圖
## 合併標準化資料及分群結果 
ClusterResult_new <- cbind(
  GameTable_T,
  K$cluster
) %>% as.data.frame()
colnames(ClusterResult_new)[ncol(ClusterResult_new)] <- 'Cluster'
kable(ClusterResult_new[1:5,])
table(ClusterResult$Cluster)

## 連續變數分配
ClusterResult_new_plot <- ClusterResult_new %>% 
  gather( key = Continuous_Variable, # 連續變數欄
          value = Normalized_Value, # 標準化 values
          - c(Cluster)) # 不須動作的欄
as_tibble(ClusterResult_new_plot[1:5,])

ClusterResult_new_plot$Continuous_Variable <-  # 轉換變數型態為 factor
  ClusterResult_new_plot$Continuous_Variable %>% factor( levels = c('Mid','Aft','Eve','Coin','Dia','Car'))
as_tibble(ClusterResult_new_plot[1:5,])


## 各群玩家特徵 盒鬚圖 
ggplot( data = ClusterResult_new_plot) + 
  geom_boxplot( aes( x = Continuous_Variable, # 連續變數
                     y = Normalized_Value), # 標準化 數值
                size = 0.7) +
  facet_wrap( ~ Cluster) # 多圖，依族群(Cluster)
ggsave("C:/Users/USER/Desktop/R語言/Rstudio/ch9 集群分析/圖片/8-HW/2.分群特徵分布視覺化：盒鬚圖.png", width = 10, height = 10, dpi = 600)




