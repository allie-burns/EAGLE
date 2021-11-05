$start = time;
use Getopt::Long;
if(@ARGV < 1){
    print "an Enhancer And Gene based Learning Ensembl mothod for prediction of enhancer-gene pairs\n";
    print " Usage:perl EAGLE.pl -E <Enhancer profile> -G <Gene Expression> -S <Species> -O <output_directory>\n";
    print " Example:perl EAGLE.pl -E inputexample/cell_enh.bed -G inputexample/cell_gene.txt -S mouse -O output_dir\n";
    exit;
}

GetOptions('E=s'=>\$Enh, 'G=s'=>\$GeneExpr, 'S=s'=>\$Species, 'O=s'=>\$OutDir);
mkdir("./$OutDir");
mkdir("./$OutDir/Temp");

#Enhancer input normalization
print "-Assigning input enhancer score to known enhancers......\n";	
system("perl ./enhancerinfo/getEnhancer.pl ".$Enh." ".$Species." ".$OutDir);

#get the 100 Mb regions upstream/downstream TSS
print "-Extracting the 100 Mb regions upstream/downstream TSS of the input genes......\n";
system("perl ./geneinfo/GetRegionNearTSS.pl ".$GeneExpr." ".$Species." ".$OutDir);

#get the enhancer-gene correlation(EGC)
print "-Calculating the correlations of input enhancers and genes......\n";
system("perl ./getEGC.pl ".$OutDir);

# #get the feature of gene score(GS)
# print "-Setting the feature: Gene Scores......\n";
# system("perl ./getGS.pl ".$GeneExpr." ".$OutDir);

# #get the feature of distance(DIS)
# print "-Setting the feature: Distances between enhancer and gene......\n";
# system("perl ./getDIS.pl ".$OutDir);

# #get the feature of Enhancer window signal (EWS)
# print "-Setting the feature: Enhancer Window Signals......\n";
# system("perl ./getEWS.pl ".$OutDir);

# #get the feature of Gene window signal (GWS)
# print "-Setting the feature: Gene Window Signals......\n";
# system("perl ./getGWS.pl ".$OutDir);

# #get the feature of Weight of enhancer-enhancer correlations
# print "-Setting the feature: Weights of Enhancer-Enhancer Correlations......\n";
# system("perl ./getWEEC.pl ".$OutDir);

# #combining all features
# print "-Combining all the features......\n";
# system("perl ./combination.pl ".$OutDir);

# # Run Matlab analysis
# print "Running the final predictor......\n";
# if($Species eq "mouse"){
# system("matlab -nosplash -nodesktop -minimize -r predictor_mouse");
# }else{
# system("matlab -nosplash -nodesktop -minimize -r predictor");
# }
# sleep(12);


# # system("rm -rf Temp");

# # ##perl EAGLE.pl -E inputexample/cell_enh.bed -G inputexample/cell_gene.txt -S human
# # ##for mouse:perl EAGLE.pl -E inputexample/mouse_cell_enh.bed -G inputexample/mouse_cell_gene.txt -S mouse
