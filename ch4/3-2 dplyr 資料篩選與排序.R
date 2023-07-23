library(dplyr)


# mtcars，裡面有 1973 - 1974 年 32 款汽車的相關變數 11 種
mtcars.tb <- as_tibble(mtcars)
print(mtcars.tb)
names(mtcars.tb)

# 1. 利用 filter(過濾)函數篩選出需要的 row
# 篩選出一加侖汽油的可以跑超過 20 km 且馬力超過 100 匹馬力的汽車
mtcars.tb %>%
  filter(mpg>20, hp>100)


# 2. 利用 select(搜尋)函數篩選出需要的 column
# 只需要看「一加侖汽油可跑距離」、「馬力」、與「前進檔數」三個變數
mtcars.tb %>%
  select(mpg, hp, gear)


# filter(過濾)加select(搜尋)
# 篩選出一加侖汽油的可以跑超過 20 km 且馬力超過 100 匹馬力汽車的「前進檔數
mtcars.tb %>%
  filter(mpg>20, hp>100) %>%
  select(gear)


# 3. 利用 arrange 函數進行資料排序(預設小到大)(大到小 desc())
mtcars.tb %>%
  arrange(cyl, disp) # 先 cyl 小到大，後 cyl 小到大

mtcars.tb %>%
  arrange(desc(disp)) # desc(大到小)
