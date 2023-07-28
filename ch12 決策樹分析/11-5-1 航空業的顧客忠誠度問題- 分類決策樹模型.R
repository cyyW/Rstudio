library("tidyverse")
library('knitr')

# 資料載入及預處理
setwd("C:/Users/USER/Desktop/R語言/Rstudio/ch12 決策樹分析/working directory ch12")

internal.data <- read.csv("internal_data.csv", sep = ',')
survey.data <- read.csv("survey_data.csv", sep = ',')
complete.data <- merge(survey.data, internal.data,
                       by = "user_id")
head(complete.data, 5)
complete.data$user_id <- as.character(complete.data $user_id)
complete.data$credit_card_bonus <- as.factor(complete.data$credit_card_bonus)
complete.data$register_method <- as.factor(complete.data $register_method) 
complete.data$class <- as.factor(complete.data$class)

complete.data$is_loyal <- ifelse(complete.data$is_loyal == 1, 'Satisfied', 'Unsatisfied')
head(complete.data, 5)

# 考量「行銷因素」的分類模型
library(rpart) # 決策樹函數
library(rpart.plot) # install.packages("rpart.plot")

marketing.model <- rpart(is_loyal ~ dm_message + dm_post + dm_email +  credit_card_vendor + credit_card_bonus + 
                           tv_ad + youtube_ad_1 + youtube_ad_2 + youtube_ad_3, 
                         data = complete.data)
rpart.plot(marketing.model)

# 含「行銷活動」與「服務品質」的完整分類模型
full.model <- rpart(is_loyal ~ depart_on_time + arrive_on_time +
                      register_method + register_rate +
                      class + seat_rate + meal_rate +
                      flight_rate + package_rate +
                      dm_message + dm_post + dm_email +
                      credit_card_vendor + credit_card_bonus +
                      tv_ad + youtube_ad_1 + youtube_ad_2 + youtube_ad_3,
                    data = complete.data)
rpart.plot(full.model)

## 繪製 ROC 圖
library("plotROC")

predict.prob <- predict(full.model, complete.data)[,2] # 0為是,1為否

predict.table <- data.frame(true_label = complete.data$is_loyal,
                            predict_prob = predict.prob)


basic.plot <- ggplot(predict.table, aes(d = true_label, m = predict.prob)) +
  geom_roc(n.cuts = 3, labelsize = 3, labelround = 2)
basic.plot + style_roc() +
  annotate("text", x = .75, y = .25, size = 5,
           label = paste("AUC =", round(calc_auc(basic.plot)$AUC, 3)))
ggsave("C:/Users/USER/Desktop/R語言/Rstudio/ch12 決策樹分析/圖片/11-5-1/1.full.model  ROC 曲線.png", width = 10, height = 10, dpi = 600)

# 決策樹剪枝
tune.model <- rpart(is_loyal ~ depart_on_time + arrive_on_time +
                      register_method + register_rate +
                      class + seat_rate + meal_rate +
                      flight_rate + package_rate +
                      dm_message + dm_post + dm_email +
                      credit_card_vendor + credit_card_bonus +
                      tv_ad + youtube_ad_1 + youtube_ad_2 + youtube_ad_3,
                    data = complete.data,
                    cp = 0.03, # 剪枝 (不明確程度)，調高會分得少，調小會分得多
                    parms = list(split='information')) # 使用 熵(information)

rpart.plot(tune.model)

## 繪製 ROC 圖
predict.prob <- predict(tune.model, complete.data)[,2]
predict.table <- data.frame(true_label = complete.data$is_loyal,
                            predict_prob = predict.prob)


basic.plot <- ggplot(predict.table, aes(d = true_label, m = predict.prob)) +
  geom_roc(n.cuts = 3, labelsize = 3, labelround = 2)
basic.plot + style_roc() +
  annotate("text", x = .75, y = .25, size = 5,
           label = paste("AUC =", round(calc_auc(basic.plot)$AUC, 3)))
ggsave("C:/Users/USER/Desktop/R語言/Rstudio/ch12 決策樹分析/圖片/11-5-1/5.tune.model  ROC 曲線.png", width = 10, height = 10, dpi = 600)

