# 布林 True and False
3 > 5
6 > 5


# any 一個True就只輸出Ture， all 一個False就只輸出False，
# And， & 個別比較
set.seed(0) #亂數種子
x <- runif(8, -1, 1) #隨機 機率相同
x

0 <= x & x <= 0.5

all((0 <= x) & (x <= 0.5))

x[0 <= x & x <= 0.5] <- 999 # 符合條件改999
x

# Or， | 個別比較
x <- runif(8, -1, 1)
x

-0.5 >= x | x >= 0.5 

any(-0.5 >= x | x >= 0.5)

x[-0.5 >= x | x >= 0.5] <- 999 # Elementwise AND
x



# If and Else (跟 Java很像)
x <- 1
if (x > 0) {
  y <- 5
} else {
  y <- 10
}
y

# ifelse function (快速版)(布林,True,False)
y <- ifelse(x > 0, 5, 10)
y 

# Switch 對的話就輸出對的
switch("first", first = 1 + 1, second = 1 + 2, third = 1 + 3)
switch("second", first = 1 + 1, second = 1 + 2, third = 1 + 3)
switch("third", first = 1 + 1, second = 1 + 2, third = 1 + 3)