# 1.不用函式
# 建立 datafram df
df <- data.frame(
  a = rnorm(10), # rnorm(random normal) 隨機自然數
  b = rnorm(10),
  c = rnorm(10),
  d = rnorm(10)
)

df

# Normalize the Data (壓縮至0~1)，不用函數好麻煩
df$a <- (df$a - min(df$a, na.rm = TRUE)) / 
  (max(df$a, na.rm = TRUE) - min(df$a, na.rm = TRUE))
df$b <- (df$b - min(df$b, na.rm = TRUE)) / 
  (max(df$b, na.rm = TRUE) - min(df$a, na.rm = TRUE))
df$c <- (df$c - min(df$c, na.rm = TRUE)) / 
  (max(df$c, na.rm = TRUE) - min(df$c, na.rm = TRUE))
df$d <- (df$d - min(df$d, na.rm = TRUE)) / 
  (max(df$d, na.rm = TRUE) - min(df$d, na.rm = TRUE))

df

# 2.使用函式
# 再建立 datafram df
df <- data.frame(
  a = rnorm(10),
  b = rnorm(10),
  c = rnorm(10),
  d = rnorm(10)
)

# 創建函數 RescaleByRange，完成上面(壓縮至0~1)
# range(向量) 會回傳 c(向量最小值[1], 向量最大值[2])
RescaleByRange <- function(x){
  rng <- range(x, na.rm = TRUE)
  return((x - rng[1]) / (rng[2] - rng[1]))
}

# 土方法
(df$a - min(df$a, na.rm = TRUE)) / 
  (max(df$a, na.rm = TRUE) - min(df$a, na.rm = TRUE))

# 使用函式
RescaleByRange(df$a)



# Exercise
SummarizeData <- function(x){

  summary.df <- data.frame(x_mean = mean(x, na.rm = TRUE),
                           x_var = var(x, na.rm = TRUE),
                           x_max = max(x, na.rm = TRUE),
                           x_min = min(x, na.rm = TRUE),
                           x_median = median(x, na.rm = TRUE))
  return(summary.df)
}

SummarizeData(rnorm(10))


SummarizeData2 <- function(x){
  sdf <- data.frame(x_mean = mean(x),
                    x_var = var(x),
                    x_max = max(x),
                    x_min = min(x),
                    x_median = median(x))
  return(sdf)
}

SummarizeData2(df$a)
