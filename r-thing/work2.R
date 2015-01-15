install.packages("psych")
library(psych)

install.packages("sm")
library(sm)

search()

data = read.table("Stats1.13.HW.02.txt", header=T)

dim(data)
nrow(data)
ncol(data)

edit(data)

names(data)

class(data)
class(data$time)

data$subject <- factor(data$subject) # changes type

mean(data$SR) # mean
var(data$SR) # variance
sd(data$SR) # standart deviation

describe(data) # overall summary - mad? skew? kurtosis? se?

describeBy(data, data$time)

post <- subset(data, data[,3]=="post")
pre <- subset(data, data[,3]=="pre")

par(mfrow=c(1,2))
hist(pre[,4], xlab="before")
hist(post[,4], xlab="after")

density(post[,4])
plot(density(post[,4]), xlab="sssss")

par(mfrow=c(2,3))
hist(subset(pre, pre[,2]=="WM")[,4], xlab="WM")
hist(subset(pre, pre[,2]=="PE")[,4], xlab="PE")
hist(subset(pre, pre[,2]=="DS")[,4], xlab="DS")
hist(subset(post, post[,2]=="WM")[,4], xlab="WM")
hist(subset(post, post[,2]=="PE")[,4], xlab="PE")
hist(subset(post, post[,2]=="DS")[,4], xlab="DS")

describeBy(pre, pre$condition)
describeBy(post, post$condition)
