#!/usr/bin/perl 
#require "inc.pl";
#require "test.logs.pl";
# create an instance of the CGI object 
$cgiobject = new CGI;
$greeting="Please enter your search term by serial";

print $cgiobject->header;
print $cgiobject->start_html(-title=>'ATP LOGS',-bgcolor=>'008980');
print "<H2>$greeting</H2>";
&output_form;

print $cgiobject->end_html;
                            
