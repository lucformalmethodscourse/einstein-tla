\*34567890123456789012345678901234567890123456789012

---- MODULE superheroes ----

\* https://www.brainzilla.com/logic/logic-grid/superheroes/

EXTENDS Naturals

CONSTANTS
  Bryan, Sean, Tony,
  Batperson, Spiderperson, Superperson

VARIABLES
  kids,
  heroes

Permutation(S) ==
  { p \in [ 1..3 -> S ] :
    /\ p[2] \in S \ { p[1] }
    /\ p[3] \in S \ { p[1], p[2] }
  }

Ages == << 6, 8, 10 >>
Kids == Permutation({ Bryan, Sean, Tony })
Heroes == Permutation(
  { Batperson, Spiderperson, Superperson })

\* The youngest kid likes Spiderperson.
\* The kid who likes Superperson is 8.

Init ==
  /\ kids \in Kids
  /\ heroes \in { p \in Heroes :
    p[1] = Spiderperson /\ p[2] = Superperson }

Next == UNCHANGED << kids, heroes >>

\* Bryan likes Spiderperson.
\* Tony doesn't like Superperson.

BryanLikesSpider == \E i \in 1..3 :
  kids[i] = Bryan /\ heroes[i] = Spiderperson

TonyDoesntLikeSuper == ~ \E i \in 1..3 :
  kids[i] = Tony /\ heroes[i] = Superperson

Solved ==
  /\ BryanLikesSpider
  /\ TonyDoesntLikeSuper

Unsolved == ~ Solved
  
====
