# tidyr 套件的四個的函數 gather spread separate unite
library(tidyr)

# 1. 宗教信仰及收入資料集
pew <- read_delim(
  "http://stat405.had.co.nz/data/pew.txt",
   delim = "\t"
)
pew

# gather 將 變數 轉為 value
pew.colnames <- colnames(pew) # column 名稱


pew.new <- pew %>% # %>% 為對應 gather 第一個參數，data = 資料源
  gather(key = "income", # 舊col轉value，新col名稱
         value = "cases", # 舊value，新col名稱
         pew.colnames[2:ncol(pew)]) # 舊col名稱及其舊value，都轉為新value(舊col給上key,舊value給上value)

print(pew.new)


# 2. table2 資料集整理
table2

# spread 將 value 轉為 變數
table2.new <- table2 %>%
  spread(key = "type", # 轉變數的那列資料
         value = "count", #新變數的value
         sep = '_')
table2.new


# 2. 混亂的肺炎資料集整理
setwd("C:/Users/USER/Desktop/R語言/Rstudio/ch3/working directory")
library(readr)
tb <- read_csv("tb.csv")

# 第一步，gather
tb.colnames <- colnames(tb)

tb.new <- tb %>%
  gather(key = "type",
         value = "cases",
         tb.colnames[4:ncol(tb)])
print(tb.new)

# 第二步，separate 函數分成兩個 columns
tb.new <- tb.new %>%
  separate(
    col = type, # 要分開的資料
    into = c("gender", "age"), #新col名稱
    sep = "_", #分隔符號
    convert = TRUE)
print(tb.new)


# 4. 一組資料被分成兩個column(想合併)
tb2 <- read_csv("tb_new.csv")
print(tb2)

# unite 函數合併兩個 columns
tb2.new <- tb2 %>%
  unite(col = "age", # 新 col 名
        c("age_lb", "age_ub"), # 要合併的col
        sep = "-") # 分隔符號
print(tb2.new)