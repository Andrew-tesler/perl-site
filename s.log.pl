#!/usr/bin/perl 

require "/var/www/inc.pl";


sub return_product_batch {
my $src = "$bo_dir/bo.db";
 open my $fh, $src;
 my @lines = sort grep //i, <$fh>;
 close $fh;
 return @lines;
  # sort numerically ascending
@lines = sort {$d <=> $a} @lines;
 return @sorted_temp;
 }    
 
@batch = return_product_batch;
#print @batch;

