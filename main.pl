#!/usr/bin/perl 
 # Use for color text
 use Term::ANSIColor qw(:pushpop);
 use CGI qw/:standard :html3/;
 # All the directories are located in this file
 require "/var/www/inc.pl";

 
 # create an instance of the CGI object 
 $cgiobject =   new CGI;
 


 # grab the values submitted by the user
 $serial=$cgiobject->		param("serial_number");  # Serial number submited by the user




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
		print "----------------------------------------------------<br>";
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
	 open $fh, $file || (print "Can't open file refer to find_line script for debug(Don't forget to mount enclosed-atp-srv:/var/opt/)");   # Open the file or print error message
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

debug;
print local_time;
print "<br>";
@i = find_dir "$serial";


foreach $n(@i) {
print "Found serial: ","$n" ;
@z=find_file $n;
print "<br>**************************************<br>";
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
print "<br>**************************************<br>";
}
