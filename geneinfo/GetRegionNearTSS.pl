use List::MoreUtils qw(uniq);
use List::Util qw(min max sum);
$genefile=$ARGV[0];
$species=$ARGV[1];
$outdir=$ARGV[2];

mkdir("./$outdir/Temp/gene");

## define appropriate gene reference file (species)
$genereffile="";
if($species eq "mouse"){
    $genereffile="mouse_ensembl.txt";
}else{
    $genereffile="human_ensembl.txt";
}

## Read in input gene score file (log2FC)
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


open GENE,"./geneinfo/".$genereffile; ## read reference file
open CELLGENE,">./$outdir/Temp/gene/genesigPre.bed"; ## setup temp gene FC file

@genes=();
%hashgenetochr=();
%hashgenetoTSS=();
%hashgenetogenename=();
%hashgenetostrand=();

## Get gene information (chr, start, end, score (logFC)
while(<GENE>){
    chomp($_);
    @temp=split/\t/,$_;
    if(!exists $hashgenetogenename{$temp[0]} && exists $hashcellgeneTosig{$temp[0]} && !($temp[1]=~ /_/)){
	$hashgenetogenename{$temp[0]}=$temp[6];
	print CELLGENE "chr".$temp[1]."\t".$temp[2]."\t".$temp[3]."\t".$hashcellgeneTosig{$temp[0]}."\n";
	push @genes,$temp[0];
	$hashgenetochr{$temp[0]}="chr".$temp[1];
	if($temp[5] eq "1"){
	    $hashgenetoTSS{$temp[0]}=$temp[2];
	    $hashgenetostrand{$temp[0]}="+";
	}elsif($temp[5] eq "-1"){
	    $hashgenetoTSS{$temp[0]}=$temp[3];
	    $hashgenetostrand{$temp[0]}="-";
	}
    }
}
close GENE;
close CELLGENE;

## Sort bed with exact gene information(and remove unsorted)
system("bedtools sort -i ./$outdir/Temp/gene/genesigPre.bed>./$outdir/Temp/gene/genesig.bed");
unlink("./$outdir/Temp/gene/genesigPre.bed");

## Get regions around genes (up to 1e6 around gene)
open GENEREG,">./$outdir/Temp/gene/genesinfopre.bed";
foreach $gene (@genes){
    print GENEREG $hashgenetochr{$gene}."\t".max(1,$hashgenetoTSS{$gene}-1000000)."\t".($hashgenetoTSS{$gene}+1000000)."\t".$gene."\$".$hashgenetogenename{$gene}."\$".$hashgenetochr{$gene}."\$".$hashgenetoTSS{$gene}."\$".$hashgenetostrand{$gene}."\n";
}
close GENEREG;

## Sort bed with tss regions (and remove unsorted)
system("bedtools sort -i ./$outdir/Temp/gene/genesinfopre.bed>./$outdir/Temp/gene/genesinfo.bed");
unlink("./$outdir/Temp/gene/genesinfopre.bed");

