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
 
**作業2** : 第三章 R 語言與 Tidy 資料原則 - 股市資料整理 
* 作業說明 : 「元大寶來台灣卓越50證券投資信託基金」成分股從 2011 年到 2015 年的股價資料，用 tidyr 進行資料整理 
* 完整代碼 : [2-HW TWSE_Stock data.R](https://github.com/cyyW/Rstudio/blob/main/ch3/2-HW%20TWSE_Stock%20data.R)
* 作品呈現 : [第 3 章，作業 1 - Ch 2 - R 語言與 Tidy 資料原則 - 股市資料整理](https://western-rule-4a4.notion.site/3-1-Ch-2-R-Tidy-ef3c1d8d98e940099ce0243c460d948b?pvs=4)

**作業3** : 第七章 A/B 測試概念與個案實作練習 [(詳細背景)](https://github.com/cyyW/Rstudio/blob/main/ch7%20A%E3%80%81B%E6%B8%AC%E8%A9%A6/ch%207%20%E8%B3%87%E6%96%99%E8%83%8C%E6%99%AF.pdf)
* 作業說明 : 利用「使用者購買行為」的資料集分析實驗設計的結果，了解影響消費者購買金額的重要變因，並探究哪個因素最能夠影響實驗結果。 
* 完整代碼 : [6-HW AB 測試概念與個案實作練習.R](https://github.com/cyyW/Rstudio/blob/main/ch7%20A%E3%80%81B%E6%B8%AC%E8%A9%A6/6-HW%20AB%20%E6%B8%AC%E8%A9%A6%E6%A6%82%E5%BF%B5%E8%88%87%E5%80%8B%E6%A1%88%E5%AF%A6%E4%BD%9C%E7%B7%B4%E7%BF%92.R)
* 作品呈現 : [第 7 章，作業 1 - A/B 測試概念與個案實作練習](https://western-rule-4a4.notion.site/7-1-A-B-bcb1bd28630349b7a567323a6f83fde6?pvs=4)

**作業4** : 第八章 主成份分析 - 概念與個案實作練習 [(詳細背景)](https://github.com/cyyW/Rstudio/blob/main/ch8%20%E4%B8%BB%E6%88%90%E4%BB%BD%E5%88%86%E6%9E%90/7-5%20%E8%B3%87%E6%96%99%E8%83%8C%E6%99%AF.pdf)
* 作業說明 : 利用「上市公司財務數據」資料集合進行主成份分析，了解上市公司的財務狀況，得到有價值的洞見。 
* 完整代碼 : [7-HW 主成份分析.R](https://github.com/cyyW/Rstudio/blob/main/ch8%20%E4%B8%BB%E6%88%90%E4%BB%BD%E5%88%86%E6%9E%90/7-HW%20%E4%B8%BB%E6%88%90%E4%BB%BD%E5%88%86%E6%9E%90.R)
* 作品呈現 : [第 8 章，作業 1 - Ch 7 - 主成份分析 - 概念與個案實作練習](https://western-rule-4a4.notion.site/8-1-Ch-7-9e945ec6980b4203b7a4749ef68d7bd2?pvs=4)

**作業5** : 第九章 集群分析 - 概念與個案實作練習 [(詳細背景)](https://github.com/cyyW/Rstudio/blob/main/ch9%20%E9%9B%86%E7%BE%A4%E5%88%86%E6%9E%90/%E7%AC%AC%E4%B9%9D%E7%AB%A0%20%E5%80%8B%E6%A1%88%E8%83%8C%E6%99%AF.pdf)
* 作業說明 : 利用「手機遊戲使用者行為」的資料集實作集群分析，試著再用不同的角度針對使用者的行為進行分群，將分群結果視覺化後，描述個群體的特徵，並提供適當的決策建議。 
* 完整代碼 : [8-HW 集群分析 - 概念與個案實作練習.R](https://github.com/cyyW/Rstudio/blob/main/ch9%20%E9%9B%86%E7%BE%A4%E5%88%86%E6%9E%90/8-HW%20%E9%9B%86%E7%BE%A4%E5%88%86%E6%9E%90%20-%20%E6%A6%82%E5%BF%B5%E8%88%87%E5%80%8B%E6%A1%88%E5%AF%A6%E4%BD%9C%E7%B7%B4%E7%BF%92.R)
* 作品呈現 : [第 9 章，作業 1 - Ch 8 - 集群分析 - 概念與個案實作練習](https://western-rule-4a4.notion.site/9-1-Ch-8-6ae067c140dd4a8a82bcb39d102013bc?pvs=4)

**作業6** : 第十章 迴歸分析 - 概念與個案實作練習 [(詳細背景)](https://github.com/cyyW/Rstudio/blob/main/ch10%20%E8%BF%B4%E6%AD%B8%E5%88%86%E6%9E%90/ch10%20%E5%80%8B%E6%A1%88%E8%83%8C%E6%99%AF.pdf)
* 作業說明 : 利用「餐飲業營收資料」的資料集實作迴歸分析，試著用不同的變數組合去解釋營收，計算各變數的影響程度及整個模型的解釋能力，並試著提供營運的決策建議。 
* 完整代碼 : [9-HW 迴歸分析 - 概念與個案實作練習.R](https://github.com/cyyW/Rstudio/blob/main/ch10%20%E8%BF%B4%E6%AD%B8%E5%88%86%E6%9E%90/9-HW%20%E8%BF%B4%E6%AD%B8%E5%88%86%E6%9E%90%20-%20%E6%A6%82%E5%BF%B5%E8%88%87%E5%80%8B%E6%A1%88%E5%AF%A6%E4%BD%9C%E7%B7%B4%E7%BF%92.R)
* 作品呈現 : [第 10 章，作業 1 - Ch 9 - 迴歸分析 - 概念與個案實作練習](https://western-rule-4a4.notion.site/10-1-Ch-9-cbad68137d654d2896084437ba9bf875?pvs=4)

**作業7** : 第十一章 邏輯迴歸 - 概念與個案實作練習 [(詳細背景)](https://github.com/cyyW/Rstudio/blob/main/ch11%20%E9%82%8F%E8%BC%AF%E8%BF%B4%E6%AD%B8/Logistic%20Regression%20%E8%B3%87%E6%96%99%E8%83%8C%E6%99%AF.pdf)
* 作業說明 : 使用「航空顧客忠誠度」的資料集，完成個案中尚未嘗試的模型，並提供適當的決策建議。 
* 完整代碼 : [10-HW 邏輯迴歸 概念與個案實作練習.R](https://github.com/cyyW/Rstudio/blob/main/ch11%20%E9%82%8F%E8%BC%AF%E8%BF%B4%E6%AD%B8/10-HW%20%E9%82%8F%E8%BC%AF%E8%BF%B4%E6%AD%B8%20%E6%A6%82%E5%BF%B5%E8%88%87%E5%80%8B%E6%A1%88%E5%AF%A6%E4%BD%9C%E7%B7%B4%E7%BF%92.R)
* 作品呈現 : [第 11 章，作業 1 - Ch 10 - 邏輯迴歸 - 概念與個案實作練習](https://western-rule-4a4.notion.site/11-1-Ch-10-fc0827b2d0ed47cc9bb94258e1e23b25?pvs=4)

**作業8** : 第十二章 決策樹分析 - 概念與個案實作練習 [(詳細背景)](https://github.com/cyyW/Rstudio/blob/main/ch12%20%E6%B1%BA%E7%AD%96%E6%A8%B9%E5%88%86%E6%9E%90/%E6%B1%BA%E7%AD%96%E6%A8%B9%E5%88%86%E6%9E%90%20%E5%80%8B%E6%A1%88%E8%83%8C%E6%99%AF.pdf)
* 作業說明 : 使用「航空顧客忠誠度」及「餐飲營收預測」的資料集實作決策樹分析，完成個案中尚未嘗試的模型，並提供適當的決策建議。 
* 完整代碼 : [11-5-HW 決策樹分析 - 概念與個案實作練習.R](https://github.com/cyyW/Rstudio/blob/main/ch12%20%E6%B1%BA%E7%AD%96%E6%A8%B9%E5%88%86%E6%9E%90/11-5-HW%20%E6%B1%BA%E7%AD%96%E6%A8%B9%E5%88%86%E6%9E%90%20-%20%E6%A6%82%E5%BF%B5%E8%88%87%E5%80%8B%E6%A1%88%E5%AF%A6%E4%BD%9C%E7%B7%B4%E7%BF%92.R)
* 作品呈現 : [第 12 章，作業 1 - Ch 11 - 決策樹分析 - 概念與個案實作練習](https://western-rule-4a4.notion.site/12-1-Ch-11-b501a5a8dbbf4882b38249c2164a8626?pvs=4)




