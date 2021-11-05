use List::MoreUtils qw(uniq);
use List::Util qw(min max sum);
use List::MoreUtils qw(uniq);
$OutDir=$ARGV[0];

mkdir("./$OutDir/EGC");
mkdir("./$OutDir/Temp/pair");



## Get overlap between genes(surrounding) and enhancers from input data
system("bedtools intersect -a ./$OutDir/Temp/gene/genesinfo.bed -b ./$OutDir/Temp/enhancer/cellenhs.bed -wa -wb>./$OutDir/Temp/pair/Pairs.bed");

# open CORR,"./AllgenesenhspairsScore.bed";
# %hashpaircorrelation=();

# while(<CORR>){
#     chomp($_);
#     @temp=split/\t/,$_;
#     if($temp[0] ne ""){
# 	$hashpaircorrelation{$temp[0]}=$temp[1];
#     }
# }
# close CORR;

# open PAIR,"./$OutDir/Temp/pair/Pairs.bed";
# open CELLEGC,">./$OutDir/EGC/EGC.bed";
# @pairs=();
# while(<PAIR>){
#     chomp($_);
#     @temp=split/\t/,$_;
#     $pair=$temp[4].":".$temp[5]."-".$temp[6]."_".$temp[3];
#     @genescoreinfo=split/\$/,$temp[3];
#     if(exists $hashpaircorrelation{$pair}){
# 	print CELLEGC $pair."\t".$hashpaircorrelation{$pair}."\n";
#     }else{
# 	print CELLEGC $pair."\t"."-1"."\n";
#     }   
# }

# close PAIR;
# close CELLEGC;

