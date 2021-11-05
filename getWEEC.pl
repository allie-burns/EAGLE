use List::MoreUtils qw(uniq);
use List::Util qw(min max sum);
$outdir=$ARGV[0];

mkdir("./$outdir/WEEC");
open PAIR,"./$outdir/Temp/pair/Pairs.bed";
@pairs=();
%hashpairTOWEEC=();
while(<PAIR>){
    chomp($_);
    @temp=split/\t/,$_;
    $pair=$temp[4].":".$temp[5]."-".$temp[6]."_".$temp[3];
    push @pairs,$pair;
    $hashpairTOWEEC{$pair}="";
}
close PAIR;

open WEECREF,"./$outdir/WEEC/WEECref.bed";
open WEEC,">./$outdir/WEEC/WEEC.bed";
while(<WEECREF>){
    chomp($_);
    @temp=split/\t/,$_;
    if(exists $hashpairTOWEEC{$temp[0]}){
	print WEEC $_."\n";
    }
}
close WEECREF;
close WEEC;

