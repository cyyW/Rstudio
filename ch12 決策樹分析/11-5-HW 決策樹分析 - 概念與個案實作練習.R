library("tidyverse")
library('knitr')

# 資料載入及預處理
setwd("C:/Users/USER/Desktop/R語言/Rstudio/ch12 決策樹分析/working directory ch12")

survey.data <- read.csv("survey_data.csv", sep = ',')
SalesData  <- read.csv("Restaurant_Sales_Renew.csv", sep = ',')


survey.data$user_id <- as.character(survey.data $user_id)
survey.data$register_method <- as.factor(survey.data $register_method) 
survey.data$class <- as.factor(survey.data$class)

survey.data$is_loyal <- ifelse(survey.data$is_loyal == 1, 'Satisfied', 'Unsatisfied')

head(as_tibble(survey.data), 5)
head(as_tibble(SalesData), 5)

## 題目一 ## 
# 服務品質 決策樹分析(熵) 
library(rpart) # 決策樹函數
library(rpart.plot) # install.packages("rpart.plot")

survey.model <- rpart(is_loyal ~ depart_on_time + arrive_on_time + register_method + 
                      register_rate + class + seat_rate + 
                      meal_rate + flight_rate + package_rate, 
                      data = survey.data,
                      parms = list(split='information'))
rpart.plot(survey.model)

# 計算 AUC
predict.prob <- predict(survey.model, survey.data)[,2]
predict.table <- data.frame(true_label = survey.data$is_loyal,
                            predict_prob = predict.prob)


basic.plot <- ggplot(predict.table, aes(d = true_label, m = predict.prob)) +
  geom_roc(n.cuts = 3, labelsize = 3, labelround = 2)
basic.plot + style_roc() +
  annotate("text", x = .75, y = .25, size = 5,
           label = paste("AUC =", round(calc_auc(basic.plot)$AUC, 3)))
ggsave("C:/Users/USER/Desktop/R語言/Rstudio/ch12 決策樹分析/圖片/11-5-HW/5.survey.model ROC 曲線.png", width = 10, height = 10, dpi = 600)


## 題目二 ## 
# 篩選 RegionA 資料集
SalesDataA <- SalesData %>% filter(Region %in% "A")
head(SalesDataA, 5)

# 迴歸樹模型
Model.A.All <- rpart( Sales ~ ., 
                      data = SalesDataA[,-c(1,2)],
                      cp = 0.005) # 去除1、2欄

rpart.plot(Model.A.All)

# MAPE 衡量分類
MAPE <- function( predict, actual){
  result <- mean(abs((predict - actual)/actual)) %>% round(3) * 100
}
cat('RegionA模型的MAPE：\n',MAPE(predict(Model.A.All, SalesDataA), SalesDataA$Sales),'%','\n',sep='') # 9.3%
