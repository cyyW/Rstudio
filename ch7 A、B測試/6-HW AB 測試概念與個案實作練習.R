# 載入資料
setwd("C:/Users/USER/Desktop/R語言/Rstudio/ch7 A、B測試/working directory ch7")
library(tidyverse)

test.table <- read.csv("test_table.csv")
user.table <- read.csv("user_table.csv")
head(test.table)
head(user.table)

# 資料預處理 -> test.data
test.data <- left_join(test.table, user.table, by = "user_id")
test.data <- as_tibble(test.data)
head(test.data)

test.data$date <- as.Date(test.data$date, format = "%Y/%m/%d")

for (i in c(3, 4, 6, 7, 9)){
    test.data[,i] <- as.factor(test.data[[i]])}

head(test.data)

## 題目一 ##

# 篩選日本地區資料 -> teat.JP.table
teat.JP.table <- test.data %>%
                   filter(country == "JP") 
head(teat.JP.table)

# t檢定 : greater(實驗>對照) -> (t = -63.113, df = 9953.1, p-value = 1)
t.test(teat.JP.table[teat.JP.table$test == "1", ]$purchase_amount, # 實驗組(test)
       teat.JP.table[teat.JP.table$test == "0", ]$purchase_amount, # 對照組(control)
       alternative = "greater") # greater 更好(test > control) 

# t檢定 : less(實驗<對照) -> (t = -63.113, df = 9953.1, p-value < 2.2e-16)
t.test(teat.JP.table[teat.JP.table$test == "1", ]$purchase_amount, # 實驗組(test)
       teat.JP.table[teat.JP.table$test == "0", ]$purchase_amount, # 對照組(control)
       alternative = "less") # greater 更好(test > control) 


# 機率密度圖 Density Plot by JP
ggplot(teat.JP.table, aes(purchase_amount, fill = test, colour = test)) +
  geom_density(alpha = 0.3) +
  xlab("Purchase Amount") + ylab("Density") +
  ggtitle("JP-Density Plot of Purchase Amount: Test versus Control") +
  theme_bw()
ggsave("C:/Users/USER/Desktop/R語言/Rstudio/ch7 A、B測試/Image/JP.實驗及對照組 機率密度圖.png", width = 10, height = 8, dpi = 600)



## 題目二 ##

# ANOVA模型 -> (test : Pr(>F) <2e-16 ***), (device : Pr(>F) <2e-16 ***), (service : Pr(>F) <2e-16 ***)
aov.model <- aov(
  purchase_amount ~ test + device + gender + service, 
  teat.JP.table) # 沿用 JP 資料
summary(aov.model)

# ggplot2 繪製購買金額對應不同服務的盒狀圖 (boxplot)
ggplot(teat.JP.table, aes(x = service, y = purchase_amount)) +
  geom_boxplot() +
  xlab("service") + ylab("Purchase Amount") +
  ggtitle("Boxplot of Purchase Amount by service") +
  theme_bw() +
  theme(aspect.ratio = 0.8)
ggsave("C:/Users/USER/Desktop/R語言/Rstudio/ch7 A、B測試/Image/JP.服務-購買量 盒鬚圖.png", width = 10, height = 8, dpi = 600)

# Tukey 事後檢定，了解 test 對於購買金額的影響，並繪製信賴區間圖
TukeyHSD(aov.model, "test")
par(pin = c(10,6))
plot(TukeyHSD(aov.model, "test"))


#Tukey 事後檢定，了解 device 對於購買金額的影響，並繪製信賴區間圖
TukeyHSD(aov.model, "device")
par(pin = c(10,6))
plot(TukeyHSD(aov.model, "device"))