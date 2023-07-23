library("tidyverse")
library("knitr")

setwd("C:/Users/USER/Desktop/R語言/Rstudio/ch7 A、B測試/working directory ch7")
test.table <- read_csv("test_table.csv")
user.table <- read_csv("user_table.csv")

kable(test.table[1:10,])
kable(user.table[1:10,])


# 資料驗證
## "user_table 中不重複使用者數量: 20000"
print(paste("user_table 中不重複使用者數量:",
            nrow(unique(select(user.table, user_id)))))

## "test_table 中不重複使用者數量: 19871"
print(paste("test_table 中不重複使用者數量:",
            nrow(unique(select(test.table, user_id)))))

## "重複出現在user_table與test_table中不重複使用者數量: 19871"
print(paste("重複出現在user_table與test_table中不重複使用者數量:",
            nrow(unique(
              inner_join(select(test.table, user_id),
                         select(user.table, user_id),
                         by = "user_id")))))
## "實驗組次數: 50012"
print(paste("實驗組次數:",
            sum(unique(test.table)$test == 1)))
## "對照組次數: 49986"
print(paste("對照組次數:",
            sum(unique(test.table)$test == 0)))


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

# summary 查看初步敘述統計結果
summary(test.data)


# 每一個維度對購買量的差異
## 實驗與對照組的差異(0:灰, 1:綠)
test.data %>%
  group_by(test) %>%
  summarise(mean_purchase_amount = mean(purchase_amount))

## 設備間的差異
test.data %>%
  group_by(device) %>%
  summarise(mean_purchase_amount = mean(purchase_amount))

## 性別的差異
test.data %>%
  group_by(gender) %>%
  summarise(mean_purchase_amount = mean(purchase_amount))

## 國家與實驗的交互影響
test.data %>%
  group_by(country, test) %>%
  summarise(mean_purchase_amount = mean(purchase_amount))

# 資料分析
## 假設檢定：獨立樣本 t 檢定(t.test): t = 100.88, df = 99961, p-value < 2.2e-16(超小)(可拒絕H0)
t.test(test.data[test.data$test == 1, ]$purchase_amount, # 實驗組(test)
       test.data[test.data$test == 0, ]$purchase_amount, # 對照組(control)
       alternative = "greater") # greater 更好， test 比 control

## 影響購物金額的重要原因 ，aov(因子的方差分析(差異度))，主要看 p-value 及 * 數(顯著程度)
aov.model <- aov(
  purchase_amount ~ test + country + device + gender + service, # aov(購物量~多因子,資料源)
  test.data)
summary(aov.model)

## test於其他因子組合(交互作用)，對購物量的差異程度
interaction.model <- aov(
  purchase_amount ~ test*country + test*device + test*service, # 組合(因子*因子)
  test.data)
summary(interaction.model)

## 影響最顯著的各個因子
interaction.model <- aov(
  purchase_amount ~ test*country + device + service, # 上面三顆星的
  test.data)
summary(interaction.model)

# Tukey 事後檢定(TukeyHSD)：了解每個因子的影響程度，回答「平均購買金額差異為多少？」
## diff : 平均差異, (lwr ~ upr) : 信賴區間, p adj : 校正後的 p 值，校正後的 p 值越小，代表這些組別之間的差異越可能是真正存在的
TukeyHSD(interaction.model, "test")
TukeyHSD(interaction.model, "country")

plot(TukeyHSD(interaction.model, "country"))


