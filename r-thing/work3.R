getwd()
setwd("D:/Develop/r-thing")

install.packages("psych")
install.packages("gclus")
install.packages("rgl")

library(psych)
library(gclus)
library(rgl)

impact <- read.table("Stats1.13.HW.03.txt", header=T)

dim(impact)
edit(impact)

describe(impact)
describeBy(impact, impact$cond)

cor(impact[3:10])
round(cor(impact[3:10]), 2)

names(impact)

aerobic <- subset(impact, impact[,2] == "aer")
aerobic

designed <- subset(impact, impact[,2] == "des")
designed

round(cor(aerobic[3:10]), 2)
round(cor(designed[3:10]), 2)

plot(aerobic$S1.pre ~ aerobic$S1.post)
abline(lm(aerobic$S1.pre ~ aerobic$S1.post))

pairs(~impact$S1.pre + impact$S2.pre + impact$V1.pre + impact$V2.pre, cex.labels=1.2)

# *** *** ***
data <- impact

cor(data$S1.pre, data$S2.pre)

cor(data$V1.pre, data$V2.pre)

data$S.pre = (data$S1.pre + data$S2.pre) / 2
data$V.pre = (data$V1.pre + data$V2.pre) / 2 
cor(data$S.pre, data$V.pre)

data.aer = subset(data, data$cond=="aer")
cor(data.aer$S1.pre, data.aer$S1.post)
cor(data.aer$S2.pre, data.aer$S2.post)
cor(data.aer$V1.pre, data.aer$V1.post)
cor(data.aer$V2.pre, data.aer$V2.post)

data$S.pre = (data$S1.pre + data$S2.pre) / 2 
data$V.pre = (data$V1.pre + data$V2.pre) / 2
data$S.post = (data$S1.post + data$S2.post) / 2
data$V.post = (data$V1.post + data$V2.post) / 2
data$Sgain = data$S.post - data$S.pre
data$Vgain = data$V.post - data$V.pre
cor(data$S.pre, data$Sgain)
cor(data$V.pre, data$Vgain)

describeBy(data$Sgain, data$cond)

library(gclus)
pre = cbind(data[3], data[4], data[7], data[8])
pre.r = abs(cor(cbind(data[3], data[4], data[7], data[8])))
cpairs(pre, order.single(pre.r), panel.colors = dmat.color(pre.r), gap=.5)

post = cbind(data[5], data[6], data[9], data[10])
post.r = abs(cor(cbind(data[5], data[6], data[9], data[10])))
cpairs(post, order.single(post.r), panel.colors = dmat.color(post.r), gap=.5)


