echo "Total gene number with GO Biological Process: 15143"
perl BiNGO_anno.pl --ipr tigr.all.final.iprscan --col 13

perl BiNGO_anno_TAIR10.pl --ipr TAIR10_all.domains --col 11 --project TAIR10
perl GOlevel_BiNGO.pl --obo ../input/gene_ontology_ext.obo --blast2go ../input/ath.bgo > ../input/ath.bgo.go.level

