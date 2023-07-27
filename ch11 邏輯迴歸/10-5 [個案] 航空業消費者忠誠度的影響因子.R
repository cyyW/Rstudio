# 載入資料
library("tidyverse")
setwd("C:/Users/USER/Desktop/R語言/Rstudio/ch11 邏輯迴歸/working directory ch11")

internal.data <- read_csv("internal_data.csv")
internal.data$credit_card_vendor <- as.factor(internal.data$credit_card_vendor)

survey.data <- read_csv("survey_data.csv")

head(internal.data, 5)
head(survey.data, 5)

# 資料預處理
complete.data <- merge(survey.data, internal.data,
                       by = "user_id")
head(complete.data, 5)

complete.data$user_id <- as.character(complete.data $user_id)
complete.data$credit_card_bonus <- as.factor(complete.data$credit_card_bonus)
complete.data$register_method <- as.factor(complete.data $register_method) 
complete.data$class <- as.factor(complete.data$class)

## 將因子轉換成01的形式表達
library(caret) # install.packages("caret")

dummy_data <- dummyVars(" ~ . - user_id", data = complete.data, , sep = "_")
dummy_data <- predict(dummy_data, newdata = complete.data)
complete.data.new <- cbind(complete.data["user_id"], dummy_data)
head(complete.data.new, 5)

# 資料探索
## cor 函數計算變數彼此間的相關係數
cor(complete.data.new[, 2:ncol(complete.data.new)])[1:5, 1:5]

## melt 轉換表格為「變數 1 - 變數 2 - 相關係數」
library(reshape2)
head(melt(cor(complete.data.new[, 2:ncol(complete.data.new)])), 5)

## 繪製相關係數 熱圖
ggplot(melt(cor(complete.data.new[, 2:ncol(complete.data.new)])),
       aes(Var1, Var2)) +
  geom_tile(aes(fill = value), colour = "white") +
  scale_fill_gradient2(low = "firebrick4", high = "steelblue",
                       mid = "white", midpoint = 0) +
  guides(fill=guide_legend(title="Correlation")) +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1),
        axis.title = element_blank())
ggsave("C:/Users/USER/Desktop/R語言/Rstudio/ch11 邏輯迴歸/圖片/10-5/1.相關係數 熱圖.png", width = 10, height = 10, dpi = 600)


# 資料建模與分析
## 1.「行銷因素」邏輯迴歸模型 glm函式 訓練 -> marketing.model
marketing.model <- glm(is_loyal ~ dm_message + dm_post + dm_email +              
                         credit_card_vendor + credit_card_bonus + 
                         tv_ad + youtube_ad_1 + youtube_ad_2 + youtube_ad_3, 
                       data = complete.data, family = binomial(link="logit")) # binomial 二項式
summary(marketing.model)

## predict(model, data, type) 函數得到模型估計的 p -> predict.prob
predict.prob <- predict(marketing.model, complete.data, type = "response") # response 得到每一個個體的機率

## InformationValue 套件 得到使分類誤差最小的 optimalCutoff
install.packages("C:/Users/USER/Desktop/R語言/Rstudio/ch11 邏輯迴歸/working directory ch11/InformationValue_1.2.3.tar.gz", repos = NULL, type = "source")
library(InformationValue)

## optimalCutoff 找出哪一個"零界機率(opt.cutoff)"可以最小化我們的分類誤差
opt.cutoff <- optimalCutoff(complete.data$is_loyal, predict.prob)[1] 

## 模糊矩陣
confusionMatrix(complete.data$is_loyal, predict.prob, threshold = opt.cutoff) # threshold = 零界機率

## 預測錯誤率(misClassError)
misClassError(complete.data$is_loyal, predict.prob, threshold = opt.cutoff)
## 精確度(precision)
precision(complete.data$is_loyal, predict.prob, threshold = opt.cutoff)
## 召回度 / 敏感度 (Recall / Sensitivity)
sensitivity(complete.data$is_loyal, predict.prob, threshold = opt.cutoff)
## 明確度 (Specificity)
specificity(complete.data$is_loyal, predict.prob, threshold = opt.cutoff)

## 繪製 ROC 曲線 (AUC 曲線下面積越大，代表模型分類效果越好)
library("plotROC") # install.packages("devtools") # devtools::install_github("sachsmc/plotROC")

predict.table <- data.frame(true_label = complete.data$is_loyal, # 真實 Y
                            predict_prob = predict.prob) # 預測機率分數

basic.plot <- ggplot(predict.table, aes(d = true_label, m = predict.prob)) +
  geom_roc(n.cuts = 3, labelsize = 3, labelround = 2)
basic.plot + style_roc() +
  annotate("text", x = .75, y = .25, size = 5,
           label = paste("AUC =", round(calc_auc(basic.plot)$AUC, 3)))
ggsave("C:/Users/USER/Desktop/R語言/Rstudio/ch11 邏輯迴歸/圖片/10-5/2.行銷因素 ROC 曲線.png", width = 10, height = 10, dpi = 600)


## 2. 考量「服務品質因素」的邏輯迴規模型
service.model <- glm(is_loyal ~
                       depart_on_time + arrive_on_time + # 服務因素
                       register_method + register_rate +
                       class + seat_rate + meal_rate +
                       flight_rate + package_rate,
                     data=complete.data, family=binomial(link="logit"))
summary(service.model)

predict.prob <- predict(service.model, complete.data, type="response")
opt.cutoff <- optimalCutoff(complete.data$is_loyal, predict.prob)[1] 

misClassError(complete.data$is_loyal, predict.prob, threshold = opt.cutoff) # 0.247
precision(complete.data$is_loyal, predict.prob, threshold = opt.cutoff) # 0.7815249
sensitivity(complete.data$is_loyal, predict.prob, threshold = opt.cutoff) # 0.844691
specificity(complete.data$is_loyal, predict.prob, threshold = opt.cutoff) # 0.596206

predict.table <- data.frame(true_label = complete.data$is_loyal,
                            predict_prob = predict.prob)
## ROC 曲線 (AUC：0.794)
basic.plot <- ggplot(predict.table, aes(d = true_label, m = predict.prob)) +
  geom_roc(n.cuts = 3, labelsize = 3, labelround = 2)
basic.plot + style_roc() +
  annotate("text", x = .75, y = .25, size = 5,
           label = paste("AUC =", round(calc_auc(basic.plot)$AUC, 3)))
ggsave("C:/Users/USER/Desktop/R語言/Rstudio/ch11 邏輯迴歸/圖片/10-5/3.服務品質因素 ROC 曲線.png", width = 10, height = 10, dpi = 600)

# 3.包含「行銷活動」與「服務品質」
## 對客戶忠誠度有顯著"正面"及"負面"影響的變數
full.model <- glm(is_loyal ~ depart_on_time + arrive_on_time +
                    register_method + register_rate +
                    class + seat_rate + meal_rate +
                    flight_rate + package_rate +
                    dm_message + dm_post + dm_email +
                    credit_card_vendor + credit_card_bonus +
                    tv_ad + youtube_ad_1 + youtube_ad_2 + youtube_ad_3,
                  data = complete.data,
                  family = binomial(link="logit"))

summary(full.model)

predict.prob <- predict(full.model, complete.data, type="response")
opt.cutoff <- optimalCutoff(complete.data$is_loyal, predict.prob)[1] 
confusionMatrix(complete.data$is_loyal, predict.prob, threshold = opt.cutoff)

misClassError(complete.data$is_loyal, predict.prob, threshold = opt.cutoff) # 0.095
sensitivity(complete.data$is_loyal, predict.prob, threshold = opt.cutoff) # 0.9477021
specificity(complete.data$is_loyal, predict.prob, threshold = opt.cutoff) # 0.8319783

predict.table <- data.frame(true_label = complete.data$is_loyal,
                            predict_prob = predict.prob)

# ROC 曲線 (AUC : 0.971)
basic.plot <- ggplot(predict.table, aes(d = true_label, m = predict.prob)) +
  geom_roc(n.cuts = 3, labelsize = 3, labelround = 2)
basic.plot + style_roc() +
  annotate("text", x = .75, y = .25, size = 5,
           label = paste("AUC =", round(calc_auc(basic.plot)$AUC, 3)))
ggsave("C:/Users/USER/Desktop/R語言/Rstudio/ch11 邏輯迴歸/圖片/10-5/4.行銷與服務 ROC 曲線.png", width = 10, height = 10, dpi = 600)

# 製作報告圖表
## 5.邏輯回歸視覺化 長條圖
summary.table <- data.frame(var_name = names(coefficients(full.model)),
                            coefficient = coefficients(full.model))
summary.table <- summary.table %>%
  filter(var_name %in% names(coefficients(marketing.model)) &
           var_name != "(Intercept)")
## 按系數大小為表進行排序
summary.table <- summary.table[sort(summary.table$coefficient, index.return = T)$ix, ]

summary.table$var_name <- factor(summary.table$var_name,
                                 levels = summary.table$var_name)
ggplot(data = summary.table,
       aes(x = var_name, y = coefficient)) +
  geom_bar(aes(fill = var_name),
           position = "dodge",
           stat = "identity",
           show.legend = FALSE) +
  theme_bw(base_size = 14) +
  labs(title = "Direct marketing approach is not that useful ...",
       x = "Marketing Strategy", y = "Impact on Cusomer Loyalty") +
  coord_flip() 
ggsave("C:/Users/USER/Desktop/R語言/Rstudio/ch11 邏輯迴歸/圖片/10-5/5.邏輯回歸視覺化 長條圖.png", width = 10, height = 10, dpi = 600)

## 6.行銷因素 邏輯回歸視覺化 長條圖
summary.table <- data.frame(var_name = names(coefficients(marketing.model)),
                            coefficient = coefficients(marketing.model))
summary.table <- summary.table %>%
  filter(var_name != "(Intercept)")

summary.table <- summary.table[sort(summary.table$coefficient, index.return = T)$ix, ]

summary.table$var_name <- factor(summary.table$var_name,
                                 levels = summary.table$var_name)

ggplot(data = summary.table,
       aes(x = var_name, y = coefficient)) +
  geom_bar(aes(fill = var_name),
           position = "dodge",
           stat = "identity",
           show.legend = FALSE) +
  theme_bw(base_size = 14) +
  labs(title = "While most strategies are effective, we should
          reconsider Youtube Ad 1 and text message.",
       x = "Marketing Strategy", y = "Impact on Cusomer Loyalty") +
  coord_flip() 
ggsave("C:/Users/USER/Desktop/R語言/Rstudio/ch11 邏輯迴歸/圖片/10-5/6.行銷因素 邏輯回歸視覺化 長條圖.png", width = 10, height = 10, dpi = 600)

## 7.DM 及忠誠度 長條圖
var.names <- c("dm_post", "dm_email", "dm_message")

summary.table <- complete.data %>%
    group_by_(treatment = var.names[1]) %>%
    summarize(num_member = length(user_id),
              num_loyal = sum(is_loyal))

summary.table$var_name <- var.names[1] 

for(i in 2:3){
  temp <- complete.data %>%
    group_by_(treatment = var.names[i]) %>%
    summarize(num_member = length(user_id),
              num_loyal = sum(is_loyal))
  temp$var_name <- var.names[i] 
  summary.table <- rbind(summary.table, temp)
}
summary.table$proportion <- summary.table$num_loyal / summary.table$num_member

summary.table$treatment <- as.factor(summary.table$treatment)
summary.table$var_name <- as.factor(summary.table$var_name)

# Plot the result
ggplot(data = summary.table,
       aes(x = var_name, y = proportion)) +
  geom_bar(aes(fill = treatment),
           position = "dodge",
           stat = "identity") +
  theme_bw(base_size = 14) +
  labs(x = "DM Campaign", y = "Proportion of Loyal Members",
       title = "While DM is useful, mobile message is not a good channel.")
ggsave("C:/Users/USER/Desktop/R語言/Rstudio/ch11 邏輯迴歸/圖片/10-5/7.DM 及忠誠度 長條圖.png", width = 10, height = 10, dpi = 600)

## 8.1 vendor 及顧客忠誠度 長條圖
summary.table <- complete.data %>%
  group_by(credit_card_vendor) %>%
  summarize(num_member = length(user_id),
            num_loyal = sum(is_loyal))
summary.table$proportion <- summary.table$num_loyal / summary.table$num_member

# Visualize the result
ggplot(data = summary.table, aes(x = credit_card_vendor, y = proportion)) +
  geom_bar(aes(fill = credit_card_vendor), position = "dodge", stat = "identity") +
  theme_bw(base_size = 14) +
  labs(x = "Credit Card Vendor", y = "Proportion of Loyal Members",
       title = "While credit card vendors seems to be important ...")
ggsave("C:/Users/USER/Desktop/R語言/Rstudio/ch11 邏輯迴歸/圖片/10-5/8.1 vendor 及顧客忠誠度 長條圖.png", width = 10, height = 10, dpi = 600)

## 8.2 vendor及紅利等級 顧客忠誠度 長條圖
summary.table <- complete.data %>%
  group_by(credit_card_vendor, credit_card_bonus) %>%
  summarize(num_member = length(user_id),
            num_loyal = sum(is_loyal))
summary.table$proportion <- summary.table$num_loyal / summary.table$num_member

summary.table$credit_card_bonus <- as.factor(summary.table$credit_card_bonus)

ggplot(data = summary.table, aes(x = credit_card_vendor, y = proportion)) +
  geom_bar(aes(fill = credit_card_bonus), position = "dodge", stat = "identity") +
  theme_bw(base_size = 14) +
  labs(x = "Credit Card Vendor", y = "Proportion of Loyal Members",
       title = "... the root cause is bonus level.")
ggsave("C:/Users/USER/Desktop/R語言/Rstudio/ch11 邏輯迴歸/圖片/10-5/8.2 vendor及紅利等級 顧客忠誠度 長條圖.png", width = 10, height = 10, dpi = 600)

## 9.廣告 顧客忠誠度 直條圖
var.names <- c("tv_ad", "youtube_ad_1", "youtube_ad_2", "youtube_ad_3")
summary.table <- complete.data %>%
    group_by_(treatment = var.names[1]) %>%
    summarize(num_member = length(user_id),
              num_loyal = sum(is_loyal))
summary.table$var_name <- var.names[1] 
for(i in 2:4){
  temp <- complete.data %>%
    group_by_(treatment = var.names[i]) %>%
    summarize(num_member = length(user_id),
              num_loyal = sum(is_loyal))
  temp$var_name <- var.names[i] 
  summary.table <- rbind(summary.table, temp)
}
summary.table$proportion <- summary.table$num_loyal / summary.table$num_member

summary.table$treatment <- as.factor(summary.table$treatment)
summary.table$var_name <- as.factor(summary.table$var_name)

ggplot(data = summary.table,
       aes(x = var_name, y = proportion)) +
  geom_bar(aes(fill = treatment),
           position = "dodge",
           stat = "identity") +
  theme_bw(base_size = 14) +
  labs(x = "Advertisement", y = "Proportion of Loyal Members",
       title = "TV Ad is very strong, but Youtube Ad1 is problematic.")
ggsave("C:/Users/USER/Desktop/R語言/Rstudio/ch11 邏輯迴歸/圖片/10-5/9.廣告 顧客忠誠度 直條圖.png", width = 10, height = 10, dpi = 600)
