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
my $in_preprints = 0;
my $pending_preprint_citation = 0;
while(<FILE>){ 
	if($_=~m/^\\subsection\*\{Preprints\}/){
		$in_preprints = 1;
		print CV $_;
	}
	elsif($in_preprints && $_=~m/^\\end\{itemize\}/){
		$in_preprints = 0;
		print CV $_;
	}
	elsif($in_preprints && $_=~m/^\\item /){
		$pending_preprint_citation = 1;
		$_=~s/\\\\\s*$/ /;
		print CV $_;
	}
	elsif($_=~m/^H\-Index/){ 
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
		if($pending_preprint_citation){
			print CV "[$citecount]\\\\\n";
			$pending_preprint_citation = 0;
		}
		else{
			print CV "{} [$citecount]\\\\\n";
		}
	}
	else{ 
		print CV $_;
	}    
}
close CV;
close FILE;
