user_record = LOAD 'hdfs://localhost:54310/sqoop/input/ukAccidents/000000_0' USING PigStorage(',') AS(accIndex:chararray,locEast:chararray,locnorth:chararray,longitude:chararray,latitude:chararray,policeforce:chararray,accseverity:chararray,noOfVehicles: int,noOfCasualities:int,dayOfAccident:chararray,dayOfWeek:chararray,time:chararray,district:chararray,highway:chararray,x1roadclass:chararray,x1roadnumber:chararray,roadtype:int,speedlimit:int,junctiondetail:chararray,junctioncontrol:chararray,x2roadclass:chararray,x2roadnumber:chararray,humancontrol:chararray,physicalfacilities:chararray,lightconditions:chararray,weatherconditions:chararray,roadconditions:chararray,specialconditions:chararray,carriagewayhazards:chararray,urbanOrRural:chararray,officeAttended:chararray,LSOAAccidentLoc:chararray);
ft = FILTER user_record BY lightconditions != 'Unknown';
state_record = GROUP ft BY (lightconditions,roadconditions);
output_record = FOREACH state_record GENERATE group, COUNT(ft.noOfCasualities) as cnt;
sorted = ORDER output_record BY cnt DESC;
STORE sorted INTO 'hdfs://localhost:54310/ukAccidentPig' USING PigStorage(',');
DUMP sorted;
