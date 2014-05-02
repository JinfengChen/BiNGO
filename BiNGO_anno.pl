#!/usr/bin/perl
use Getopt::Long;
use File::Basename;
use Data::Dumper;
use FindBin qw($Bin);


GetOptions (\%opt,"ipr:s","type:s","species:s","id:s","col:s","project:s","help");


my $help=<<USAGE;
perl $0 --ipr
--col: collum of GO in file
--id: id that need to output, if not exist in id list, then not output
USAGE


if ($opt{help}){
    print "$help\n";
    exit();
}

$opt{col} ||=9;
$opt{ipr} ||= "/rhome/cjinfeng/BigData/00.RD/seqlib/GFF/MSU7/all.interpro";
$opt{type}||="Biological Process";
$opt{species} ||= "Oryza sativa";
$opt{id} ||="/rhome/cjinfeng/BigData/00.RD/seqlib/GFF/MSU7.gene.anno";
$opt{project} ||="MSU7";

my $id=readid($opt{id});
ipr2BiNGO($opt{ipr},$id);

#model   method  method_acc      method_desc     match_start     match_end       evalue  ipr_acc ipr_desc        ipr_go
#col8=Molecular Function: carboxy-lyase activity (GO:0016831), Biological Process: carboxylic acid metabolic process (GO:0019752)
sub ipr2BiNGO
{
my ($file,$id)=@_;
my %hash;
open OUT, ">$opt{project}.GO.BiNGO" or die "$!";
open OUT1, ">$opt{project}.GO.gene.BiNGO" or die "$!";
print OUT "(species=$opt{species}) (type=$opt{type}) (curator=GO)\n";
print OUT1 "(species=$opt{species}) (type=$opt{type}) (curator=GO)\n";
open IN, "$file" or die "$!";
<IN>;
while(<IN>){
    chomp $_;
    next if ($_=~/^$/);
    my @unit=split("\t",$_);
    if ($unit[$opt{col}]=~/GO/){
       #print "$_\n";
       my @go=split(",",$unit[$opt{col}]);
       for(my $i=0;$i<@go;$i++){
          if ($go[$i]=~/$opt{type}\: .*? \(GO\:(\d+)\)/){
             if (exists $id->{$unit[0]} and !exists $hash{$unit[0]."_".$1}){  ###gene id exists in opt{id} and GO not write for this gene
                 my $gooo=$1;
                 print OUT "$unit[0] = $gooo\n";
                 my $gene=$1 if ($unit[0]=~/(.*?)\.\d+/);
                 print OUT1 "$gene = $gooo\n";    
                 $hash{$unit[0]."_".$gooo}=1;
             } 
          }
       }
    }
}
close IN;
close OUT;
close OUT1;
my $gn=keys %hash;
print "Total gene number with GO $opt{type}: $gn\n";
return \%hash;
}


sub readid
{
my ($file)=@_;
my %hash;
open IN, "$file" or die "$!";
while(<IN>){
    chomp $_;
    next if ($_=~/^$/);
    my @unit=split("\t",$_);
    $hash{$unit[0]}=1;
}
close IN;
return \%hash;
}
 
