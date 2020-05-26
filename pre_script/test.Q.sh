#!/bin/bash
#test.Q.sh



ExcessHet_P=0.05
ExcessHet_lab="ExcessHet > "
ExcessHet_Q=`echo "scale=5; -10 * l($ExcessHet_P) /l(10)" |bc -l | xargs printf %.1f`
ExcessHet_param=$ExcessHet_lab$ExcessHet_Q

echo $ExcessHet_param