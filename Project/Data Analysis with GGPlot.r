---
title: "HWRmarkdown"
author: "Thanadon Moss"
date: "2023-12-12"
output:
  html_document: default
  pdf_document: default
---

## *ในไฟล์นี้จะเขียนรูปแบบ Markdown โดยจะเขียนในโปรแกรม RStudio*
วันนี้เราจะมาวิเคราะห์ข้อมูลเบื้องต้นและทำกราฟ โดยเราจะใช้ `Library Tidyverse` , `dplyr` และ เครื่องมือ `ggplot2` เป็นหลัก


## Explore data 

import library และเรียกดูข้อมูล data เบื้องต้น
```{r , message=FALSE}
library(tidyverse)
library(dplyr)

head(mpg)
```
## 1. Correlation between CTY and HWY

ความสัมพันธ์ระหว่าง city miles per gallon และ highway miles per gallon

1. plot กราฟในรูปแบบ `Scatter plot`
2. set theme เป็น `minimal`
3. กำหนด `title` , `xlabel` , `ylabel`

```{r , message=FALSE , fig.width=10}
  ggplot(mpg , aes(cty , hwy)) +
  geom_point(color = "purple" , size = 3) +
  geom_smooth(method="lm" , fill = "yellow" , color="blue") +
  theme_minimal() + 
  labs(
    title = "Relationship between CTY and HWY" ,
    x = "City miles per gallon" , 
    y = "Highway miles per gallon"
  )
```
From the graph it can be seen that `correlation` is direction +

จากกราฟจะเห็นว่า `correlation` เป็นทิศทาง + 


## 2. Count type of car

ในกราฟเราจะมาดูว่าประเภทรถแต่ละรุ่นมีจำนวนเท่าไหร่บ้าง

1. plot กราฟในรูปแบบ `bar plot`
2. set theme เป็น `minimal`
3. กำหนด `title` , `xlabel` , `ylabel`
4. กำหนดเฉดสี Palette เป็น `Blues`

```{r , message=FALSE , fig.width=10}
  ggplot(mpg , aes(class, fill=class)) +
  geom_bar(color="black") +
  theme_minimal() +
  scale_fill_brewer(palette = "Blues") +
  labs(
    title = "Count Type of Car" ,
    x = "Class" ,
    y = "Amount"
  )
```
From the graph, it can be seen that SUVs have the highest number.

จากกราฟจะเห็นว่ารถประเภท SUV มีจำนวนเยอะที่สุด

## 3. In 2008, any manufacturer produced a lot of cars.

ในกราฟเราจะมาดูว่าในปี 2008 ผู้ผลิตรายใดผลิตรถออกมาเยอะที่สุด

1. plot กราฟในรูปแบบ `bar plot`
2. set theme เป็น `minimal`
3. กำหนด `title` , `xlabel` , `ylabel`

```{r , message=FALSE , fig.width=10}
selected_mpg <- mpg %>% 
                filter(year == 2008) %>%
                group_by(manufacturer)

selected_mpg %>%
    count(manufacturer) %>% #aggregate
    ggplot(data = .,aes(manufacturer, n , fill=n)) +
    geom_col() + 
    theme_minimal() 
```
From the graph, it can be seen that the Dodge manufacturer produces the most cars.

จากกราฟจะเห็นว่าผู้ผลิตราย dodge ผลิตรถออกมาเยอะที่สุด

## 4. Distribution of Highway miles per gallon

ในกราฟเราจะมาดูการกระจายตัวของ Highway miles per gallon

1. filter ข้อมูลที่อยู่ในที่ปี 2008 โดยแบ่งกลุ่มตามผู้ผลิต 
2. plot กราฟในรูปแบบ `bar plot`
3. set theme เป็น `minimal`
4. กำหนด `xlabel`

```{r , message=FALSE , fig.width=10}
ggplot(mpg , aes(hwy)) +
  geom_histogram(bins=9 , color="black" , fill="#be94f2") +
  theme_minimal() +
  labs(
    title = "Distribution of Highway miles per gallon" ,
    x = "Highway miles per gallon"
  )
```
When graphed, it can be seen that the distribution is right-skewed.
จะกราฟจะเห็นได้ว่ามีการกระจายตัวแบบเบ้ขวา

## 5. 5 car with the highest average engine displacement? And how many are there ?
5 รถยนต์ที่มีค่าเฉลี่ยความจุกระบอกสูบของเครื่องยนต์มากที่สุดและมีจำนวนเท่าไหร่

1. แบ่งกลุ่มรถยนต์ตาม model จากนั้น หาค่าเฉลี่ยความจุกระบอกสูบของเครื่องยนต์ โดยหยิบมาแค่ 5 คัน 
2. plot กราฟในรูปแบบ `bar plot`
3. set theme เป็น `minimal`
4. กำหนด `title` , `xlabel` , `ylabel`

```{r , message=FALSE , fig.width=10}
selected_car <- mpg %>% 
  group_by(model) %>%
  summarise( avg_displ = mean(displ)) %>%
  arrange(desc(avg_displ)) %>%
  head(5)

ggplot(selected_car , aes( model , avg_displ , fill=model)) +
  geom_col() +
  theme_minimal() +
  labs(
    title = " 5 car with the highest average engine displacement" ,
    x = "Model Cars" , 
    y= "Average of engine displacement "
  )
```
From the graph, it can be concluded that the `Corvette` model has the highest average engine cylinder capacity.

จากกราฟสรุปได้ว่ารถยนต์รุ่น `corvette` มีค่าเฉลี่ยความจุกระบอกสูบของเครื่องมากที่สุด
