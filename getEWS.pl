use List::MoreUtils qw(uniq);
use List::Util qw(min max sum);
$outdir=$ARGV[0];

mkdir("./$outdir/EWS");
system("bedtools intersect -a ./$outdir/Temp/gene/genesinfo.bed -b ./$outdir/Temp/enhancer/cellenhs.bed -wa -wb>./$outdir/cellEnhGeneSigPre.bed");
open ENHGENE,"./$outdir/cellEnhGeneSigPre.bed";
open WINDOW,">./$outdir/cellEnhGeneWindowpre.bed";
@pairs=();
%hashpairtoLength=();
while(<ENHGENE>){
chomp($_);
@temp=split/\t/,$_;
$pair=$temp[4].":".$temp[5]."-".$temp[6]."_".$temp[3];
push @pairs,$pair;
$TSS=$temp[2]-1000000;
	if($TSS<$temp[5]){
	print WINDOW $temp[4]."\t".$TSS."\t".$temp[5]."\t".$pair."\n";
	$hashpairtoLength{$pair}=$temp[5]-$hashgenetoTSS{$temp[3]};
	$hashpairtoLength{$pair}=$temp[5]-$TSS;
	}elsif($TSS>$temp[6]){
	print WINDOW $temp[4]."\t".$temp[6]."\t".$TSS."\t".$pair."\n";
	$hashpairtoLength{$pair}=$TSS-$temp[6];
	}
}
close ENHGENE;
unlink("./$outdir/cellEnhGeneSigPre.bed");
close WINDOW;
system("bedtools sort -i ./$outdir/cellEnhGeneWindowpre.bed>./$outdir/cellEnhGeneWindow.bed");
system("bedtools intersect -a ./$outdir/cellEnhGeneWindow.bed -b ./$outdir/Temp/enhancer/cellenhs.bed -wa -wb>./$outdir/cellEnhGeneWindowInEnh.bed");
open WINDOWENH,"./$outdir/cellEnhGeneWindowInEnh.bed";
%hashWindowInEnh=();
while(<WINDOWENH>){
chomp($_);
@temp=split/\t/,$_;
if(!exists $hashWindowInEnh{$temp[3]}){
$hashWindowInEnh{$temp[3]}=($temp[6]-$temp[5])*$temp[7];
}else{
$hashWindowInEnh{$temp[3]}+=($temp[6]-$temp[5])*$temp[7];
}
}
close WINDOWENH;

open EWS,">./$outdir/EWS/EWS.bed";
	foreach $pair (@pairs){
		if(!exists $hashWindowInEnh{$pair}){
		$hashWindowInEnh{$pair}=0;
		}
		if(exists $hashpairtoLength{$pair}){
		print EWS $pair."\t".($hashWindowInEnh{$pair}/$hashpairtoLength{$pair})."\n";
		}
	}
close EWS;
