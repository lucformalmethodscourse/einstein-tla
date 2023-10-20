---- MODULE superheroes ----

\* https://www.brainzilla.com/logic/logic-grid/superheroes/

EXTENDS TLC, Integers, FiniteSets

CONSTANTS
  Bryan, Sean, Tony,
  Batperson, Spiderperson, Superperson

VARIABLES kids

Numbers == { 6, 8, 10 }
Heroes == { Batperson, Spiderperson, Superperson }
Kids == { Bryan, Sean, Tony }
Categories == { Kids, Heroes, Numbers }

(*
Bryan likes Spiderperson.
The youngest kid likes Spiderperson.
The kid who likes Superperson is 8.
*)

Facts == {
  { Bryan, Spiderperson },
  { 6, Spiderperson },
  { Superperson, 8 }
}

(*
Tony doesn't like Superperson.
*)

Exclusions == {
  { Tony, Superperson }
}

Init == kids = { { k } : k \in Kids }

Next ==
  \E h \in kids, c \in Categories \ { Kids }: 
    /\ h \intersect c = {}
    /\ \E x \in c \ UNION kids : 
      kids' = (kids \ { h }) \union { h \union { x } }

Spec == Init /\ [][Next]_kids

Solved == 
  /\ Cardinality(kids) = Cardinality(Kids)
  /\ \A k \in kids : Cardinality(k) = Cardinality(Categories)
  /\ \A f \in Facts : \E k \in kids : f \subseteq k
  /\ ~ \E f \in Exclusions, k \in kids : f \subseteq k

Unsolved == ~ Solved
  
====
