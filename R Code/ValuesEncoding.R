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


# Now Casualty file will be coded
casuality$Casualty_Class <- factor(casuality$Casualty_Class, levels = c(1,2,3), labels = c("Driver","Passenger","Pedestrian"))

casuality$Sex_of_Casualty <- factor(casuality$Sex_of_Casualty, levels = c(1,2,-1), labels = c("M","F","U"))

casuality$Casualty_Severity <- factor(casuality$Casualty_Severity, levels = c(1,2,3), labels = c("Fatal","Serious","Slight"))

casuality$Car_Passenger <- factor(casuality$Car_Passenger, levels = c(0,1,2,-1), labels = c("NotCarPassenger","FrontSeat","RearSeat","Unknown"))

casuality$Casualty_Type <- factor(casuality$Casualty_Type, levels = c(0,1,2,3,4,5,8,9,10,11,16,17,18,19,20,21,22,23,90,97,98), labels = c("P","C","M50cc","M125cc","MO125","M500cc","T","C","MB","B","HR","AV","TO","V","GV","GVO","MS","EM","OV","MU","GVU"))



write.csv(casuality, "CasualtyCoded.csv", row.names = FALSE)


# Now Vehicle file will be coded
vehicle$Vehicle_Type <- factor(vehicle$Vehicle_Type, levels = c(1,2,3,4,5,8,9,10,11,16,17,18,19,20,21,22,23,90,97,98,-1), labels = c("PedalCycle","MotorCycle50cc","MotorCycle125cc","MotorCycleOver125","MotorCycle500","Taxi","Car","Minibus","Bus","Horse","AgricultureVehicle","Tram","Van","GoodsOver3.5t","Goods7.5t","Scooter","ElectricMotorcycle","OtherVehicle","MotorcycleUnknown","GoodsVehicleUnknown","Unknown"))

vehicle$Skidding_and_Overturning <- factor(vehicle$Skidding_and_Overturning, levels = c(0,1,2,3,4,5,-1), labels = c("N","S","SandO","J","JandO","O","U"))

vehicle$Sex_of_Driver <- factor(vehicle$Sex_of_Driver , levels = c(1,2,3,-1), labels = c("M","F","U","U"))

write.csv(vehicle, "VehicleCoded.csv", row.names = FALSE)





