# Main directory file for log.pl site 

# All the directories will end with "/" 

# Location of the log files directory
log_dir = "/mnt/drop-log/release/compulab/console/";

# Location of the bo.db file 
bo_dir = "/home/andrew/Desktop/";

# The real locations on the server

#$log_dir = "/var/opt/atp/drop-log/release/compulab/console/";
#$atp_dir = "/var/opt/atp";
#$bo_dir =  $atp_dir."/config/1";
#$bo_db = $bo_dir."/bo.db";

@products = ("fit-PC3","SBC-fit-PC3","intense-PC","FM-LAN","FM-XTD","FM-4U" );
@tests = ("All","CPU","USB","Audio","Thermal","NTP","Update","total time","MAC","Ethernet");


