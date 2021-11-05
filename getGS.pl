use List::MoreUtils qw(uniq);
use List::Util qw(min max sum);
$genefile=$ARGV[0];
$outdir=$ARGV[1];

mkdir("./$outdir/GS");
open FILE,$genefile;
%hashcellgeneTosig=();
while(<FILE>){
chomp($_);
@temp=split/\t/,$_;
if($temp[0]=~ /ENSG|ENSMUSG/){
$hashcellgeneTosig{$temp[0]}=$temp[1];
}
}
close FILE;
open PAIR,"./$outdir/Temp/pair/Pairs.bed";
open CELLGS,">./$outdir/GS/GS.bed";
@pairs=();
while(<PAIR>){
chomp($_);
@temp=split/\t/,$_;
$pair=$temp[4].":".$temp[5]."-".$temp[6]."_".$temp[3];
@genescoreinfo=split/\$/,$temp[3];
print CELLGS $pair."\t".$hashcellgeneTosig{$genescoreinfo[0]}."\n";

}
close PAIR;
close CELLGS;
