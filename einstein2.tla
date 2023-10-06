---- MODULE einstein2 ----

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

Positions == 1 .. 5
Colors == { red, green, white, yellow, blue }
Persons == { UK, SE, DK, DE, NO }
Drinks == { tea, coffee, milk, beer, water }
Pets == { dog, bird, cat, horse, fish }
Smokes == { PM, DH, Blend, BM, Prince }

(*
The Englishman lives in the house with red walls.
The Swede keeps dogs.
The Dane drinks tea.
The house with green walls is just to the left of the house with white walls.
The owner of the house with green walls drinks coffee.
The man who smokes Pall Mall keeps birds.
The owner of the house with yellow walls smokes Dunhills.
The man in the center house drinks milk.
The Norwegian lives in the first house.
The German smokes Prince.
The Blend smoker has a neighbor who keeps cats.
The man who smokes Blue Masters drinks beer.
The man who keeps horses lives next to the Dunhill smoker.
The Norwegian lives next to the house with blue walls.
The Blend smoker has a neighbor who drinks water.
*)  

Neighbors(p) == { p - 1, p + 1 } \intersect Positions

SameHouse(i, j) == \E h \in houses : { i, j } \subseteq h

ToLeftOf(i, j) == 
  \E p \in 1 .. 4, h \in houses, k \in houses : { p, i } \subseteq h /\ { p + 1, j } \subseteq k

HasNeighbor(i, j) == 
  \E p \in Positions : \E q \in Neighbors(p), h \in houses, k \in houses : { p, i } \subseteq h /\ { q, j } \subseteq k

Rules == 
  /\ SameHouse(UK, red)
  /\ SameHouse(SE, dog)
  /\ SameHouse(DK, tea)
  /\ ToLeftOf(green, white)
  /\ SameHouse(green, coffee)
  /\ SameHouse(PM, bird)
  /\ SameHouse(yellow, DH)
  /\ SameHouse(3, milk)
  /\ SameHouse(NO, 1)
  /\ SameHouse(DE, Prince)
  /\ HasNeighbor(Blend, cat)
  /\ SameHouse(BM, beer)
  /\ HasNeighbor(horse, DH)
  /\ HasNeighbor(NO, blue)
  /\ HasNeighbor(Blend, water)

EntitiesPlaced == UNION { h : h \in houses }

Init == houses = {}

Next == 
  \E p \in Positions \ EntitiesPlaced,
    c \in Colors \ EntitiesPlaced,
    g \in Persons \ EntitiesPlaced,
    d \in Drinks \ EntitiesPlaced,
    a \in Pets \ EntitiesPlaced,
    s \in Smokes \ EntitiesPlaced :
      houses' = houses \union { { p, c, g, d, a, s } }

Spec == Init /\ [][Next]_houses

Unsolved == ~ Rules

====
