# hashPerf.R by Zhuowen Fang
# 2018.05.07

install.packages("ggplot2")
library(ggplot2)

num <- c(1,5,10,50,100,200,500,1000,2000,3500,5000,8000,10000,12000,15000,18000,20000,35000,50000,80000,100000,150000,200000,350000,500000)

memory_usage_bytes <- list(NULL)
memory_usage_mb <- list(NULL)
runtime <- list(NULL)
hashes_per_second <- list(NULL)

# Get average measurement result of MacBook CPU
t <- 1
mCPU <- read.csv("MacCPU1.csv") # Get performance of CPU on Macbook for message 1
for (i in num) {
  memory_usage_bytes[t] <- mean(unlist(mCPU$Memory.usage.bytes.[mCPU$Hash.times==i]))
  memory_usage_mb[t] <- mean(unlist(mCPU$Memory.usage.MB.[mCPU$Hash.times==i]))
  runtime[t] <- mean(unlist(mCPU$Runtime.ns.[mCPU$Hash.times==i]))
  hashes_per_second[t] <- mean(unlist(mCPU$Hashes.per.second.h.s.[mCPU$Hash.times==i]))
  t <- t+1
}
mC1 <- data.frame(Hash_Times = num, Memory_Usage_Bytes = unlist(memory_usage_bytes), Memory_Usage_MB = unlist(memory_usage_mb), Runtime = unlist(runtime), Hashes_per_Second = unlist(hashes_per_second))
mC1$Length <- rep(1,25)
mC1$Device <- rep(c("MacBook CPU"),25)

t <- 1
mCPU <- read.csv("MacCPU2.csv") # Get performance of CPU on Macbook for message 2
for (i in num) {
  memory_usage_bytes[t] <- mean(unlist(mCPU$Memory.usage.bytes.[mCPU$Hash.times==i]))
  memory_usage_mb[t] <- mean(unlist(mCPU$Memory.usage.MB.[mCPU$Hash.times==i]))
  runtime[t] <- mean(unlist(mCPU$Runtime.ns.[mCPU$Hash.times==i]))
  hashes_per_second[t] <- mean(unlist(mCPU$Hashes.per.second.h.s.[mCPU$Hash.times==i]))
  t <- t+1
}
mC2 <- data.frame(Hash_Times = num, Memory_Usage_Bytes = unlist(memory_usage_bytes), Memory_Usage_MB = unlist(memory_usage_mb), Runtime = unlist(runtime), Hashes_per_Second = unlist(hashes_per_second))
mC2$Length <- rep(38,25)
mC2$Device <- rep(c("MacBook CPU"),25)

t <- 1
mCPU <- read.csv("MacCPU3.csv") # Get performance of CPU on Macbook for message 3
for (i in num) {
  memory_usage_bytes[t] <- mean(unlist(mCPU$Memory.usage.bytes.[mCPU$Hash.times==i]))
  memory_usage_mb[t] <- mean(unlist(mCPU$Memory.usage.MB.[mCPU$Hash.times==i]))
  runtime[t] <- mean(unlist(mCPU$Runtime.ns.[mCPU$Hash.times==i]))
  hashes_per_second[t] <- mean(unlist(mCPU$Hashes.per.second.h.s.[mCPU$Hash.times==i]))
  t <- t+1
}
mC3 <- data.frame(Hash_Times = num, Memory_Usage_Bytes = unlist(memory_usage_bytes), Memory_Usage_MB = unlist(memory_usage_mb), Runtime = unlist(runtime), Hashes_per_Second = unlist(hashes_per_second))
mC3$Length <- rep(80,25)
mC3$Device <- rep(c("MacBook CPU"),25)
# ---------------------------------------------------------------------------------------
# Get average measurement result of high-end computer CPU
t <- 1
hCPU <- read.csv("TitanXCPU1.csv") # Get performance of CPU on lab computer for message 1
for (i in num) {
  memory_usage_bytes[t] <- mean(unlist(hCPU$Memory.usage.bytes.[hCPU$Hash.times==i]))
  memory_usage_mb[t] <- mean(unlist(hCPU$Memory.usage.MB.[hCPU$Hash.times==i]))
  runtime[t] <- mean(unlist(hCPU$Runtime.ns.[hCPU$Hash.times==i]))
  hashes_per_second[t] <- mean(unlist(hCPU$Hashes.per.second.h.s.[hCPU$Hash.times==i]))
  t <- t+1
}
hC1 <- data.frame(Hash_Times = num, Memory_Usage_Bytes = unlist(memory_usage_bytes), Memory_Usage_MB = unlist(memory_usage_mb), Runtime = unlist(runtime), Hashes_per_Second = unlist(hashes_per_second))
hC1$Length <- rep(1,25)
hC1$Device <- rep(c("Lab CPU"),25)

t <- 1
hCPU <- read.csv("TitanXCPU2.csv") # Get performance of CPU on lab computer for message 1
for (i in num) {
  memory_usage_bytes[t] <- mean(unlist(hCPU$Memory.usage.bytes.[hCPU$Hash.times==i]))
  memory_usage_mb[t] <- mean(unlist(hCPU$Memory.usage.MB.[hCPU$Hash.times==i]))
  runtime[t] <- mean(unlist(hCPU$Runtime.ns.[hCPU$Hash.times==i]))
  hashes_per_second[t] <- mean(unlist(hCPU$Hashes.per.second.h.s.[hCPU$Hash.times==i]))
  t <- t+1
}
hC2 <- data.frame(Hash_Times = num, Memory_Usage_Bytes = unlist(memory_usage_bytes), Memory_Usage_MB = unlist(memory_usage_mb), Runtime = unlist(runtime), Hashes_per_Second = unlist(hashes_per_second))
hC2$Length <- rep(38,25)
hC2$Device <- rep(c("Lab CPU"),25)

t <- 1
hCPU <- read.csv("TitanXCPU3.csv") # Get performance of CPU on lab computer for message 1
for (i in num) {
  memory_usage_bytes[t] <- mean(unlist(hCPU$Memory.usage.bytes.[hCPU$Hash.times==i]))
  memory_usage_mb[t] <- mean(unlist(hCPU$Memory.usage.MB.[hCPU$Hash.times==i]))
  runtime[t] <- mean(unlist(hCPU$Runtime.ns.[hCPU$Hash.times==i]))
  hashes_per_second[t] <- mean(unlist(hCPU$Hashes.per.second.h.s.[hCPU$Hash.times==i]))
  t <- t+1
}
hC3 <- data.frame(Hash_Times = num, Memory_Usage_Bytes = unlist(memory_usage_bytes), Memory_Usage_MB = unlist(memory_usage_mb), Runtime = unlist(runtime), Hashes_per_Second = unlist(hashes_per_second))
hC3$Length <- rep(80,25)
hC3$Device <- rep(c("Lab CPU"),25)
# ---------------------------------------------------------------------------------------
# Get average measurement result of Raspberry Pi CPU
t <- 1
rCPU <- read.csv("RPiCPU1.csv") # Get performance of CPU on Raspberry Pi for message 1
for (i in num) {
  memory_usage_bytes[t] <- mean(unlist(rCPU$Memory.usage.bytes.[rCPU$Hash.times==i]))
  memory_usage_mb[t] <- mean(unlist(rCPU$Memory.usage.MB.[rCPU$Hash.times==i]))
  runtime[t] <- mean(unlist(rCPU$Runtime.ns.[mCPU$Hash.times==i]))
  hashes_per_second[t] <- mean(unlist(rCPU$Hashes.per.second.h.s.[rCPU$Hash.times==i]))
  t <- t+1
}
rC1 <- data.frame(Hash_Times = num, Memory_Usage_Bytes = unlist(memory_usage_bytes), Memory_Usage_MB = unlist(memory_usage_mb), Runtime = unlist(runtime), Hashes_per_Second = unlist(hashes_per_second))
rC1$Length <- rep(1,25)
rC1$Device <- rep(c("Raspberry Pi CPU"),25)

t <- 1
rCPU <- read.csv("RPiCPU2.csv") # Get performance of CPU on Raspberry Pi for message 2
for (i in num) {
  memory_usage_bytes[t] <- mean(unlist(rCPU$Memory.usage.bytes.[rCPU$Hash.times==i]))
  memory_usage_mb[t] <- mean(unlist(rCPU$Memory.usage.MB.[rCPU$Hash.times==i]))
  runtime[t] <- mean(unlist(rCPU$Runtime.ns.[mCPU$Hash.times==i]))
  hashes_per_second[t] <- mean(unlist(rCPU$Hashes.per.second.h.s.[rCPU$Hash.times==i]))
  t <- t+1
}
rC2 <- data.frame(Hash_Times = num, Memory_Usage_Bytes = unlist(memory_usage_bytes), Memory_Usage_MB = unlist(memory_usage_mb), Runtime = unlist(runtime), Hashes_per_Second = unlist(hashes_per_second))
rC2$Length <- rep(38,25)
rC2$Device <- rep(c("Raspberry Pi CPU"),25)

t <- 1
rCPU <- read.csv("RPiCPU3.csv") # Get performance of CPU on Raspberry Pi for message 3
for (i in num) {
  memory_usage_bytes[t] <- mean(unlist(rCPU$Memory.usage.bytes.[rCPU$Hash.times==i]))
  memory_usage_mb[t] <- mean(unlist(rCPU$Memory.usage.MB.[rCPU$Hash.times==i]))
  runtime[t] <- mean(unlist(rCPU$Runtime.ns.[mCPU$Hash.times==i]))
  hashes_per_second[t] <- mean(unlist(rCPU$Hashes.per.second.h.s.[rCPU$Hash.times==i]))
  t <- t+1
}
rC3 <- data.frame(Hash_Times = num, Memory_Usage_Bytes = unlist(memory_usage_bytes), Memory_Usage_MB = unlist(memory_usage_mb), Runtime = unlist(runtime), Hashes_per_Second = unlist(hashes_per_second))
rC3$Length <- rep(80,25)
rC3$Device <- rep(c("Raspberry Pi CPU"),25)
# ---------------------------------------------------------------------------------------
# Get average measurement result of MacBook GPU
t <- 1
mGPU <- read.csv("MacGPU1.csv") # Get performance of GPU on Macbook for message 1
for (i in num) {
  memory_usage_bytes[t] <- mean(unlist(mGPU$Memory.usage.bytes.[mGPU$Hash.times==i]))
  memory_usage_mb[t] <- mean(unlist(mGPU$Memory.usage.MB.[mGPU$Hash.times==i]))
  runtime[t] <- mean(unlist(mGPU$Runtime.ns.[mGPU$Hash.times==i]))
  hashes_per_second[t] <- mean(unlist(mGPU$Hashes.per.second.h.s.[mGPU$Hash.times==i]))
  t <- t+1
}
mG1 <- data.frame(Hash_Times = num, Memory_Usage_Bytes = unlist(memory_usage_bytes), Memory_Usage_MB = unlist(memory_usage_mb), Runtime = unlist(runtime), Hashes_per_Second = unlist(hashes_per_second))
mG1$Length <- rep(1,25)
mG1$Device <- rep(c("MacBook GPU"),25)

t <- 1
mGPU <- read.csv("MacGPU2.csv") # Get performance of GPU on Macbook for message 2
for (i in num) {
  memory_usage_bytes[t] <- mean(unlist(mGPU$Memory.usage.bytes.[mGPU$Hash.times==i]))
  memory_usage_mb[t] <- mean(unlist(mGPU$Memory.usage.MB.[mGPU$Hash.times==i]))
  runtime[t] <- mean(unlist(mGPU$Runtime.ns.[mGPU$Hash.times==i]))
  hashes_per_second[t] <- mean(unlist(mGPU$Hashes.per.second.h.s.[mGPU$Hash.times==i]))
  t <- t+1
}
mG2 <- data.frame(Hash_Times = num, Memory_Usage_Bytes = unlist(memory_usage_bytes), Memory_Usage_MB = unlist(memory_usage_mb), Runtime = unlist(runtime), Hashes_per_Second = unlist(hashes_per_second))
mG2$Length <- rep(38,25)
mG2$Device <- rep(c("MacBook GPU"),25)

t <- 1
mGPU <- read.csv("MacGPU3.csv") # Get performance of GPU on Macbook for message 3
for (i in num) {
  memory_usage_bytes[t] <- mean(unlist(mGPU$Memory.usage.bytes.[mGPU$Hash.times==i]))
  memory_usage_mb[t] <- mean(unlist(mGPU$Memory.usage.MB.[mGPU$Hash.times==i]))
  runtime[t] <- mean(unlist(mGPU$Runtime.ns.[mGPU$Hash.times==i]))
  hashes_per_second[t] <- mean(unlist(mGPU$Hashes.per.second.h.s.[mGPU$Hash.times==i]))
  t <- t+1
}
mG3 <- data.frame(Hash_Times = num, Memory_Usage_Bytes = unlist(memory_usage_bytes), Memory_Usage_MB = unlist(memory_usage_mb), Runtime = unlist(runtime), Hashes_per_Second = unlist(hashes_per_second))
mG3$Length <- rep(80,25)
mG3$Device <- rep(c("MacBook GPU"),25)
# ---------------------------------------------------------------------------------------
# Get average measurement result of TitanX GPU
t <- 1
hGPU <- read.csv("TitanXGPU1.csv") # Get performance of GPU on TitanX for message 1
for (i in num) {
  memory_usage_bytes[t] <- mean(unlist(hGPU$Memory.usage.bytes.[hGPU$Hash.times==i]))
  memory_usage_mb[t] <- mean(unlist(hGPU$Memory.usage.MB.[hGPU$Hash.times==i]))
  runtime[t] <- mean(unlist(hGPU$Runtime.ns.[hGPU$Hash.times==i]))
  hashes_per_second[t] <- mean(unlist(hGPU$Hashes.per.second.h.s.[hGPU$Hash.times==i]))
  t <- t+1
}
hG1 <- data.frame(Hash_Times = num, Memory_Usage_Bytes = unlist(memory_usage_bytes), Memory_Usage_MB = unlist(memory_usage_mb), Runtime = unlist(runtime), Hashes_per_Second = unlist(hashes_per_second))
hG1$Length <- rep(1,25)
hG1$Device <- rep(c("Lab GPU - Titan X"),25)

t <- 1
hGPU <- read.csv("TitanXGPU2.csv") # Get performance of GPU on TitanX for message 2
for (i in num) {
  memory_usage_bytes[t] <- mean(unlist(hGPU$Memory.usage.bytes.[hGPU$Hash.times==i]))
  memory_usage_mb[t] <- mean(unlist(hGPU$Memory.usage.MB.[hGPU$Hash.times==i]))
  runtime[t] <- mean(unlist(hGPU$Runtime.ns.[hGPU$Hash.times==i]))
  hashes_per_second[t] <- mean(unlist(hGPU$Hashes.per.second.h.s.[hGPU$Hash.times==i]))
  t <- t+1
}
hG2 <- data.frame(Hash_Times = num, Memory_Usage_Bytes = unlist(memory_usage_bytes), Memory_Usage_MB = unlist(memory_usage_mb), Runtime = unlist(runtime), Hashes_per_Second = unlist(hashes_per_second))
hG2$Length <- rep(38,25)
hG2$Device <- rep(c("Lab GPU - Titan X"),25)

t <- 1
hGPU <- read.csv("TitanXGPU3.csv") # Get performance of GPU on TitanX for message 3
for (i in num) {
  memory_usage_bytes[t] <- mean(unlist(hGPU$Memory.usage.bytes.[hGPU$Hash.times==i]))
  memory_usage_mb[t] <- mean(unlist(hGPU$Memory.usage.MB.[hGPU$Hash.times==i]))
  runtime[t] <- mean(unlist(hGPU$Runtime.ns.[hGPU$Hash.times==i]))
  hashes_per_second[t] <- mean(unlist(hGPU$Hashes.per.second.h.s.[hGPU$Hash.times==i]))
  t <- t+1
}
hG3 <- data.frame(Hash_Times = num, Memory_Usage_Bytes = unlist(memory_usage_bytes), Memory_Usage_MB = unlist(memory_usage_mb), Runtime = unlist(runtime), Hashes_per_Second = unlist(hashes_per_second))
hG3$Length <- rep(80,25)
hG3$Device <- rep(c("Lab GPU - Titan X"),25)
# ---------------------------------------------------------------------------------------

CPUs <- rbind(mC1,rC1,hC1)
GPUs <- rbind(mG3,hG3)
MacBook <- rbind(mC3,mG3)
#MacBook <- merge(mC3,mG3,by="Hash_Times")
#MacBook <- subset(MacBook, select = c(Hash_Times,Hashes_per_Second.x,Device.x,Hashes_per_Second.y,Device.y))
High <- rbind(hC3,hG3)
#High <- merge(hC3,hG3,by="Hash_Times")
#High <- subset(High, select = c(Hash_Times,Hashes_per_Second.x,Device.x,Hashes_per_Second.y,Device.y))
lthMC <- rbind(mC1,mC2,mC3)
lthMG <- rbind(mG1,mG2,mG3)
lthHC <- rbind(hC1,hC2,hC3)
lthHG <- rbind(hG1,hG2,hG3)
lthRC <- rbind(rC1,rC2,rC3)
  
cGraph <- qplot(x = Hash_Times, y = Hashes_per_Second, data = CPUs, color = Device, geom = c("line","point"), main = "Comparison of different CPUs") + theme(plot.title = element_text(hjust = 0.5))
gGraph <- qplot(x = Hash_Times, y = Hashes_per_Second, data = GPUs, color = Device, geom = c("line","point"), main = "Comparison of different GPUs") + theme(plot.title = element_text(hjust = 0.5))
mGraph <- qplot(x = Hash_Times, y = Hashes_per_Second, data = MacBook, color = Device, geom = c("line","point"), main = "Comparison of MacBook CPU & GPU") + theme(plot.title = element_text(hjust = 0.5))
hGraph <- qplot(x = Hash_Times, y = Hashes_per_Second, data = High, color = Device, geom = c("line","point"), main = "Comparison of Lab Computer CPU & GPU") + theme(plot.title = element_text(hjust = 0.5))
#mGraph <- ggplot(MacBook,aes(x=Hash_Times)) + geom_line(aes(y=Hashes_per_Second.x),color="#F8CA00") + geom_point(aes(y=Hashes_per_Second.x),color="#F8CA00") + geom_line(aes(y=Hashes_per_Second.y),color="#104E8B") + geom_point(aes(y=Hashes_per_Second.y),color="#104E8B")
#mGraph <- mGraph + labs(title = "Comparison of MacBook CPU & GPU") + theme(plot.title = element_text(hjust = 0.5))
#hGraph <- ggplot(High, aes(x=Hash_Times)) + geom_line(aes(y=Hashes_per_Second.x),color="#FF7256") + geom_point(aes(y=Hashes_per_Second.x),color="#FF7256") + geom_line(aes(y=Hashes_per_Second.y),color="#6B8E23") + geom_point(aes(y=Hashes_per_Second.y),color="#6B8E23")
#hGraph <- hGraph + labs(title = "Comparison of lab computer CPU & GPU") + theme(plot.title = element_text(hjust = 0.5))

qplot(x = Hash_Times, y = Hashes_per_Second, data = lthMC, color = Length, geom = c("point"), main = "Comparison of Different Message Length on Mac CPU") + theme(plot.title = element_text(hjust = 0.5))
qplot(x = Hash_Times, y = Hashes_per_Second, data = lthMG, color = Length, geom = c("point"), main = "Comparison of Different Message Length on Mac GPU") + theme(plot.title = element_text(hjust = 0.5))
qplot(x = Hash_Times, y = Hashes_per_Second, data = lthHC, color = Length, geom = c("point"), main = "Comparison of Different Message Length on CPU") + theme(plot.title = element_text(hjust = 0.5))
qplot(x = Hash_Times, y = Hashes_per_Second, data = lthHG, color = Length, geom = c("point"), main = "Comparison of Different Message Length on GPU") + theme(plot.title = element_text(hjust = 0.5))
qplot(x = Hash_Times, y = Hashes_per_Second, data = lthRC, color = Length, geom = c("point"), main = "Comparison of Different Message Length on RPi CPU") + theme(plot.title = element_text(hjust = 0.5))

qplot(x = Hash_Times, y = Hashes_per_Second, data = rbind(mC1,mG1,hC1,hG1,rC1), color = Device, geom = c("line","point"), main = "Comparison of hash rate on CPUs & GPUs") + theme(plot.title = element_text(hjust = 0.5))

mean(unlist(mC3$Hashes_per_Second[mC3$Hash_Times>=20000]))
mean(unlist(hC3$Hashes_per_Second[hC3$Hash_Times>=2000]))
mean(unlist(rC3$Hashes_per_Second[rC3$Hash_Times>=500]))
mean(unlist(mG3$Hashes_per_Second[mG3$Hash_Times>=80000]))
mean(unlist(hG3$Hashes_per_Second[hG3$Hash_Times>=3500]))

shmC <- subset(mC1, Hash_Times<=500&Hash_Times>1)
shmG <- subset(mG1, Hash_Times<=500&Hash_Times>1)
shhC <- subset(hC1, Hash_Times<=500&Hash_Times>1)
shhG <- subset(hG1, Hash_Times<=500&Hash_Times>1)
qplot(x = Hash_Times, y = Runtime, data = rbind(shmC,shmG,shhC,shhG), color = Device, geom = c("line","point"), main = "Comparison of CPU & GPU Runtime") + theme(plot.title = element_text(hjust = 0.5))

qplot(x = Hash_Times, y = Memory_Usage_Bytes, data = rbind(subset(mC1,Hash_Times>1&Hash_Times<=20000),subset(mG1,Hash_Times>1&Hash_Times<=20000),subset(rC1,Hash_Times>1&Hash_Times<=20000),subset(hC1,Hash_Times>1&Hash_Times<=20000),subset(hG1,Hash_Times>1&Hash_Times<=20000)), color = Device,geom = c("line","point"),main = "Comparison of Memory Usage") + theme(plot.title = element_text(hjust = 0.5))
qplot(x = Hash_Times, y = Hashes_per_Second, data = mC1, color = Device,geom = c("line","point"))

qplot(x = Hash_Times, y = Memory_Usage_Bytes, data = mC3, geom =c("line","point"), color = Device, main = "Memory Usage of MacBook CPU") + theme(plot.title = element_text(hjust = 0.5))

        
mcTime <- mC$Runtime/mC$Hash_Times
