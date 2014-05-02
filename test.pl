my %hash1;
open IN, "tigr.all.final.iprscan.gene.GO.BinGO" or die "$!";
while(<IN>){
    chomp $_;
    my $line=$_;
    if ($line=~/(Os\w+\.\d+) \=/){
       $hash1{$1}=1;
    }
}
close IN;

my %hash2;
open IN, "all.BiNGO.anno" or die "$!";
while(<IN>){
    chomp $_;
    my $line=$_;
    if ($line=~/LOC\_(Os\w+\.\d+) \=/){
       $hash2{$1}=1;
    }
}
close IN;

foreach my $k1 (keys %hash1){
   if (!exists $hash2{$k1}){
      print "$k1\n";
   }
}

