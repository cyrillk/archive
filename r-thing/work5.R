install.packages("psych")
install.packages("ggplot2")

library(psych)
library(ggplot2)

search()

getwd()
setwd("D:/Develop/r-thing")

data <- read.table("Stats1.13.HW.04.txt", header=T)

describe(data) 

model1 <- lm(data$salary ~ data$years)
summary(model1)

model2 <- lm(data$salary ~ data$courses)
summary(model2)

anova(model1) # Analysis of Variance Table
confint(model1) # 95% confidence interval

ggplot(data, aes(x = data$years, y = data$salary)) + 
  geom_smooth(method = "lm") + geom_point()

anova(model2) # Analysis of Variance Table
confint(model2) # 95% confidence interval

ggplot(data, aes(x = data$years, y = data$courses)) + 
  geom_smooth(method = "lm") + geom_point()

# Multiple regression (unstandartised)
model3 <- lm(data$salary ~ data$years + data$courses)
summary(model3)
confint(model3)

data$predicted <- fitted(model3)

ggplot(data, aes(x = data$years, y = data$predicted)) + 
  geom_smooth(method = "lm") + geom_point()

anova(model1, model3)
anova(model2, model3)

cor.test(data$predicted, data$salary)

plot(data$predicted)

# Multiple regression (standartised)
model3z <- lm(scale(data$salary) ~ scale(data$years) + scale(data$courses))
confint(model3z)

# Sampling
set.seed(1)

data15 <- data[sample(nrow(data), 15),]
cor.test(data15$salary, data15$years)
cor.test(data$salary, data$years)

sample <- data[51:70, ]

model.sample <- lm(sample$salary ~ sample$years + sample$courses)
summary(model.sample)

sample$predicted <- fitted(model.sample)
cor.test(sample$predicted, sample$salary)

summary(model.sample)

