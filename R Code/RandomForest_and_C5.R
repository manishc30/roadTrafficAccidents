setwd("/Users/manish/Documents/Semester2/PFDA/Rcode")

accident <- data.frame(read.csv("Acc.csv", stringsAsFactors = TRUE, na.strings = "", header = TRUE))
casuality <- data.frame(read.csv("Cas.csv", stringsAsFactors = TRUE, na.strings = "", header = TRUE))
vehicle <- data.frame(read.csv("Veh.csv", stringsAsFactors = TRUE, na.strings = "", header = TRUE))

colSums(is.na(accident)) # Contains missing values
colSums(is.na(casuality)) # No missing values
colSums(is.na(vehicle)) # No missing values


completerecords <- na.omit(accident)
write.csv(completerecords, "Accidents.csv", row.names = FALSE)



accCleaned <- data.frame(read.csv("Accidents.csv", stringsAsFactors = TRUE, na.strings = "", header = TRUE))
colSums(is.na(accCleaned))

str(accCleaned)
accCleaned$Accident_Severity <- factor(accCleaned$Accident_Severity, levels = c(1,2,3), labels=c("Fatal", "Serious", "Slight"))
accCleaned$Day_of_Week <- factor(accCleaned$Day_of_Week, levels = c(1,2,3,4,5,6,7), labels = c("Sun","Mon","Tue","Wed","Thr","Fri","Sat"))

str(accCleaned)
accCleaned$Local_Authority_.Highway. <- factor(accCleaned$Local_Authority_.Highway.)

accCleaned$X1st_Road_Class <- factor(accCleaned$X1st_Road_Class,levels = c(1,2,3,4,5,6), labels = c("Motorway","AM","M","B","C","Unclassified"))

accCleaned$Road_Type <- factor(accCleaned$Road_Type, levels = c(1,2,3,6,7,9,12), labels = c("Roundabout","OneWayStreet","DualCarriageway","SingleCarriageway","SlipRoad","Unknown","OneWayStreet/Sliproad"))


accCleaned$X2nd_Road_Class <- factor(accCleaned$X2nd_Road_Class)

accCleaned$Light_Conditions <- factor(accCleaned$Light_Conditions, levels = c(1,4,5,6,7,-1), labels = c("Daylight","DarknessLightsLit","DarknessLightsUnlit","DarknessNoLighting","DarknessLightingUnknown","Missing"))
accCleaned$Weather_Conditions <- factor(accCleaned$Weather_Conditions, levels = c(1,2,3,4,5,6,7,8,9,-1), labels = c("NoHighWinds","RainingNoHighWinds","SnowingNoHighWinds","HighWinds","RainingHighWinds","SnowingHighWinds","Fog","Other","Unknown","Unknown"))
accCleaned$Road_Surface_Conditions <- factor(accCleaned$Road_Surface_Conditions, levels = c(1,2,3,4,5,6,7,-1), labels = c("Dry","Wet","Snow","Ice","Flood","OilOrDiesel","Mud","Unknown"))
accCleaned$Special_Conditions_at_Site <- factor(accCleaned$Special_Conditions_at_Site, levels = c(0,1,2,3,4,5,6,7,-1), labels = c("None","NoTrafficSignal","DefectiveSignalPart","NoRoadSign","RoadWorks","SurfaceDefective","OilOrDiesel","Mud","Unknown"))
accCleaned$Carriageway_Hazards <- factor(accCleaned$Carriageway_Hazards)
accCleaned$Urban_or_Rural_Area <- factor(accCleaned$Urban_or_Rural_Area, levels = c(1,2,3), labels = c("U","R","NL"))
accCleaned$Did_Police_Officer_Attend_Scene_of_Accident <- factor(accCleaned$Did_Police_Officer_Attend_Scene_of_Accident, levels = c(1,2,3), labels = c("Y","N","NR"))

accCleaned$Pedestrian_Crossing.Physical_Facilities <- factor(accCleaned$Pedestrian_Crossing.Physical_Facilities)
accCleaned$Junction_Detail <- factor(accCleaned$Junction_Detail)
accCleaned$Junction_Control <- factor(accCleaned$Junction_Control)


write.csv(accCleaned, "AccidentsCoded.csv", row.names = FALSE)


accCleaned$Time <- NULL
accCleaned$Date <- as.Date(accCleaned$Date)
accCleaned$LSOA_of_Accident_Location <- as.character(accCleaned$LSOA_of_Accident_Location)
accCleaned$Accident_Index <- NULL
accCleaned$Longitude <- NULL
accCleaned$Latitude <- NULL
accCleaned$Speed_limit <- NULL
accCleaned$Location_Easting_OSGR <- NULL
accCleaned$Location_Northing_OSGR <- NULL
accCleaned$Date <- NULL
accCleaned$Junction_Control <- NULL
accCleaned$Junction_Detail <- NULL
accCleaned$X2nd_Road_Class <- NULL
accCleaned$LSOA_of_Accident_Location <- NULL
accCleaned$Local_Authority_.Highway. <- as.numeric(accCleaned$Local_Authority_.Highway.)

str(accCleaned)


# Checking the class imbalance
table(accCleaned$Accident_Severity)

library(caret)
sample <- createDataPartition(accCleaned$Accident_Severity, p = .75, list = FALSE) 
train <- accCleaned[sample, ]
test <- accCleaned[-sample, ]


library(C50)

cFifty <- C5.0(Accident_Severity ~., data=train, trials=100)

str(train)

cFiftyPrediction <- predict(cFifty, newdata = test[, -2])
(cFiftyAccuracy <- 1- mean(cFiftyPrediction != test$Accident_Severity)) # It gives 81.53% accuracy

# Remove unnecesary variables
accCleaned$Did_Police_Officer_Attend_Scene_of_Accident <- NULL

accCleaned$Carriageway_Hazards <- NULL
accCleaned$X1st_Road_Number <- NULL
accCleaned$X2nd_Road_Number <- NULL
accCleaned$Police_Force <- NULL
accCleaned$Local_Authority_.Highway. <- NULL
accCleaned$Local_Authority_.District. <- NULL
accCleaned$Light_Conditions <- NULL
accCleaned$Weather_Conditions <- NULL
accCleaned$Road_Surface_Conditions <- NULL
trainNew <- accCleaned[sample, ]
testNew <- accCleaned[-sample, ]


cFiftyNew <- C5.0(Accident_Severity ~., data=trainNew, trials=50)

cFiftyPredictionNew <- predict(cFiftyNew, newdata = testNew[, -1])
(cFiftyAccuracyNew <- 1- mean(cFiftyPredictionNew != testNew$Accident_Severity))

cFiftyAccuracy - cFiftyAccuracyNew 

str(train)

library(randomForest)
forest <- randomForest(Accident_Severity ~ ., data=train, importance=TRUE, ntree=2000)
varImpPlot(forest)

forestPrediction <- predict(forest, test[,-1], type = "class")
(forestAcc <- 1- mean(forestPrediction != test$Accident_Severity))

