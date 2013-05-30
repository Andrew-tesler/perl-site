#!/usr/bin/perl 
 # Use for color text
 use Term::ANSIColor qw(:pushpop);
 use CGI qw/:standard :html3/;
 # All the directories are located in this file
 require "/var/www/inc.pl";
 
 #require "test.logs.pl";
 
 # create an instance of the CGI object 
 $cgiobject =   new CGI;
 
 # Overide for "inc.pl" the original file don't work well TODO- fix inc.pl 
 #$log_dir="/mnt/atp/drop-log/release/compulab/console/";

 # grab the values submitted by the user
 $serial=$cgiobject->		param("serial_number");  # Serial number submited by the user
 #$error=$cgiobject->        param("error_number");   # Error number submited by the user //Not implemented//
 #$product=$cgiobject->      param("products");       # Search by product 
 #$print_file=$cgiobject->   param("print_file");     # Check box if the user want to print the file and look directly at it
 #$display_logs=$cgiobject-> param("display_logs");   # Display the logs //Need further evaluation//
 #@tested_device=$cgiobject->param("tested_device");  # Dispaly in table mode the selected devices only
 #$batch_line=$cgiobject->   param("batch_line");     # Dispaly the batch line of the product
 #$summ=$cgiobject->         param("quick_summary");  # Quick summary of many logs // TODO - How the format will look table or text //



 # If user selects all test. paste all the tests to array and remove the all value.
 if (@tested_device[0] eq "All"){
     @tested_device = @tests;
 	 shift(@tested_device);
 }


 # Initialize the document
 print $cgiobject -> header;
 print $cgiobject -> start_html(-title => "ATP logs",
                    -bgcolor => "#90EE90",
                    -text => "black");
print $cgiobject -> h1("ATP logs summary");

 # Debug sub print the values entered by the user
 sub debug {	
	print $cgiobject->p("The serial number is: $serial");
	print $cgiobject->p("The log dir is:       $log_dir");
	#print $cgiobject->p("Error selected:       $error");   
	#print $cgiobject->p("Product selected:     $product");
	#print $cgiobject->p("Print file:           $print_file");
	#print $cgiobject->p("Display logs:         $display_logs");
	#print $cgiobject->p("Tested device:        @tested_device");
	#print $cgiobject->p("Batch line:           $batch_line");
	#print $cgiobject->p("Summ:                 $summ");
 } 



 sub local_time {
	$now = localtime();
	return "The local time is: ". $now;
 }
 
 # Accept number and search for the dir starting by that number (Enter number);
 sub find_dir {
	$number = @_[0];
	opendir (DIR, "$log_dir") || (print "Cannot open directory (look in the find_dir script)");
	@numbers= grep {/$number/} readdir(DIR);
    @numbers = sort {$a cmp $b} @numbers;
    print "You serching in the following dirrectories:","<br>";
    print "----------------------------------------------------","<br>";
    foreach $gh(@numbers)
		{
			print $gh;
			print"<br>";
		}
    closedir DIR;
    return @numbers;
 }



#print $test;
 # will return all the files that located in given dir. need to enter the full serial number (Enter serial number from find_dir)
 sub find_file {
	 $number = @_[0];  
	 $dir = $log_dir;
	 $dir = "$dir$number";  # Dir for the full path to the files.   
	 opendir (DIR, "$dir") || (print "Cannot open directory (look in the find_file script)");
	 @files= grep {/$number/} readdir(DIR);
	 @files = sort {$a cmp $b} @files;
	 closedir DIR;
	 return @files
}

 # Return the line of the given file and search string. Parse full log number ( Enter Serial number from find dir and the file from find_file )
 sub find_line {
	 $dir = @_[0];         # Dir for search (full serial number)
	 $file = @_[1];        # Log file under search (log file with the *.console ending)
	 $string = @_[2];      # String for the search
	 $file = "$log_dir$dir/$file";
	 open $fh, $file || (print "Can't open file refer to find_line script for debug");   # Open the file or print error message
	 @lines  = <$fh>;																					
     @grepLine = grep(/^$string/, @lines); 
     close $fh;
     return @grepLine[0];
 }

 # Return the file in array line by line
 sub returnFile {
	 $dir = @_[0];         # Dir for search (full serial number)
	 $file = @_[1];        # Log file under search (log file with the *.console ending)
	 $string = @_[2];      # String for the search
	 $file = "$log_dir$dir/$file";
	 
	 open $fh, $file || (print "Can't open file refer to find_line script for debug");   # Open the file or print error message
	 @lines  = <$fh>;	
	 close $fh;
	 return @lines;
}

#~ 
#~ 
#~ # Return the test line given ("file , test to find)
#~ #  File to test-
 
 # sub print_test {
 # my $string1 = "@_[1]";
 # my $src = "$log_dir$serial/@_[0].0.console";
 # open my $fh, $src;
 # my @lines = sort grep /\Q$string1/i, <$fh>;
#  close $fh;
 # return @lines[0];
 # }
#~ 
	#~ # TODO - test if the following line actualy do somthing usefull
	#~ $temp = print_test $number , "succes";
	#~ print $temp;
#~ 
#~ 
#~ # Check if "OK" string is present in specific log (File, Test to find).
 #~ sub check {
    #~ my $tmp=print_test "$_[0]", "$_[1]";
    #~ @temp =split(/,/,$tmp);
 #~ return @temp[1];
 #~ }
 #~ 
 #~ # Check and return the device name in specific log file (File, Test to find) TODO - Check if the script returns the correct string @temp[1] returns the same as "sub check" above
  #~ sub check_device {
    #~ my $tmp=print_test "$_[0]", "$_[1]";
   #~ @temp = split(/:/,$tmp);
   #~ return @temp[1];
 #~ }
 #~ 
#~ # Uses the s.log.pl script for $batch_line
#~ # Return the batch line corresponding with given log file -TODO - Test if correct 
#~ sub log_batch_line {
	#~ @sorted_batch_line = split(/ /,$batch_line,); 
	#~ return @sorted_batch_line;
#~ }
#~ 
#~ # Return the serial numbers from the given batch line
#~ sub serial_numbers_batch {
	#~ @temp = log_batch_line;
	#~ #print "@temp"."<br>";
	#~ $qty = @sorted_batch_line[1];
	#~ #print "The qty is: $qty"."<br>";
	#~ @serial_nembers_batch = ();
	#~ @temp_serial = split(/-/, @temp[0]);
	#~ $begining = @temp_serial[0];
	#~ $SN = @temp_serial[1];
	#~ for (1 .. $qty){
		#~ #fix for zero problem
		#~ $SN = $SN + 0;
		#~ if ($SN < 10000){
			#~ $zero="0";
		#~ }
		#~ if ($SN < 1000){
			#~ $zero = "00";
		#~ }
		#~ if ($SN < 100){
			#~ $zero = "000";
		#~ }
		#~ if ($SN < 10){
			#~ $zero = "0000";
		#~ }
		#~ push (@serial_nembers_batch, "$begining-$zero$SN");
		#~ $SN++;
	#~ }
	#~ $n = 1;
	#~ foreach $i(@serial_nembers_batch){
		#~ #print "The $n number is: $i"."<br>";
		#~ $n++;
	#~ } 
	#~ print "----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"."<br>";
 #~ return @serial_nembers_batch;
#~ 
#~ }
#~ 
#~ # Print information regarding the batch line formated ("Tested product: configuration: From SN#: Total of: cards"
#~ sub print_formated_batch {
	#~ log_batch_line;
	#~ print @formated = "Tested product: ", @sorted_batch_line[3], "  configuration: ", @sorted_batch_line[4], "  from SN#: ", @sorted_batch_line[0], "  Total of: ", @sorted_batch_line[1], "  cards.<br>"	;
#~ }
#~ 
#~ # Return all the log files in the given dir TODO - fix why $log_dir don't work?
#~ sub find_log {
	#~ $number = @_[0];
	#~ $tmp="/mnt/drop-log/release/compulab/console/$serial/";                        
	#~ opendir (DIR, "$tmp") || (print "Cannot open directory (look in the find_log script)");
	#~ @numbers= grep {/$number/} readdir(DIR);
    #~ @numbers = sort {$a cmp $b} @numbers;
    #~ print "The file is: "."@numbers"."<br>";
    #~ closedir DIR;
    #~ return @numbers;
#~ }
#~ 
#~ 
#~ # Look for the log files begining with the given serial and print them
#~ sub open_files {
	#~ $serial_number = @_[0];
	#~ #print "Log dir ... ".$log_dir."<br>";
	#~ #print "the serial is: ". $serial_number."<br>";
    #~ @serial_number = find_log $serial_number;
    #~ $files_count =  scalar @serial_number;
#~ # if choose "print files" Display the log files
#~ if ($display_logs eq 'Display attempts'){
	#~ $i=1;
#~ #print "for the $serial_number tested total: $files_count "."  files "."<br>";
#~ foreach $n(@serial_number){
	#~ print "Log $i number: $n"."<br>";
	#~ $i++;
#~ }
#~ }
#~ return @serial_number;
#~ }
#~ 
#~ 
#~ # Will return succes if pass fail if not & error code or not found if non of the strings found
#~ sub check_status {
	#~ my $result = "";
#~ $tmp = print_test @_[0] , "success";
	#~ if ((print_test @_[0] , "success") =~ "succes"){
		#~ $result  = a({-style=>'Color: #0000FF;'},"SN: ", @_[0],"   ", "Pass");
	#~ }
	#~ else {
		#~ $result = "Not found succes";
#~ $tmp = print_test @_[0] , "fail";	
#~ if ((print_test @_[0] , "fail") =~ "fail"){
	#~ $result = print_test @_[0] , "error";
	#~ @result = split (/:/,$result);
	#~ 
	#~ $result = a({-style=>'Color: #FF0000;'},"SN: ", @_[0],"   " ,"    Status:  ","@result[2], @result[1],@result[3],@result[4]");
#~ }
#~ else {
	#~ $result = a({-style=>'Color: #FF0000;'}, "SN: ", @_[0],"   ","Not found failure");
#~ }
#~ return $result;
#~ }
#~ }
#~ 
#~ 
#~ # Print summary (device tested, passed, failed, summary of errors) return the SN and Pass fail next to the file.
#~ sub quick_summary {
	#~ $serial_number = @_[0];
	#~ $times_tested = 1;
	#~ #print "Log dir ... ".$log_dir."<br>";
	#~ #print "the serial is: ". $serial_number."<br>";
    #~ @serial_number = find_log $serial_number;
    #~ $files_count =  scalar @serial_number;
    #~ if ($files_count >0) {
    #~ print "The $serial_number was tested for: $files_count times  <br>   ";
    #~ foreach $n(@serial_number){
	    #~ $temp = check_status $n;
	    #~ #print $temp;
	    #~ if ($temp =~ "Pass") {
			#~ $result = a({-style=>'Color: #0027FF;'}, "    The file passed <br>");
		#~ }
		#~ else {
			#~ if ($temp =~ "error") {
			#~ print $temp, "<br>";
			#~ $result = a({-style=>'Color: #FF0000;'}, "   The file failed <br>");
		#~ }
		#~ else {
			#~ $result = "File not found";
		#~ }
	#~ }
#~ 
#~ }
	#~ print "$result", "<br>";
	#~ print "*****************************************************","<br>";	
#~ }
#~ }
#~ 
#~ # Print the file line by line
#~ sub print_file {
   #~ $file = "$log_dir$serial/@_[0]";
   #~ print "Printing the following log file:  @_[0]","<br>";
   #~ open(FILE, "<$file");
   #~ while(<FILE>) {
	   #~ $result  = a({-style=>'Color: #4D4D82;'},"$_");
      #~ print $result,"<br>";
   #~ }
   #~ close(FILE);
#~ }
#~ # The sub for the table represantation of the logs
#~ # if the file have "console" string print the file as is
#~ sub print_tables {
	#~ $serial = @_[0];	
	#~ if ($serial =~ "console"){
		#~ push (@serial_number , "$serial");
	#~ }
	 #~ foreach $serial_number(@serial_number){
		  #~ @status=();
          #~ @result_device=();
          #~ 
          #~ foreach $tested_device(@tested_device){
			  #~ $temp = check "$serial_number" , "$tested_device";  
              #~ if ($temp =~ "ok"){		  
                   #~ push (@status, "$temp");
			   #~ }	   
                #~ else { push (@status, "*****");
			#~ }
		#~ }
        #~ foreach $tested_device(@tested_device){			
            #~ $temp2 = check_device "$serial_number" , "$tested_device";  
            #~ push (@result_device, "$temp2");
		#~ }
        #~ #tested device table
#~ 
        #~ print  check_status $serial_number;
        #~ 
        #~ @tops = ("Device","Result device","Status");
        #~ print $q->table({-border=>3, -cellpadding => 6},
                #~ #$q->caption("Serial number: $serial_number"),
                #~ $q->Tr([$q->td([$q->b($tops[0]),@tested_device])]),
                #~ $q->Tr([$q->td([$q->b($tops[1]),@result_device])]),
                #~ $q->Tr([$q->td([$q->b($tops[2]),@status])]),         
                #~ ),                      
               #~ }
              #~ }
 #~ 
#~ 
#~ # Flow command for the script with some if else commands
#~ print_time;
#~ 
#~ if ($print_file =~ "Print file") {
	#~ print_file $serial; 
#~ }
#~ else {
#~ if ($batch_line > "  ") {
	#~ @test = serial_numbers_batch;
	 #~ print_formated_batch;
    #~ foreach $num(@test) { 
		#~ if ($summ =~ "Quick Summary") {
			#~ open_files $num;
			#~ quick_summary $num;
		#~ }
		#~ else {
			 #~ open_files $num;
			 #~ print_tables $num;
		 #~ }
	 #~ }
 #~ }
#~ else {
	#~ if ($summ =~ "Quick Summary") {
		#~ $test = $serial;
		#~ open_files $test;
		#~ quick_summary $test;
	#~ }
	#~ else {
		#~ $test = $serial;
		#~ open_files $test;
		#~ print_tables $test;
	#~ }
#~ }
#~ }	

debug;
print local_time;
print "<br>";
@i = find_dir "$serial";


foreach $n(@i) {
print "Searching serial: ","$n" ;
@z=find_file $n;

foreach $z(@z) {
	print "<br>found the file: $z<br>";
	print find_line $n,$z,"MOTHERBOARD";
	print "<br>";  
	print find_line $n,$z,"BOARD";
	print find_line $n,$z,"BIOS";
	print "<br>";
	print find_line $n,$z,"CONFIG";
	print "<br>";

	

}
print "<br>";
}
