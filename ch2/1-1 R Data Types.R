# 1.1 R Data Types

# 1. 向量(Vectors) 

# 透過函數 c() (combine) 將類別相同的元素合併在同一個 
a <- c(1,2,5.3,6,-2,4)
print(a)

#r 與 python 不同，從1開始，數字尾沒減1
a <- 2:9
a
# 索引也相同
a[c(2, 4)]

# 單個索引不用 c[]
a[3] <- 2 * a[3]
a

# 塞選特定值 T,F
b <- c("one", "two", "three") 
b == "one"

b[b == "one"]


# 2. 矩陣(Matrices)

# 建立矩陣，ROW(向右)、COL(向下)，預設為COL先執行
M <- matrix(c('a','a','b','c','b','a'), nrow = 2, ncol = 3)
print(M)

# 改為先執行ROW(向右)
M <- matrix( c('a','a','b','c','b','a'), nrow = 2, ncol = 3, byrow = TRUE)
print(M)

# 建立 array c(向量內容) dim = c(維度排列),與 pytorch 不同是由小到大維度排列，與矩陣(Matrices)不同先向右再向下
a <- array(c('green', 'yellow'), dim = c(3, 3, 2))
print(a)

# Matrix Manipulation
A <- matrix(c(1,2,3,4), nrow = 2, ncol = 2)
B <- matrix(c(1,1,2,2), nrow = 2, ncol = 2)
A
B

# * 一般相乘，兩矩陣相同位置相乘
A * B

# %*% 矩陣相乘，線性代數
A %*% B

#轉置矩陣
t(A)

#反矩陣
solve(A)

# 求線性系統 Ax=b 的解 A−1b
b <- c(1,1)
solve(A, b)
solve(A) %*% b


# 3. 列表Lists

# Create a list. ,可以包含不同資料屬性的資料
list1 <- list(c(2,5,3), 21.3, sin)

# Print the list.
print(list1)


# 跟辭典類似可命名
list2  <- list(vector = c(2,5,3),
               numeric = 21.3,
               func = sin)

# Print names of list and list itself.
names(list2)
print(list2)


# 4. 因子(Factros)

# Create a vector.
apple_colors <- c('green','green','yellow','red','red','red','green')

# 建立 Factros
factor_apple <- factor(apple_colors)

# Print the factor.
print(factor_apple) #所有 factor_apple 及每個因子(不重複)
print(nlevels(factor_apple)) #幾種因子


# 5. Data Frames ，有缺點建議用 tibbles

# 建立 data frame(建法1)，名稱在上面
name <- c("David", "Hsi", "Jessie")
age <- c("24", "25", "36")
gender <- c("Male", "Male", "Female")

data1 <- data.frame(name, age, gender)
data1

# 建立 data frame(建法2)，名稱在上面
data2 <- data.frame(
  name = c("David", "Hsi", "Jessie"),
  age = c("24", "25", "36"),
  gender = c("Male", "Male", "Female")
)
data2

head(data2) #顯示資料框架前六比資料(預設是 6)。
colnames(data2) <- c("Var_1", "Var_2","Var_3") # col 命名或改名
rownames(data2) <- c("1", "2", "3") # row 命名或改名
data2
summary(data2) #顯示資料基本資訊。


# 6. 資料結構的常用函數

# length(object) : 元素個素、長度
x <- c(1, 1, 2, 2, 3, 3, 4, 4)
length(x)

# unique(object) : 該物件的獨立元素，去除重複
unique(x)

# str(object) : 輸出該物件的基本架構
data2 <- data.frame(
  name = c("David", "Hsi", "Jessie", "David", "Hsi"),
  age = c("24", "25", "36", "24", "30"),
  gender = c("Male", "Male", "Female", "Male", "Male")
)

data2
unique(data2)
str(data2)

# class(object) : 該物件屬於哪種資料結構
class(data2)

# names(object) : 物件中元素(上index)的名稱
names(data2)

# c(object,object,...) : 將物件合併為一個向量
# object : 印出物件
# rm(object) : 從工作空間中移除物件