mtcars.tb <- as.tibble(mtcars)
mtcars.tb 


# mutate
# 1.增加新 column
mtcars.tb %>%
  mutate(
    cyl2 = cyl * 2,
    cyl4 = cyl2 * 2
  )

# 2.取代舊 column
mtcars.tb %>%
  mutate(
    mpg = NULL, # 把 col(mpg) 刪除 
    disp = disp * 0.0163871 #取代原有的
  )


# 3. transmute 從 tibble 提取新建立的變數(新創一個 tibble)
mtcars.tb %>%
  transmute(displ_l = disp / 61.0237)
