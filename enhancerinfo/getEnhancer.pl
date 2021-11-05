#!/usr/bin/perl
use List::MoreUtils qw(uniq);
use List::Util qw(min max sum);
$enhfile=$ARGV[0];
$species=$ARGV[1];
$outdir=$ARGV[2];

$allenhs="";
if($species eq "mouse"){
$allenhs="allenhsmouse.bed";
}else{
$allenhs="allenhs.bed";
}

mkdir("./$outdir/Temp/enhancer");

## Find overlapping regions from their enhancer list and your enhancer list
system("bedtools intersect -a ./enhancerinfo/$allenhs -b ./".$enhfile." -wa -wb>./$outdir/Temp/enhancer/cellenhspre.bed");

## Setup array and associative array
@tempenhs=();
%hashtempenh=();

## Assign input enhancer scores to all enhancers list given by the program
open CELLENH,"./$outdir/Temp/enhancer/cellenhspre.bed";
while(<CELLENH>){
    chomp($_); ## remove new line
    @temp=split/\t/,$_;
    if(!exists $hashtempenh{$temp[0]."\t".$temp[1]."\t".$temp[2]}){
	$hashtempenh{$temp[0]."\t".$temp[1]."\t".$temp[2]}=$temp[7];
	push @tempenhs,$temp[0]."\t".$temp[1]."\t".$temp[2];
    }elsif(exists $hashtempenh{$temp[0]."\t".$temp[1]."\t".$temp[2]} && $hashtempenh{$temp[0]."\t".$temp[1]."\t".$temp[2]}<$temp[7]){
	$hashtempenh{$temp[0]."\t".$temp[1]."\t".$temp[2]}=$temp[7];
    }
}
close CELLENH;

## Print new list of enhancers with the enhancer score given in the input
open CELLSTANDARD,">./$outdir/Temp/enhancer/cellenhs.bed";
foreach $enh (@tempenhs){
    print CELLSTANDARD $enh."\t".$hashtempenh{$enh}."\n";
}
close CELLSTANDARD;
