$outdir=$ARGV[0];

open AA,"./$outdir/Temp/pair/PairsStandard.bed";
%hashpair=();
@allpairs=();
while(<AA>){
chomp($_);
if($_ ne ""){
$hashpair{$_}="";
push @allpairs,$_;
}
}
close AA;

open EGC,"./$outdir/EGC/EGC.bed";
while(<EGC>){
chomp($_);
@temp=split/\t/,$_;
if(exists $hashpair{$temp[0]}){
$hashpair{$temp[0]}.="\t".$temp[1];
}else{
$hashpair{$temp[0]}.="\t"."0";
}
}
close EGC;

open GS,"./$outdir/GS/GS.bed";
while(<GS>){
chomp($_);
@temp=split/\t/,$_;
if(exists $hashpair{$temp[0]}){
$hashpair{$temp[0]}.="\t".$temp[1];
}else{
$hashpair{$temp[0]}.="\t"."0";
}
}
close GS;

open DIS,"./$outdir/DIS/DIS.bed";
while(<DIS>){
chomp($_);
@temp=split/\t/,$_;
if(exists $hashpair{$temp[0]}){
$hashpair{$temp[0]}.="\t".$temp[1];
}else{
$hashpair{$temp[0]}.="\t"."0";
}
}
close DIS;

open EWS,"./$outdir/EWS/EWS.bed";
while(<EWS>){
chomp($_);
@temp=split/\t/,$_;
if(exists $hashpair{$temp[0]}){
$hashpair{$temp[0]}.="\t".$temp[1];
}else{
$hashpair{$temp[0]}.="\t"."0";
}
}
close EWS;

open GWS,"./$outdir/GWS/GWS.bed";
while(<GWS>){
chomp($_);
@temp=split/\t/,$_;
if(exists $hashpair{$temp[0]}){
$hashpair{$temp[0]}.="\t".$temp[1];
}else{
$hashpair{$temp[0]}.="\t"."0";
}
}
close GWS;

open WEEC,"./$outdir/WEEC/WEEC.bed";
while(<WEEC>){
chomp($_);
@temp=split/\t/,$_;
if(exists $hashpair{$temp[0]}){
$hashpair{$temp[0]}.="\t".$temp[1];
}else{
$hashpair{$temp[0]}.="\t"."0";
}
}
close WEEC;

mkdir("./$outdir/Temp/res");
open ALL,">./$outdir/Temp/res/pairres.bed";
foreach $pair (@allpairs){
print ALL $pair."\t".$hashpair{$pair}."\n";
}
close ALL;
unlink("./$outdir/cellEnhGeneWindowpre.bed");
unlink("./$outdir/cellEnhGeneWindow.bed");
unlink("./$outdir/cellEnhGeneWindowInEnh.bed");
