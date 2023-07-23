# 不同於 4-2 及 4-3 只針對 key 
# 集合運算是針對"所有值"


table.A <- tribble(
  ~var_1, ~var_2,
  "1-1", "1-2",
  "2-1", "2-2",
  "3-1", "3-2-A"
)

table.B <- tribble(
  ~var_1, ~var_2,
  "1-1", "1-2",
  "2-1", "2-2",
  "3-1", "3-2-B",
  "5-1", "5-2"
)

table.A
table.B

# intersect(x, y)：交集(row 所有值都相同)
intersect(table.A, table.B)

# union(x, y)：聯集(回傳所有 row，不重複)
union(table.A, table.B)

# setdiff(x, y): x扣掉所有與y相同的row
table.A %>% setdiff(table.B)
table.B %>% setdiff(table.A)