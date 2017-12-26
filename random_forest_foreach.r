# R script for running random forest ensemble classifier in regression direction w/ classification for validation
library(randomForest)
library(foreach) ### parallel computing library
set.seed(4)
####memory.limit(64000)

#Invoke parallel processing via local SOCKETS (need Revolution R to improve this)
require(doSNOW)
cores<-3
registerDoSNOW(makeCluster(cores, type = "SOCK"))
getDoParWorkers()
getDoParName()
getDoParVersion()

#calibration step
#calibrate<-read.table("rf_input_rand_samples004.txt", header=TRUE)
calibrate<-read.table("rf_input_rand_samples004-55055000000.txt", header=TRUE)
#calibrate<-read.table("rf_input_binned-55055000000.txt", header=TRUE)
Sys.time()
###use parallel version of random forests using "foreach()" - for example ntree=rep(25,4) = 25*4=100 trees
system.time(calibrate.rf <- foreach(ntree=rep(167,cores), .combine=combine, .packages='randomForest') %dopar% randomForest(delta~initial+slope+elev+aspect+landm+landuse+soilsp+soilst+burned+numburn

, data=calibrate, mtry=3, ntree=ntree, importance=TRUE))
####non-parallel:
system.time(calibrate.rf <- randomForest(delta~initial+slope+elev+aspect+landm+landuse+soilsp+soilst+burned+numburn

, data=calibrate, mtry=3, ntree=40, importance=TRUE))

Sys.time()
print(calibrate.rf)

#computing variable importance measures
importance(calibrate.rf)
### MANUAL Action: copy/paste the output to a new text file
varImpPlot(calibrate.rf)

#prediction step for the validation data
validate<-read.table("rf_input_rand_samples_w_headersv2_val.txt", header=TRUE)
memory.limit(size=4000)
predValues<-predict(calibrate.rf, validate)
predValues<-as.numeric(predValues)

#validation step
obsValues<-as.numeric(validate$total)
#calculating root mean square error (rmse)
rmse<-sqrt(mean((obsValues-predValues)^2))
correlation<-cor(obsValues, predValues)

#writing the data to a table
write.table(predValues, "predValues4.txt", row.names=FALSE, col.names="classes")

getTree(calibrate.rf, k=1, labelVar=TRUE)



