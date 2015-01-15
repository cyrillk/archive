getwd()
setwd("D:/Develop/r-thing")

install.packages("psych")
library(psych)

search()

data <- read.table("Stats1.13.HW.04.txt", header=T)
describe(data)

cor(data[2:4])
round(cor(data[2:4]), 2)

head(data)

cor.test(data$salary, data$years)
cor.test(data$salary, data$courses)
cor.test(data$courses, data$years)

layout(matrix(c(1:4), 2, 2, byrow=TRUE))
hist(data$salary)
hist(data$courses)
hist(data$years)
layout(matrix(c(1:1), 1, 1, byrow=TRUE))

model1 <- lm(data$salary ~ data$years)
summary(model1)
plot(data$salary ~ data$years)
abline(model1)

model2 <- lm(data$salary ~ data$courses)
summary(model2)
plot(data$salary ~ data$courses)
abline(model2)

model3 <- lm(data$salary ~ data$years + data$courses)
summary(model3)

data$predicted = fitted(model3)
mean(data$predicted)

data$error = resid(model3)
round(mean(data$error), 2)

hist(data$error)

plot(data$predicted ~ data$error)
abline(lm(data$predicted ~ data$error))

model1.z <- lm(scale(data$salary) ~ scale(data$years))
summary(model1.z)

