# 載入資料
library("tidyverse")
setwd("C:/Users/USER/Desktop/R語言/Rstudio/ch11 邏輯迴歸/working directory ch11")

internal.data <- read_csv("internal_data.csv")
survey.data <- read_csv("survey_data.csv")

# 資料預處理
internal.data$credit_card_vendor <- as.factor(internal.data$credit_card_vendor)

complete.data <- merge(survey.data, internal.data,
                       by = "user_id")

complete.data$user_id <- as.character(complete.data $user_id)
complete.data$credit_card_bonus <- as.factor(complete.data$credit_card_bonus)
complete.data$register_method <- as.factor(complete.data $register_method) 
complete.data$class <- as.factor(complete.data$class)

head(complete.data, 5)
colnames(complete.data)

## 第一題 ##
# full.mode
full.mode <- glm(is_loyal ~ depart_on_time + arrive_on_time + register_method + 
                 register_rate + class + seat_rate + meal_rate + flight_rate + package_rate + 
                 tv_ad + youtube_ad_1 + youtube_ad_2 + youtube_ad_3 + 
                 dm_message + dm_post + dm_email + 
                 credit_card_vendor + credit_card_bonus + coupon,
                 data = complete.data, family = binomial(link="logit")) 
summary(full.mode)

# final.model
final.model <- glm(is_loyal ~ depart_on_time + arrive_on_time + 
                   class + seat_rate + meal_rate + flight_rate + 
                   tv_ad + dm_message + credit_card_bonus + coupon,
                 data = complete.data, family = binomial(link="logit")) 
summary(final.model)


predict.prob <- predict(final.model, complete.data, type = "response") # response 得到每一個個體的機率
library(InformationValue)
opt.cutoff <- optimalCutoff(complete.data$is_loyal, predict.prob)[1] 

# 模糊矩陣
confusionMatrix(complete.data$is_loyal, predict.prob, threshold = opt.cutoff) # threshold = 零界機率

# 精確度(precision)
precision(complete.data$is_loyal, predict.prob, threshold = opt.cutoff)
# 敏感度 (Sensitivity)
sensitivity(complete.data$is_loyal, predict.prob, threshold = opt.cutoff)
# 明確度 (Specificity)
specificity(complete.data$is_loyal, predict.prob, threshold = opt.cutoff)

## 繪製 ROC 曲線 
library("plotROC") # install.packages("devtools") # devtools::install_github("sachsmc/plotROC")

predict.table <- data.frame(true_label = complete.data$is_loyal, # 真實 Y
                            predict_prob = predict.prob) # 預測機率分數

basic.plot <- ggplot(predict.table, aes(d = true_label, m = predict.prob)) +
  geom_roc(n.cuts = 3, labelsize = 3, labelround = 2)
basic.plot + style_roc() +
  annotate("text", x = .75, y = .25, size = 5,
           label = paste("AUC =", round(calc_auc(basic.plot)$AUC, 3)))
ggsave("C:/Users/USER/Desktop/R語言/Rstudio/ch11 邏輯迴歸/圖片/10-HW/1.final model ROC 曲線.png", width = 10, height = 10, dpi = 600)


## 題目二 ##
#  final.model 的係數 bar chart
summary.table <- data.frame(var_name = names(coefficients(final.model)),
                            coefficient = coefficients(final.model))

summary.table <- summary.table %>%
  filter(var_name %in% names(coefficients(final.model)) &
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
ggsave("C:/Users/USER/Desktop/R語言/Rstudio/ch11 邏輯迴歸/圖片/10-HW/2.final.model 的係數長條圖.png", width = 10, height = 10, dpi = 600)


# 機率密度圖 Density Plot of Predict Probability
predict.table$true_label <- as_factor(predict.table$true_label)

ggplot(predict.table, aes(predict.prob, fill = true_label, colour = true_label)) +
  geom_density(alpha = 0.3) +
  xlab("Predict Probability") + ylab("Density") +
  ggtitle("Density Plot of Predict Probability") +
  theme_bw()
ggsave("C:/Users/USER/Desktop/R語言/Rstudio/ch11 邏輯迴歸/圖片/10-HW/3.機率密度圖 Density Plot of Predict Probability.png", width = 10, height = 8, dpi = 600)



