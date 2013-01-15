#!/usr/bin/perl 
use Term::ANSIColor qw(:pushpop);
use CGI qw/:standard :html3/;

require "/var/www/perl/inc.pl";
#require "test.logs.pl";
# create an instance of the CGI object 
$cgiobject = new CGI;
$q = new CGI;
# $query = new CGI;
 


# grab the values submitted by the user
$serial=$cgiobject->param("serial_number");
$error=$cgiobject->param("error_number");
$product=$cgiobject->param("products");
$print_file=$cgiobject->param("print_file");
$display_logs=$cgiobject->param("display_logs");
@tested_device=$cgiobject->param("tested_device");
$batch_line=$cgiobject->param("batch_line");
$summ=$cgiobject->param("quick_summary");

#if user selects all test. paste all the tests to arrey and remove the all value.
if (@tested_device[0] eq "All"){
	@tested_device = @tests;
	shift(@tested_device);
}



print $q -> header;
print $q -> start_html(-title => "ATP logs",
                -bgcolor => "#90EE90",
                -text => "black");
print $q -> h1("ATP logs summary");

#print $q->b("$serial");
#print $q->p("$display_logs");
#print $q->p("$error");

#Print the file

# local time 
sub print_time {
	$now = localtime();
	print $q ->p  ("Now: ",$now);
}

sub PrintFile {
   my ($file) = "$log_dir/@_[0]";
   open(FILE, "<$file");
   while(<FILE>) {
      print $_, "<br>";
   }
   close(FILE);
}
#return the serial numbers from the given batch

 # return the test line given ("file , test to find)
 sub print_test {
 my $string1 = "@_[1]";
 my $src = "$log_dir$serial/@_[0].0.console";
 open my $fh, $src;
 my @lines = sort grep /\Q$string1/i, <$fh>;
 close $fh;
 return @lines[0];
 }

	
	$temp = print_test $number , "succes";
	print $temp;

# return the tested functionalaty an OK string if present
 sub check {
    my $tmp=print_test "$_[0]", "$_[1]";
   @temp =split(/,/,$tmp);
   return @temp[1];

 }
 # will return the device name
  sub check_device {
    my $tmp=print_test "$_[0]", "$_[1]";
   @temp = split(/:/,$tmp);
   return @temp[1];
 }
#return the batch line as array
sub log_batch_line {
	@sorted_batch_line = split(/ /,$batch_line,); 
	return @sorted_batch_line;
}

sub serial_numbers_batch {
	@temp = log_batch_line;
	#print "@temp"."<br>";
	$qty = @sorted_batch_line[1];
	#print "The qty is: $qty"."<br>";
	@serial_nembers_batch = ();
	@temp_serial = split(/-/, @temp[0]);
	$begining = @temp_serial[0];
	$SN = @temp_serial[1];
	for (1 .. $qty){
		#fix for zero problem
		$SN = $SN + 0;
		if ($SN < 10000){
			$zero="0";
		}
		if ($SN < 1000){
			$zero = "00";
		}
		if ($SN < 100){
			$zero = "000";
		}
		if ($SN < 10){
			$zero = "0000";
		}
		push (@serial_nembers_batch, "$begining-$zero$SN");
		$SN++;
	}
	$n = 1;
	foreach $i(@serial_nembers_batch){
		#print "The $n number is: $i"."<br>";
		$n++;
	} 
	print "----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"."<br>";
 return @serial_nembers_batch;

}
# print information regarding the batch line formated
sub print_formated_batch {
	log_batch_line;
	print @formated = "Tested product: ", @sorted_batch_line[3], "  configuration: ", @sorted_batch_line[4], "  from SN#: ", @sorted_batch_line[0], "  Total of: ", @sorted_batch_line[1], "  cards.<br>"	;
}

# return the serial file with the .log.* suffix
sub find_log {
	$number = @_[0];
	opendir (DIR, "$log_dir$$number") || die(print "Cannot open directory (look in the find_log script)");
	 @numbers= grep {/$number.*.*/} readdir(DIR);

	#print "$log_dir$serial"."<br>";
	#print "/$number.*"."<br>";
	#opendir(IMD, "/home/yourname/www/images/") || die("Cannot open directory"); 
	#my @numbers = grep {/$number1120610-02228.0.console/}  readdir DIR;
    @numbers = sort {$a cmp $b} @numbers;
    print @numbers."<br>";
    closedir DIR;
    #return @numbers;

}


# look for the log files begining with the given serial and print them
sub open_files {
	$serial_number = @_[0];
	#print "Log dir ... ".$log_dir."<br>";
	#print "the serial is: ". $serial_number."<br>";
    @serial_number = find_log $serial_number;
    $files_count =  scalar @serial_number;
# if choose "print files" Display the log files
if ($display_logs eq 'Display attempts'){
	$i=1;
#print "for the $serial_number tested total: $files_count "."  files "."<br>";
foreach $n(@serial_number){
	print "Log $i number: $n"."<br>";
	$i++;
}
}

return @serial_number;
}


#Will return succes if pass fail if not & error code or not found if non of the strings found
sub check_status {
	my $result = "";
$tmp = print_test @_[0] , "success";
	if ((print_test @_[0] , "success") =~ "succes"){
		$result  = a({-style=>'Color: #0000FF;'},"SN: ", @_[0],"   ", "Pass");
	}
	else {
		$result = "Not found succes";
$tmp = print_test @_[0] , "fail";	
if ((print_test @_[0] , "fail") =~ "fail"){
	$result = print_test @_[0] , "error";
	@result = split (/:/,$result);
	
	$result = a({-style=>'Color: #FF0000;'},"SN: ", @_[0],"   " ,"    Status:  ","@result[2], @result[1],@result[3],@result[4]");
}
else {
	$result = a({-style=>'Color: #FF0000;'}, "SN: ", @_[0],"   ","Not found failure");
}

return $result;
}
}


 # print summary (device tested, passed, failed, summary of errors) return the SN and Pass fail next to the file.
sub quick_summary {
	$serial_number = @_[0];
	$times_tested = 1;
	#print "Log dir ... ".$log_dir."<br>";
	#print "the serial is: ". $serial_number."<br>";
    @serial_number = find_log $serial_number;
    $files_count =  scalar @serial_number;
    if ($files_count >0) {
    print "The $serial_number was tested for: $files_count times  <br>   ";
    foreach $n(@serial_number){
	    $temp = check_status $n;
	    #print $temp;
	    if ($temp =~ "Pass") {
			$result = a({-style=>'Color: #0027FF;'}, "    The file passed <br>");
		}
		else {
			if ($temp =~ "error") {
			print $temp, "<br>";
			$result = a({-style=>'Color: #FF0000;'}, "   The file failed <br>");
		}
		else {
			$result = "File not found";
		}
	}

}

	print "$result", "<br>";
	print "*****************************************************","<br>";	
}
}

#print the file line by line
sub print_file {
   $file = "$log_dir$serial/@_[0]";
   print "Printing the following log file:  @_[0]","<br>";
   open(FILE, "<$file");
   while(<FILE>) {
	   $result  = a({-style=>'Color: #4D4D82;'},"$_");
      print $result,"<br>";
   }
   close(FILE);
}

# The main loops for if with *.log.0 print as is if not complite the files and print them by turn. 
sub print_tables {
	$serial = @_[0];	
	if ($serial =~ "console"){
		push (@serial_number , "$serial");
	}
	 foreach $serial_number(@serial_number){
		  @status=();
          @result_device=();
          
          foreach $tested_device(@tested_device){
			  $temp = check "$serial_number" , "$tested_device";  
              if ($temp =~ "ok"){		  
                   push (@status, "$temp");
			   }	   
                else { push (@status, "*****");
			}
		}
        foreach $tested_device(@tested_device){			
            $temp2 = check_device "$serial_number" , "$tested_device";  
            push (@result_device, "$temp2");
		}
        #tested device table

        print  check_status $serial_number;
        
        @tops = ("Device","Result device","Status");
        print $q->table({-border=>3, -cellpadding => 6},
                #$q->caption("Serial number: $serial_number"),
                $q->Tr([$q->td([$q->b($tops[0]),@tested_device])]),
                $q->Tr([$q->td([$q->b($tops[1]),@result_device])]),
                $q->Tr([$q->td([$q->b($tops[2]),@status])]),         
                ),
                         
               }
     

              }
 


#print_tables;
#serial_numbers_batch;
#open_files $serial;

print_time;

if ($print_file =~ "Print file") {
	print_file $serial; 
}
else {
if ($batch_line > "  ") {
	@test = serial_numbers_batch;
	 print_formated_batch;
    foreach $num(@test) { 
		if ($summ =~ "Quick Summary") {
			open_files $num;
			quick_summary $num;
		}
		else {
			 open_files $num;
			 print_tables $num;
		 }
	 }
 }
else {
	if ($summ =~ "Quick Summary") {
		$test = $serial;
		open_files $test;
		quick_summary $test;
	}
	else {
		$test = $serial;
		open_files $test;
		print_tables $test;
	}
}
}	
	
#quick_summary "$serial";


#print check_status @serial_number[0];
 #   print p({-style=>'Color: red;'},'Welcome to Hell');
#print p({-class=>'Fancy'},'Welcome to the Party');



#print_formated_batch;

#print check "$serial" , "$tested_device";

