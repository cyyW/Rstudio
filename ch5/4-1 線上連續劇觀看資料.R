setwd("C:/Users/USER/Desktop/R語言/Rstudio/ch5/working directory ch5")

library(readr)

watch.table <- read.csv("watch_table.csv")
user.table <- read_csv("user_table.csv")
drame.table <- read_csv("drama_table.csv")

watch.table
user.table
drame.table

# 三表合併 full.table 
full.table <- watch.table %>% 
  left_join(user.table, by = "user_id") %>% 
  left_join(drame.table, by = "drama_id")

print(full.table)

# 每部劇 男性/女性的觀看次數
full.table %>% 
  group_by(drama_id, gender) %>%
  summarise(view_cont = length(watch_id)) 

# 每部劇 男性/女性的觀看人數
full.table %>% 
  group_by(drama_id, gender) %>%
  summarise(view_cont = length(unique(user_id))) 