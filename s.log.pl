#!/usr/bin/perl 

require "inc.pl";
my $bo = "/bo.db";

 sub return_product_batch {
my $src = "$bo_dir$bo";
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

