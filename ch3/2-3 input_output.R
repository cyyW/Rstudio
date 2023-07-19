# 設置工作目錄（working directory）
setwd("C:/Users/USER/Desktop/R語言/Rstudio/ch3/working directory")

#開啟外部檔案 read_
library(readr)

read_csv("file1.csv") # 逗號(,)分隔csv檔
read_csv2("file2.csv") # 分號(；)分隔csv檔
read_delim("file3.txt", delim = "|") # 自訂(delim)分隔檔案
read_tsv("file4.tsv") # tab("\t")分隔檔案


# 輸出檔案 write_
# 例 : write_csv(tibble, 檔案名稱, ...)

write_delim(read_delim("file3.txt", delim = "|"),
            "file3_write.txt", delim = "|") # write_delim 多一個 (delim = "") 參數


# 輸入 Excel 檔
library(readxl)

excel_sheets("datasets.xlsx") # 看 sheets 名
read_excel("datasets.xlsx") # 讀取 Excel 檔 (默認第一個 sheet)
read_excel("datasets.xlsx", sheet = "chickwts") # 指定 sheet
read_excel("datasets.xlsx", sheet = 4) # 指定 sheet，從1開始

read_excel("datasets.xlsx", range = cell_rows(1:4)) # range 範圍，row(數字範圍，1 為 col 名稱) 
read_excel("datasets.xlsx", range = cell_cols("B:D")) # range 範圍，col(A...向右)
read_excel("datasets.xlsx", range = "mtcars!B1:D5") # range 範圍，mtcars(指定兩個儲存格範圍)

read_excel("datasets.xlsx", na = "setosa") # 從表中去掉不要的值改為 NA 