
data(iris)

# 建立 A 矩陣
A <- matrix(0, nrow = nrow(iris), ncol = nrow(iris))

#方法1
# 歐式距離函式(Euclidean distance)
euclidean_distance <- function(vec1, vec2) {
  sqrt(sum((vec1 - vec2)^2))
}

# 使用 for 迴圈計算歐式距離個花朵間的歐式距離
for (i in 1:nrow(iris)) {
  for (j in 1:nrow(iris)) {
    A[i, j] <- euclidean_distance(iris[i, 1:4], iris[j, 1:4])
  }
}

print(A)
head(A,5)[,1:5]

# 方法2
# 老師的方法
for(i in 1:150){
  for(j in 1:150){
    for(k in 1:4){
      A[i,j] <- A[i, j] + (iris[i, k] - iris[j, k])^2
    }
  }
}

A <- sqrt(A)
print(A)
head(A,5)[,1:5]