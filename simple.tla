---- MODULE simple ----

EXTENDS Naturals

VARIABLES 
    \* @type: Int; 
    x,
    \* @type: Int; 
    y

Init == 
    /\ x \in 0..100
    /\ y \in 0..100

Next == UNCHANGED << x, y >>

Solved == 
    /\ x + y = 10 
    /\ x - y = 4

Unsolved == ~ Solved

====
