#!/usr/bin/perl
use CGI;
@coms = (5, 8, 9);
$string="53400029e380000016830c301008016";   
$logFile = "log.serial.counter.txt" ;     
$dir="/home/andrew/Desktop";
$arreyLenght = @coms;                   


my $query= new CGI;
print $query->header;
print "Testing string: $string<br>";
print " On the following serials:<br>";
# Print the devices under test
foreach $com (@coms) {
print "/dev/ttyS$com";
print "<br>";
}
# Print "*" 
for ($i=0;$i<200;$i++) {
	print "*";
}


#foreach $com (@coms) {
#	$count= `cat $dir/com_$com.txt | grep -c $string`;
#    print "<br>$count<br>";
#}
$time = `date`;

print "<br>The local time is: $time <br>";


# SET UP THE HTML TABLE
print "<table border='1'>";

foreach $com (@coms) {
	# PRINT A NEW ROW EACH TIME THROUGH W/ INCREMENT
	$count= `cat $dir/com_$com.txt | grep -c $string`;
	print "<tr><td>Testing Com port $com</td><td>Powered ON: $count times</td></tr>";
}
# FINISH THE TABLE
print "</table>";



