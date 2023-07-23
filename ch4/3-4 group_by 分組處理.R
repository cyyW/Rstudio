library(dplyr)

mtcars.tb <- as.tibble(mtcars)
mtcars.tb 

# group_by，依據指定 COL 的 value 去分組
mtcars.tb %>%
  group_by(cyl)

# brower() 去看看 group_by 的執行狀況
mtcars.tb %>%
  group_by(cyl) %>%
  do(browser())

# group_by 加 summarise，計算各組總結並組合建立新 tibble 
mtcars.tb %>%
  group_by(cyl) %>%
  summarise(
    number = n(), # 各組資料數量
    avg_hp = mean(hp),
    sd_hp = sd(hp), 
    max_hp = max(hp),
    min_hp = min(hp)) %>%
  arrange(desc(avg_hp)) 

# group_by 分組篩選資料，找出每組最大馬力的三輛車資料
mtcars.tb %>%
  group_by(cyl) %>%
  filter(rank(desc(hp))<4) %>%
  arrange(desc(cyl), desc(hp))