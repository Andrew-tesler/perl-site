#!/usr/bin/perl 
use CGI;


require "/var/www/inc.pl";
require "/var/www/s.log.pl";

# create an instance of the CGI object 
$cgiobject = new CGI;
$greeting="Please enter your search";

print $cgiobject->header;
print $cgiobject->start_html(-title=>'ATP LOGS',-bgcolor=>'008980');
print "<H2>$greeting</H2>";
&output_form;

print $cgiobject->end_html;
                            
sub init()
 #initialize form field values
 { $search_term="Enter search term here.";
   $result_style="brief";
   $result_perpage=50;
 }

sub output_form()
 #construct and output the form HTML
 { $theform=$cgiobject->startform(-name=>'searchform',
                                  -method=>'get',
                                  -action=>'main.pl');  # Pay attention to this dir!!!!!! may invoke problems if migrating to new server.
   #create serial# search field
   $theform.="Search SN#: ";
   $theform.=$cgiobject->textfield(-name=>'serial_number',
                                   -size=>50,
                                   -default=>$search_term);
                                                            
   #create submit and reset buttons
   $theform.="<BR><BR>";
   $theform.=$cgiobject->submit(-label=>'Submit');
   $theform.=$cgiobject->reset(-label=>'Clear');
   
   $theform.=$cgiobject->endform;                                                           
   print $theform
 }      


