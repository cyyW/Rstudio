setwd("C:/Users/USER/Desktop/R語言/Rstudio/ch5/working directory ch5")

library(readr)

watch.table <- read.csv("watch_table.csv")
user.table <- read_csv("user_table.csv")
drame.table <- read_csv("drama_table.csv")

user.table

# semi_join：table.A 篩選出有出現在 table.B 的個體 (輸出以A表為主，Key有在A"也有"在B)
user.table %>%
  semi_join(watch.table, by = "user_id")

# anti_join：table.A 篩選出沒出現在 table.B 的個體 (輸出以A表為主，Key有在A"沒有"在B)
user.table %>%
  anti_join(watch.table, by = "user_id")