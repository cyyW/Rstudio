library(tibble)

iris # datafram 很長

iris2 <- as_tibble(iris) # dataframe轉成tibble
iris2

# 建立 tibble (column)
tibble(x = 1:5, y = 1, z = x ^ 2 + y)

# 建立 tribble ~col (row) 
tribble(~x, ~y, ~z,
        "a", 2, 3.6,
        "b", 1, 8.5)


# 添加 add_
df <- tibble(x = 1:3, y = 3:1)

add_row(df, x = 4, y = 0) # add_row
add_row(df, x = 4, y = 0, .before = 2) # .before = 插入第幾個
add_row(df, x = 4:5, y = 0:-1) # : 加兩 row 
add_row(df, x = 4) # 沒 y 出 N/A

add_column(df, z = -1:1, w = 0)  # add_column 


# 合併資料 dplyr 套件中的 bind_rows(向下) 與 bind_cols(向右) 函數。
library(dplyr)

bind_rows(iris2[1:5, ], iris2[6:10, ]) # bind_rows
bind_cols(iris2[, 1:2], iris2[, 3:4]) # bind_cols


# tibble 與 dataframe 差異
df <- data.frame(
  abc = 1:10, 
  def = runif(10), 
  xyz = sample(letters, 10)
)
tb <- as_tibble(df) # as.tibble , dataframe 轉 tibble

df$a # 呼叫名稱不嚴謹
tb$a # 不打全名無法呼叫

df[, 1] # datafram 回傳變 向量
df[, 1:2] # 呼叫2d 變回傳 datafram
tb[, 1] # tibble 回傳還是 tibble
tb[, 1:2]
tb[[1]] # 雙 [] 回傳 向量

class(as.data.frame(tb)) # as.data.frame ，tibble 轉 dataframe