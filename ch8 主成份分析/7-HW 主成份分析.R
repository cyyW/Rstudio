# 資料載入
setwd("C:/Users/USER/Desktop/R語言/Rstudio/ch8 主成份分析/working directory ch8")
library("tidyverse")

financial.data <- read_csv("2017_financial index_163 comp.csv")
head(financial.data, 5)
summary(financial.data[, 2:ncol(financial.data)])

## 第一題 ##

# financial.data1 <- 增加新變數(col) : sales_margin_rate、profit_indicator、t_roa 
financial.data1 <- financial.data %>%
  mutate(
    sales_margin_rate = roa / asset_turnover,
    profit_indicator = roa*(1+asset_growth_rate),
    t_roa = exp(roa/10) / (1+exp(roa/10))) # 將 roa 標準化
summary(financial.data1[, 2:ncol(financial.data1)])

# ROA 變數的直方圖
qplot(financial.data1$roa, geom="histogram")
ggsave("C:/Users/USER/Desktop/R語言/Rstudio/ch8 主成份分析/圖片/7-HW/1.ROA 變數的直方圖.png", width = 10, height = 8, dpi = 600)

# t_ROA 變數的直方圖
qplot(financial.data1$t_roa, geom="histogram")
ggsave("C:/Users/USER/Desktop/R語言/Rstudio/ch8 主成份分析/圖片/7-HW/2.t_ROA 變數的直方圖.png", width = 10, height = 8, dpi = 600)



## 第二題 ##

# 非負稀疏主成份分析 
set.seed(500) 
library(nsprcomp)
library(plotly) 

## 資料導入 nscumcomp -> nspca.model
nspca.model <- nscumcomp( 
  financial.data1[, 2:(ncol(financial.data1)-1)], 
  k = 100, nneg = T, # k：非 0 係數個數，通常是「每個主成份期待非 0 係數個數」x 變數個數
  scale. = T)        # nneg：是否希望所有係數都非負，TRUE 代表有非負限制
print(nspca.model)
summary(nspca.model)

## 計算 var、prop、cum_prop -> var.exp
var.exp <- tibble(
  pc = paste0("PC_", formatC(1:18, width=2, flag="0")),
  var = nspca.model$sdev^2,
  prop = (nspca.model$sdev)^2 / sum((nspca.model$sdev)^2),
  cum_prop = cumsum((nspca.model$sdev)^2 / sum((nspca.model$sdev)^2)))
print(var.exp)

# 累計變異比率 直方圖
ggplot(data = var.exp, aes(x = pc, y = cum_prop)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  geom_text((aes(label = round(cum_prop, 3))), vjust = -0.5, color = "black", size = 3.5) +
  scale_x_discrete(limits = var.exp$pc) +
  labs(x = "PC", y = "cum_prop", title = "cum_prop by PC") +
  theme_bw()
ggsave("C:/Users/USER/Desktop/R語言/Rstudio/ch8 主成份分析/圖片/7-HW/3.累計變異比率 直方圖.png", width = 10, height = 10, dpi = 600)

# 主成份係數矩陣的熱圖 (heatmap)
library(reshape2) # install.packages("reshape2")

ggplot(melt(nspca.model$rotation[, 1:7]), aes(Var2, Var1)) +
  geom_tile(aes(fill = value), colour = "white") +
  scale_fill_gradient2(low = "white", high = "steelblue") +
  guides(fill=guide_legend(title="Coefficient")) +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1),
        axis.title = element_blank())
ggsave("C:/Users/USER/Desktop/R語言/Rstudio/ch8 主成份分析/圖片/7-HW/4.主成份係數矩陣的熱圖 (heatmap).png", width = 10, height = 10, dpi = 600)

# PC1-PC2 分數散佈圖
library(plotly)
nspca.score <- data.frame(nspca.model$x)
row.names(nspca.score) <- financial.data$comp_id
head(nspca.score)
nspca.score[,1] 
p <- plot_ly(
  x = nspca.score[, 1], # pc1 score
  y = nspca.score[, 2], # pc2 score
  text = financial.data$comp_id,
  type = "scatter",
  mode = "markers"
) %>% layout(
    title = "PC 1 v.s. PC 2 Score: Scatter Plot",
    xaxis = list(title = 'Principal Component 1'),
    yaxis = list(title = 'Principal Component 2'),
    margin = list(r = 30, t = 50, b = 70, l = 50)
  )
Sys.setenv("plotly_username"="CYYW")
Sys.setenv("plotly_api_key"="7BNjcOo1YzIYCnJPBMu4")
plotly_POST(p, filename = "file-name4")