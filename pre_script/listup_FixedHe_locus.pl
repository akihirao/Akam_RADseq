#!/usr/bin/perl
#listup_FixedHe_locus.pl
#2019,2.21

$line = <>;
while ($line = <>) { # 
    chomp $line;      #  末尾の改行コードを削除する．
    ($CHR,$POS,$OBS,$EXP,$ChiSq_HWE,$P_HWE,$P_HET_DEFICIT,$P_HET_EXCESS) = split (/\s+/, $line);
    
    if ($P_HET_EXCESS < 0.05) { 
        print $CHR,"\t", $POS,"\n";
    }
}

