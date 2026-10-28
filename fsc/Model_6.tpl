//Number of population samples (demes)
3 populations to simulate
//Population effective sizes (number of genes)
N_POP0
N_POP1
N_POP2
//Sample sizes
74
110
60
//Growth rates
0
0
0
//Number of migration matrices
3
//Migration matrix 0
0 m01 m02
m10 0 m12
m20 m21 0
//Migration matrix 1
0 0 0
0 0 md1
0 md2 0
//Migration matrix 2
0 0 0
0 0 0
0 0 0
//historical event: time, source, sink, migrants, new deme size, growth rate, migr mat index
2 historical event
TDIV_01 0 1 1 N_ANC 0 1 absoluteResize
TDIV_ANC 1 2 1 N_ANC 0 2 absoluteResize
//Number of independent loci [chromosomes]
1 0
//Per chromosome: Number of linkage blocks
1
//per block: Datatype, numm loci, rec rate and mut rate + optional parameters
FREQ 1 0 7.0e-9 OUTEXP

