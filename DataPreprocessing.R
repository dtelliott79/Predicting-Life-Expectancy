## Read in Data

library(tidyr); library(dplyr); library(ggplot2)
#library(dplyr)
#library(ggplot2)
#set.seed(1234)

df <- read.csv("Data.csv", header = TRUE)

## Data Wrangling

### Reorganize df into a tidy data set
df <- df %>% gather(key = Year, value = value, 5:60, na.rm = TRUE) %>%
        rename(Measure = ï..Series.Name, Measure.Code = Series.Code) %>%
        spread(key = Measure, value = value, fill = NA, drop = TRUE,
               sep = NULL) %>%
        select(-Measure.Code, -Country.Code) %>% 
        group_by(Country.Name, Year) %>% 
        summarise_each(funs(sum(., na.rm=TRUE)))
        
        
### Housekeeping: Replace all 0 values with NAs; reformat Year
df[df==0] <- NA
df$Year <- gsub("^*X([^.]+).*", "\\1", df$Year)

### Remove all instances where the value to be predicted is NA
df <- df[!is.na(df$`Life expectancy at birth, total (years)`),]

### Remove all potential covariates where more than 50% of remaining instances are NA
df <- df[, colMeans(is.na(df)) < .5]

### Housekeeping: Rename long column names
colnames(df)[3] <- "Adol.Fert.Rt"
colnames(df)[4] <- "Age.Dep.Ratio.Old"
colnames(df)[5] <- "Age.Dep.Ratio.Yng"
colnames(df)[6] <- "Birth.Rt"
colnames(df)[7] <- "Fert.Rt"
colnames(df)[8] <- "GNI.US.Dollars"
colnames(df)[9] <- "DPT.Immu"
colnames(df)[10] <- "Measl.Immu"
colnames(df)[11] <- "Pol3.Immu"
colnames(df)[12] <- "Life.Exp"
colnames(df)[13] <- "Pop.Growth"
colnames(df)[14] <- "Perc.Female"
colnames(df)[15] <- "Perc.Male"
colnames(df)[16] <- "Perc.Rural"
colnames(df)[17] <- "Rural.PopGrowth"
colnames(df)[18] <- "Prim.Sch.Perc"
colnames(df)[19] <- "Second.Sch.Perc"
colnames(df)[20] <- "Perc.Urban"
colnames(df)[21] <- "Urban.Pop.Growth"

## Data Analysis: Machine Learning Model

#library(caret)

#summary(df)

### Create training and testing data sets
df2 <- df[complete.cases(df),-c(1, 2)]
#inTrain <- createDataPartition(y=df2$Life.Exp, p=0.7, list=FALSE)
#training <- df2[inTrain,]
#testing <- df2[-inTrain,]

#####featurePlot(x = training[,-c(1,2,12)], y = training$`Life expectancy at birth, total (years)`, plot="pairs")
#cor(x = training, y = training$Life.Exp, use = "complete.obs")

### Impute missing values using k-nearest-neighbor imputation
#preObj <- preProcess(training[,-12], method = "knnImpute")
#imputed <- predict(preObj, training)[,-c(1,2,12)]
#training <- bind_cols(training[,12], imputed)

#imputedtesting <- predict(preObj, testing)[,-c(1,2,12)]
#testing <- bind_cols(testing[,12], imputedtesting)

#library(car)

model <- lm(df2$Life.Exp ~ df2$Adol.Fert.Rt + df2$Birth.Rt + df2$Pol3.Immu + df2$Second.Sch.Perc + df2$Urban.Pop.Growth)

summary(model)

#save(model, file = "my_model1.rda")

#PredTrain <- predict(model, training)
#MeanAccTrain <- mean(training$Life.Exp-PredTrain)
#RMSETrain <- sqrt(mean((training$Life.Exp-PredTrain)^2))

#PredTest <- predict(model, testing)
#MeanAccTest <- mean(testing$Life.Exp-PredTest)
#RMSETest <- sqrt(mean((testing$Life.Exp-PredTest)^2))

NatMeans <- aggregate(Life.Exp ~ Country.Name, data = df, mean)
saveRDS(NatMeans, file="LifeExpMeans.rds")

#Fitbg <- train(Life.Exp~.,method="rpart",data=training)
#Predbg <- predict(Fitbg, testing)
#Accbg <- confusionMatrix(Predbg, testing$Life.Exp)$overall[1]