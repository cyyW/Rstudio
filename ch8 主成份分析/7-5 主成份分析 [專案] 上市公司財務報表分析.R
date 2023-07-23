setwd("C:/Users/USER/Desktop/R語言/Rstudio/ch8 主成份分析/working directory ch8")
library("tidyverse")

financial.data <- read_csv("2017_financial index_163 comp.csv")
head(financial.data, 5)
summary(financial.data[, 2:ncol(financial.data)])

# 變數間比次的相關程度
## cor 函數計算變數彼此間的相關係數
cor(financial.data[, 2:ncol(financial.data)])

## reshape2套件的 melt函數，把矩陣格式轉換成 tidy 資料
library(reshape2)
head(melt(cor(financial.data[, 2:ncol(financial.data)])), 5)

## geom_tile(繪製方形圖)繪製相關係數的熱圖
ggplot(melt(cor(financial.data[, 2:ncol(financial.data)])),
       aes(Var1, Var2)) +
  geom_tile(aes(fill = value), colour = "white") + # 網格
  scale_fill_gradient2(low = "firebrick4", high = "steelblue", # 漸層顏色
                       mid = "white", midpoint = 0) +
  guides(fill=guide_legend(title="Correlation")) + # 右提示標題
  theme_bw() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1),
        axis.title = element_blank())
ggsave("C:/Users/USER/Desktop/R語言/Rstudio/ch8 主成份分析/圖片/7-5/1.相關係數的熱圖.png", width = 10, height = 10, dpi = 600)


# 資料建模與分析，主成分分析
##  PCA 模型(prcomp)，標準化 scales = T
pca.model <- prcomp(financial.data[, 2:ncol(financial.data)], scale = T)
names(pca.model)
summary(pca.model) # col(各個主成分)，row(標準差、prop(變異數的比率)(解釋力)、累加prop) 

## 自行計算 (var(變異數)、 prop(變異數的比率 = 變異數 / 總變異)、 cum_prop：該主成份解釋變異數的累積比率)
var.exp <- tibble(
  pc = paste0("PC_", formatC(1:16, width=2, flag="0")), # 大多透過 pca.model 的 sdev 可推導出來
  var = pca.model$sdev^2,
  prop = (pca.model$sdev)^2 / sum((pca.model$sdev)^2),
  cum_prop = cumsum((pca.model$sdev)^2 / sum((pca.model$sdev)^2))) # 累計 prop
head(var.exp, 5)

## 主成分及方差 條狀圖
library(plotly)
p <- plot_ly(
  x = var.exp$pc,
  y = var.exp$var,
  type = "bar"
) %>%
  layout(
    title = "Variance Explained by Each Principal Component",
    xaxis = list(type = 'Principal Component', tickangle = -60),
    yaxis = list(title = 'Variance'),
    margin = list(r = 30, t = 50, b = 70, l = 50)
  )
Sys.setenv("plotly_username"="CYYW")
Sys.setenv("plotly_api_key"="7BNjcOo1YzIYCnJPBMu4")
plotly_POST(p, filename = "file-name")

## 累計變異數比率 條狀圖
p2 <- plot_ly(
  x = var.exp$pc,
  y = var.exp$cum_prop,
  type = "bar"
) %>%
  layout(
    title = "Cumulative Proportion by Each Principal Component",
    xaxis = list(type = 'Principal Component', tickangle = -60),
    yaxis = list(title = 'Proportion'),
    margin = list(r = 30, t = 50, b = 70, l = 50)
  )
p2
Sys.setenv("plotly_username"="CYYW")
Sys.setenv("plotly_api_key"="7BNjcOo1YzIYCnJPBMu4")
plotly_POST(p2, filename = "file-name")

## 觀察每一個主成份的係數，也就是特徵權重
head(pca.model$rotation, 5) # col(主成分)、row(特徵)、values(權重)

## 主成分係數熱圖
ggplot(melt(pca.model$rotation[, 1:6]), aes(Var2, Var1)) +  # 取前六個主成分
  geom_tile(aes(fill = value), colour = "white") +
  scale_fill_gradient2(low = "firebrick4", high = "steelblue",
                       mid = "white", midpoint = 0) +
  guides(fill=guide_legend(title="Coefficient")) +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1),
        axis.title = element_blank())
ggsave("C:/Users/USER/Desktop/R語言/Rstudio/ch8 主成份分析/圖片/7-5/4.主成分係數熱圖.png", width = 10, height = 10, dpi = 600)


# 非負稀疏主成份分析 :調整係數(權重)為非負數 # install.packages("nsprcomp")
set.seed(1234) # 亂數種子
library(nsprcomp) # 非負稀疏主成份分析套件 nscumcomp

## 資料導入 nscumcomp -> nspca.model
nspca.model <- nscumcomp( 
  financial.data[, 2:17], 
  k = 90, nneg = T, # k：非 0 係數個數，通常是「每個主成份期待非 0 係數個數」x 變數個數
  scale. = T)       # nneg：是否希望所有係數都非負，TRUE 代表有非負限制
print(nspca.model)

## 計算 var、prop、cum_prop -> var.exp
var.exp <- tibble(
  pc = paste0("PC_", formatC(1:16, width=2, flag="0")),
  var = nspca.model$sdev^2,
  prop = (nspca.model$sdev)^2 / sum((nspca.model$sdev)^2),
  cum_prop = cumsum((nspca.model$sdev)^2 / sum((nspca.model$sdev)^2)))
head(var.exp, 5)

## 5.(非負)主成分及方差 條狀圖
library(plotly)
p -> plot_ly(
  x = var.exp$pc,
  y = var.exp$var,
  type = "bar"
) %>%
  layout(
    title = "Variance Explained by Each Principal Component",
    xaxis = list(type = 'Principal Component', tickangle = -60),
    yaxis = list(title = 'Variance'),
    margin = list(r = 30, t = 50, b = 70, l = 50)
  )
Sys.setenv("plotly_username"="CYYW")
Sys.setenv("plotly_api_key"="7BNjcOo1YzIYCnJPBMu4")
plotly_POST(p, filename = "file-name1")
   
## 6.(非負)累計變異數比率 條狀圖
p2 <- plot_ly(
  x = var.exp$pc,
  y = var.exp$cum_prop,
  type = "bar"
) %>%
  layout(
    title = "Cumulative Proportion by Each Principal Component",
    xaxis = list(type = 'Principal Component', tickangle = -60),
    yaxis = list(title = 'Proportion'),
    margin = list(r = 30, t = 50, b = 70, l = 50)
  )
p2
Sys.setenv("plotly_username"="CYYW")
Sys.setenv("plotly_api_key"="7BNjcOo1YzIYCnJPBMu4")
plotly_POST(p2, filename = "file-name1")

## 7..(非負)稀疏主成份的係數權重 熱圖(主成分係數被收縮-更加清晰)
ggplot(melt(nspca.model$rotation[, 1:8]), aes(Var2, Var1)) +
  geom_tile(aes(fill = value), colour = "white") +
  scale_fill_gradient2(low = "white", high = "steelblue") +
  guides(fill=guide_legend(title="Coefficient")) +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1),
        axis.title = element_blank())
ggsave("C:/Users/USER/Desktop/R語言/Rstudio/ch8 主成份分析/圖片/7-5/7.(非負)稀疏主成份的係數權重 熱圖.png", width = 10, height = 10, dpi = 600)


# 公司個別分析 
## 8.主成分及其關鍵特徵(細數最大) 散佈圖
nspca.score <- data.frame(nspca.model$x) # x 為主成分的分數(每個公司)
row.names(nspca.score) <- financial.data$comp_id # row 改為公司號碼
head(nspca.score,5)

## 可觀察到在每個公司在個別主成分中最關鍵係數的好壞
p3 <- plot_ly(
  x = nspca.score[, 1],
  y = financial.data$roe,
  text = financial.data$comp_id,
  type = "scatter",
  mode = "markers"
) %>% layout(
    title = "ROE v.s. PC 1 Score: Scatter Plot",
    xaxis = list(title = 'Principal Component 1'),
    yaxis = list(title = 'Return on Equity'),
    margin = list(r = 30, t = 50, b = 70, l = 50)
  )
print(p3)
Sys.setenv("plotly_username"="CYYW")
Sys.setenv("plotly_api_key"="7BNjcOo1YzIYCnJPBMu4")
plotly_POST(p3, filename = "file-name2")

## 9.雙主成分中公司的好壞(PC2-PC3 分數散佈圖)
p4 <- plot_ly(
  x = nspca.score[, 2],
  y = nspca.score[, 3],
  text = financial.data$comp_id,
  type = "scatter",
  mode = "markers"
) %>% layout(
    title = "PC 2 v.s. PC 3 Score: Scatter Plot",
    xaxis = list(title = 'Principal Component 2'),
    yaxis = list(title = 'Principal Component 3'),
    margin = list(r = 30, t = 50, b = 70, l = 50)
)
p4
Sys.setenv("plotly_username"="CYYW")
Sys.setenv("plotly_api_key"="7BNjcOo1YzIYCnJPBMu4")
plotly_POST(p4, filename = "file-name3")