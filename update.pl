#/usr/bin/perl

use strict;
use warnings;

my $h=`rscript --vanilla  h.r`; 
$h=~s/\\//; 
$h=~s/\[1\]//;
$h=~s/\"//g;  

open CITES, "<tempcites.txt";
my %cites=();
while(<CITES>){
	chomp;
	$_=~m/(\S+)\s(\d+)/;
	my $id=$1; my $cites=$2;
	$cites{$id}=$cites;
}
close CITES;

open FILE, "<CV.temp.tex"; 
open CV, ">CV.tex"; 
while(<FILE>){ 
	if($_=~m/^H\-Index/){ 
		print CV "$h\n"; 
	} 
	elsif( $_=~m/CITES/ ){
		$_=~m/CITES:(\S+)/;
		my $tempid=$1; 
		my $citecount=0;
		foreach(keys(%cites)){ if( $_ ~~ $tempid){ $citecount=$cites{$tempid}; }}
		print CV "\\\\Citations: $citecount\\\\\n";
	}
	else{ 
		print CV $_;
	}    
}
close CV;
close FILE;
