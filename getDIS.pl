use List::MoreUtils qw(uniq);
use List::Util qw(min max sum);
$outdir=$ARGV[0];

mkdir("./$outdir/DIS");
open PAIR,"./$outdir/Temp/pair/Pairs.bed";
open PAIRSTA,">./$outdir/Temp/pair/PairsStandard.bed";
open CELLDIS,">./$outdir/DIS/DIS.bed";
@pairs=();
while(<PAIR>){
chomp($_);
@temp=split/\t/,$_;
$pair=$temp[4].":".$temp[5]."-".$temp[6]."_".$temp[3];
print PAIRSTA $pair."\n";
@geneinfo=split/\$/,$temp[3];
if($geneinfo[3]<$temp[5]){
$dis=$temp[5]-$geneinfo[3];
}elsif($geneinfo[3]>=$temp[5] && $geneinfo[3]<$temp[6]){
$dis=0;
}elsif($geneinfo[3]>$temp[6]){
$dis=$geneinfo[3]-$temp[6];
}
print CELLDIS $pair."\t".$dis."\n";

}
close PAIR;
close PAIRSTA;
close CELLDIS;
