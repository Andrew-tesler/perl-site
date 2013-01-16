#!/usr/bin/perl 
use CGI;

#
require "/var/www/perl/inc.pl";
#require "/var/www/perl/s.log.pl";

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
   #create error # search field
   $theform.="Search error#: ";
   $theform.=$cgiobject->textfield(-name=>'error_number',
                                   -size=>30,
                                   -default=>$search_term);                                
                                              
   #create ignore gae 
   $theform.="<BR>Results type:";
   $theform.=$cgiobject->radio_group(-name=>'display_logs',
                                     -values=>["Display attempts","Hide attempts"],
                                     -default=>"Hide log files");
                                   
   #create include all or only by SUCCES ERROR
   $theform.="<BR>Print log file:";
   $theform.=$cgiobject->radio_group(-name=>'print_file',
                                     -values=>["NO","Print file"],
                                     -default=>"NO");
                                     
    #create select box for products 
    $theform.="<BR>Products<BR>";
    $theform.=$cgiobject->scrolling_list(-name=>'products',
                                         -values=>[@products],                                 
                                         -size=>8,
                                        -multiple=>'false');
   #Create search by devices choose box                                     
   $theform.="<BR>Errors:<BR>";  
   $theform.=$cgiobject-> scrolling_list(-name=>'tested_device',
			            	-values=>[@tests],
			            	-default=>['All'],
				            -size=>8,
				            -multiple=>'true',
                            -labels=>\%labels,
                            -attributes=>\%attributes);
                            
    # Create search by batch lines                         
    $theform.="<BR>Batch Line<BR>";
    $theform.=$cgiobject->scrolling_list(-name=>'batch_line',
                                         -values=>[@batch],
                                         -default=>['0'],                                 
                                         -size=>15,
                                         -multiple=>'false');  
                                         
    #Create quick summary buttons. 
   $theform.="<BR>Results type:";
   $theform.=$cgiobject->radio_group(-name=>'quick_summary',
                                     -values=>["Quick Summary","Table"],
                                     -default=>$ignore_gae);                                                           
   
   
   #create submit and reset buttons
   $theform.="<BR><BR>";
   $theform.=$cgiobject->submit(-label=>'Submit');
   $theform.=$cgiobject->reset(-label=>'Clear');
   
   $theform.=$cgiobject->endform;                                                           
   print $theform
 }      


