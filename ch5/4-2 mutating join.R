table.A <- tribble(
  ~key, ~val_A,
  1, "a_val_1",
  2, "a_val_2",
  3, "a_val_3",
  4, "a_val_4"
)

table.B <- tribble(
  ~key, ~val_B,
  1, "b_val_1",
  2, "b_val_2",
  5, "b_val_5"
)

# Inner Join(交集)
table.A %>% 
  inner_join(table.B)

# Full join(聯集)，缺值補 NA
table.A %>% 
  full_join(table.B)

# Left Join(左併)，依左表的key去合併值
table.A %>% 
  left_join(table.B)

#Right join(右併)，依右表的key去合併值
table.A %>% 
  right_join(table.B)



# 3. 多重鍵值的資料表進行合併
# 單邊重複，table.A的foreign_key重複，table.B的key不重複
table.A <- tribble(
  ~key, ~val_A, ~foreign_key,
  "A1", "a_val_1", "B1",
  "A2", "a_val_2", "B1",
  "A3", "a_val_3", "B2",
  "A4", "a_val_4", "B2"
)

table.B <- tribble(
  ~key, ~val_B,
  "B1", "b_val_1",
  "B2", "bb_val_2"
)

table.A %>%  # left_join 好用(把附表併入主表)
  left_join(table.B, by = c("foreign_key" = "key"))

# 兩張資料表都有重複鍵值 (many-to-many)
table.A <- tribble(
  ~key, ~val_A, ~foreign_key,
  "A1", "a_val_1", "B1",
  "A2", "a_val_2", "B1",
  "A3", "a_val_3", "B2",
  "A4", "a_val_4", "B2"
)

table.B <- tribble(
  ~key, ~val_B,
  "B1", "b_val_1",
  "B2", "bb_val_2.1",
  "B2", "bb_val_2.2"
)

table.A %>%  # 多對多要設定 relationship = "many-to-many"
  left_join(table.B, by = c("foreign_key" = "key"),  relationship = "many-to-many")