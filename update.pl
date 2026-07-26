#/usr/bin/perl

use strict;
use warnings;

my $h=`rscript h.r`; 
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
	#print STDERR "$id\t$cites{$id}\n";
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
		my @tempids = split /,/, $tempid;
		foreach my $scholar_id (keys(%cites)){
			my %scholar_ids = map { $_ => 1 } split /,/, $scholar_id;
			foreach my $id (@tempids){
				if($scholar_ids{$id}){
					$citecount=$cites{$scholar_id};
					last;
				}
			}
			last if $citecount;
		}
#		print CV "\\\\Citations: $citecount\\\\\n";
		print CV "{} [$citecount]\\\\\n";
	}
	else{ 
		print CV $_;
	}    
}
close CV;
close FILE;
