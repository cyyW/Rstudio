library("tidyverse")
library("knitr")

setwd("C:/Users/USER/Desktop/R語言/Rstudio/ch7 A、B測試/working directory ch7")
test.table <- read_csv("test_table.csv")
user.table <- read_csv("user_table.csv")

kable(test.table[1:10,])
kable(user.table[1:10,])

# 資料預處理
## 合併兩表 -> test.data
test.data <- left_join(test.table,
                       user.table,
                       by = "user_id")
kable(test.data[1:10,])
head(test.data)

## 轉換資料型態
test.data$date <- as.Date(test.data$date, format = "%Y/%m/%d")

for(i in c(3,4,6,7,9)){
  test.data[, i] <- as.factor(test.data[[i]])} # test.data[[i]]，第 i col的所有 values

head(test.data)

# 圖表呈現-實驗組與對照組是否有顯著差異
## 1."實驗組" 及" 對照組" ，隨 "時間" 的購買量變化及差別(折線圖)
daily.purchase <- test.data %>%
  group_by(date, test) %>%
  summarise(purchase_amount = mean(purchase_amount))

ggplot(daily.purchase, aes(x = date, y = purchase_amount, colour = test)) + 
  geom_point() + geom_line() +
  xlab("Date") + ylab("Purchase Amount") + ylim(c(30, 50)) +
  ggtitle("Time Series Plot of Purchase Amount: Test versus Control") +
  theme_bw() +
ggsave("C:/Users/USER/Desktop/R語言/Rstudio/ch7 A、B測試/Image/2.實驗及對照組 機率密度圖.png", width = 10, height = 8, dpi = 600)


## 2."實驗" 及" 對照" ，一月兩組的差別(機率密度圖 geom_densit)
ggplot(test.data, aes(purchase_amount, fill = test, colour = test)) +
  geom_density(alpha = 0.3) +
  xlab("Purchase Amount") + ylab("Density") +
  ggtitle("Density Plot of Purchase Amount: Test versus Control") +
  theme_bw()
ggsave("C:/Users/USER/Desktop/R語言/Rstudio/ch7 A、B測試/Image/2.實驗及對照組 機率密度圖.png", width = 10, height = 8, dpi = 600)

## 3.哪些因素會影響使用者的消費金額(國家-購買量 盒鬚圖)
ggplot(test.data, aes(x = country, y = purchase_amount)) +
  geom_boxplot() +
  xlab("Country") + ylab("Purchase Amount") +
  ggtitle("Boxplot of Purchase Amount by Country") +
  theme_bw() +
  theme(aspect.ratio = 0.8)
ggsave("C:/Users/USER/Desktop/R語言/Rstudio/ch7 A、B測試/Image/3.各國-購買量 盒鬚圖.png", width = 10, height = 8, dpi = 600)

## 4.test*country交互因素 - 購買量 (盒鬚圖)
ggplot(test.data, aes(x = country, y = purchase_amount, colour = test)) +
  geom_boxplot() +
  xlab("Country") + ylab("Purchase Amount") +
  ggtitle("Boxplot of Purchase Amount by Country: Test versus Control") +
  theme_bw() +
  theme(aspect.ratio = 0.8)
ggsave("C:/Users/USER/Desktop/R語言/Rstudio/ch7 A、B測試/Image/4.(test X country)-購買量 盒鬚圖.png", width = 10, height = 8, dpi = 600)

