# Rstudio
R語言學習

課程 : [R語言和商業分析-洞悉商業世界中的資料科學](https://hahow.in/courses/5b0c13932ea496001e2387b9)

## 環境
* R `4.3.1`
* 介面 : Vscode

## 課堂作業 
**作業1** : iris 資料集合的統計分析 
* 問題1 [試圖撰寫函數 SummarizeData(data.frame)](https://github.com/cyyW/Rstudio/blob/main/ch2/1-homework.R)：
  * 輸入：名為 data.frame 的資料框架，該函數將計算計算 data.frame 的統計量
  * 輸出：名為 output 的資料框架，output columns 的值依序為 data.frame 每個 column 的平均數（mean）、變異數（var）、最大值（max）、最小值（min），每個 row 是 data.frame 的一個 column
* 問題2 [歐式距離 (Euclidean distance)](https://github.com/cyyW/Rstudio/blob/main/ch2/1-homework2.R) :
  * 定義第 i 朵花與第 j 朵花的差異程度為兩朵花資料的歐式距離 (Euclidean distance)，其中 xik 代表第 i 朵花在 iris資料集合中第 k 個變數的數值。試著用 for 迴圈建立一個 150 x 150 的矩陣 A，其中 Aij=d(i,j)。
 
**作業2** :「元大寶來台灣卓越50證券投資信託基金」(俗稱 0050) 成分股從 2011 年到 2015 年的股價資料，用 tidyr 進行資料整理
* 問題1 根據tidy 原則，這個資料集合有下列問題
  * 1.Column 其實是值而不是變數；2.把變數當成值 ；3.一個變數被分存在不同 columns 中
* 問題2 請利用 gather 函數，將資料整理成以下四個 columns 的格式（只顯示前 6 個 row）
  * security_id, type, date, price
* 問題3 請利用 spread 函數，將資料整理成包含以下四個 columns 的格式
  * securty_id, date, open, close
* 問題4 上一個問題完成後的資料集合，date 的資料裡面是 yyyy/mm/dd 的形式，我們希望將資料的年、月、日分開為三個 columns。請問該資料的程式碼應該如何撰寫？
* 答2~4 code : [2-HW TWSE_Stock data.R](https://github.com/cyyW/Rstudio/blob/main/ch3/2-HW%20TWSE_Stock%20data.R)
