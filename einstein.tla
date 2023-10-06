---- MODULE einstein ----

\* https://www.popularmechanics.com/science/math/a24620/riddle-of-the-week-10-einsteins-riddle/

\* Query: Which homeowner has a pet fish?

EXTENDS TLC, Sequences, Integers, FiniteSets

CONSTANTS
  null,
  red, green, white, yellow, blue,
  UK, SE, DK, DE, NO,
  tea, coffee, milk, beer, water,
  dog, bird, cat, horse, fish,
  PM, DH, Blend, BM, Prince

VARIABLES houses

TypeOK == TRUE

(*
The man in the center house drinks milk.
The Norwegian lives in the first house.
*)

Colors == { red, green, white, yellow, blue }
Persons == { UK, SE, DK, DE, NO }
Drinks == { tea, coffee, milk, beer, water }
Pets == { dog, bird, cat, horse, fish }
Smokes == { PM, DH, Blend, BM, Prince }
AllEntities == UNION { Colors, Persons, Drinks, Pets, Smokes }

InitHouses == 
  [p \in {2, 4, 5} |-> {}]
  @@ 3 :> { milk }
  @@ 1 :> { NO }

Positions == DOMAIN InitHouses

(*
The Englishman lives in the house with red walls.
The Swede keeps dogs.
The Dane drinks tea.
The owner of the house with green walls drinks coffee.
The man who smokes Pall Mall keeps birds.
The owner of the house with yellow walls smokes Dunhills.
The man who smokes Blue Masters drinks beer.
The German smokes Prince.
*)

Facts(t) ==
  /\ \E p \in Positions : { UK, red } \subseteq t[p]
  /\ \E p \in Positions : { SE, dog } \subseteq t[p]
  /\ \E p \in Positions : { DK, tea } \subseteq t[p]
  /\ \E p \in Positions : { green, coffee } \subseteq t[p]
  /\ \E p \in Positions : { PM, bird } \subseteq t[p]
  /\ \E p \in Positions : { yellow, DH } \subseteq t[p]
  /\ \E p \in Positions : { BM, beer } \subseteq t[p]
  /\ \E p \in Positions : { DE, Prince } \subseteq t[p]

(*
The house with green walls is just to the left of the house with white walls.
The Blend smoker has a neighbor who keeps cats.
The man who keeps horses lives next to the Dunhill smoker.
The Norwegian lives next to the house with blue walls.
The Blend smoker has a neighbor who drinks water.
*)  

Neighbors(p) == { p - 1, p + 1 } \intersect Positions

Rules(t) ==
  /\ \E p \in Positions \ { 5 } : green \in t[p] /\ white \in t[p + 1]
  /\ \E p \in Positions : Blend \in t[p] /\ \E q \in Neighbors(p) : cat \in t[q]
  /\ \E p \in Positions : horse \in t[p] /\ \E q \in Neighbors(p) : DH \in t[q]
  /\ \E p \in Positions : NO \in t[p] /\ \E q \in Neighbors(p) : blue \in t[q]
  /\ \E p \in Positions : Blend \in t[p] /\ \E q \in Neighbors(p) : water \in t[q]

EntitiesPlaced == UNION { houses[p] : p \in Positions }

Init == houses = InitHouses

TryFrom(set) ==
  \E p \in Positions : 
    /\ houses[p] \intersect set = {}
    /\ \E c \in set \ EntitiesPlaced :
      /\ houses' = [houses EXCEPT ![p] = houses[p] \union { c }]

Next == 
  \/ TryFrom(Colors)
  \/ TryFrom(Persons)
  \/ TryFrom(Drinks)
  \/ TryFrom(Pets)
  \/ TryFrom(Smokes)

Spec == Init /\ [][Next]_houses 

Unsolved ==  ~ (EntitiesPlaced # AllEntities => Facts(houses) /\ Rules(houses))

====
