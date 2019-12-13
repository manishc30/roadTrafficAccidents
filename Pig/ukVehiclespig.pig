user_record = LOAD 'hdfs://localhost:54310/sqoop/input/ukVehicles/000000_0' USING PigStorage(',') AS(accIndex:chararray,vehicleRef:chararray,vehicletype:chararray,toworarticluate:chararray,vehiclemanoeuvre:chararray,vehcileloc:chararray,skidoroverturn:chararray,hitobjincarriageway: int,vehicleleavingcarriageway:chararray,hitobjoffcarriageway:chararray,pointofimpact:chararray,lefthanddrive:chararray,journeypurpose:
chararray,gender:chararray,driverage:int,driverageband:chararray,enginecapacity:chararray,propulsioncode:int,vehicleage:int,driverimddecile:
chararray,driverhomeareatype:chararray,vehicleimddecile:chararray);

group_record = GROUP user_record BY vehicletype;
output_record = FOREACH group_record GENERATE group, COUNT(user_record.accIndex) as cnt;
sorted = ORDER output_record BY cnt DESC;
STORE sorted INTO 'hdfs://localhost:54310//ukVehiclespig' USING PigStorage(',');
DUMP sorted;

