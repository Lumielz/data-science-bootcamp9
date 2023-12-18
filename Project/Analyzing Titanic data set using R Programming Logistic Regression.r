### ในชีทนี้จะทำนายการเสียชีวิต ( Survived ) ผ่าน 1 ตัวแปรนั่นคือ Pclass ที่บอกถึงค่า Passenger class โดยใช้ Logistic Regression 

## Step 1 โหลด library titanic เข้ามาและเรียกดูหน้าตาข้อมูลเบื้องต้น

library(titanic)
head(titanic_train)

## Step 2 คลีนข้อมูลที่เป็นค่า NaN ด้วย คำสั่ง na.omit และเช็คจำนวนแถว

titanic_train <- na.omit(titanic_train)
nrow(titanic_train)
 
## Step 3 แบ่งชุดข้อมูลเพื่อ Train และ Test 

- ใช้  `set.seed` ให้ค่าสุ่มคงที่ และเก็บจำนวนแถวไว้ในตัวแปร `n`
- แบ่งข้อมูลเป็น `Train 70%` และ `Test 30%`
- ข้อมูล train เก็บไว้ในตัวแปร train_data และ ข้อมูล test เก็บไว้ในตัวแปร test_data

set.seed(42)
n <- nrow(titanic_train)
id <- sample(1:n , size=n*0.7)
train_data <- titanic_train[id,]
test_data <- titanic_train[-id,]


## Step 4 สร้าง model เก็บค่า probability และ Predict ไว้ในตัวแปรใหม่

- สร้างโมเดลโดยเก็บไว้ในตัวแปร titanic_model
    - ใช้ฟังก์ชัน glm กำหนดพารามิเตอร์ family เป็น `binomial`
    - ตัวแปรต้นที่ใช้คำนายเป็น Pclass คือ ค่าที่บอกถึง Passenger Class
    - ตัวแปรตามเป็น `Survived` คือ เสียชีวิตหรือไม่ 0 คือเสียชีวิต 1 รอดชีวิต

- ใช้โมเดลที่สร้างมาเก็บค่าใหม่ 2 column
    - สร้างคอลัมน์ `prob_Survived` ผ่านการใช้ฟังก์ชัน predict โดยกำหนด type = ‘response’
    - สร้างคอลัมน์ `pred_Survived` ใช้ฟังก์ชัน ifelse กำหนด Treshold ไว้ที่ 0.5

#Train Model
titanic_model <- glm(Survived ~ Pclass , data = train_data , family = "binomial")

#summary value
summary(titanic_model) 

#Test Model
train_data$prob_Survived <- predict(titanic_model , type='response')
train_data$pred_Survived <- ifelse(train_data$prob_Survived >= 0.5 , 1 , 0)


## Step 5 สร้างตาราง Confusion Matrix

- สร้างตารางเก็บไว้ในตัวแปร `CONM_Titanic`
- หาค่า `Accuracy` หาค่าความถูกต้องในโมเดลที่สร้างมา
- หาค่า `Precision` ทุกครั้งที่ทำนาย yes เราทำนายถูกกี่ครั้ง
- หาค่า `Recall` ในชุดข้อมูลที่มีค่า yes โมเดลเราสามารถเจอ yes เท่าไหร่
- หาค่า `F1` คือค่าเฉลี่ยฮาร์มอนิก ระหว่าง `Precision` และ `Recall`

#confusion matrix
CONM_Titanic <- table(train_data$pred_Survived , train_data$Survived , dnn = c("Predicted , Actual"))
Accuracy_titanic <- (CONM_Titanic[1,1] + CONM_Titanic[2,2]) / sum(CONM_Titanic)
Precision_titanic <- (CONM_Titanic[2,2]) / (CONM_Titanic[2,1] + CONM_Titanic[2,2])
Recall_titanic <- CONM_Titanic[2,2] / (CONM_Titanic[1,2] + CONM_Titanic[2,2])
F1_titanic <- 2*(Precision_titanic*Recall_titanic)/(Precision_titanic+Recall_titanic)

#print value 
cat("Accuracy : ",Accuracy_titanic)
cat("Precision : ",Precision_titanic)
cat("Recall : ",Recall_titanic)
cat("F1 : ",F1_titanic)








