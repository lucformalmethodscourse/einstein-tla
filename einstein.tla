---- MODULE einstein ----

\* IMPORTANT: disable deadlock checking by adding "-deadlock" option

\* https://www.popularmechanics.com/science/math/a24620/riddle-of-the-week-10-einsteins-riddle/

\* Query: Which homeowner has a pet fish?

EXTENDS TLC, Sequences, Integers, FiniteSets

CONSTANTS
  red, green, white, yellow, blue,
  UK, SE, DK, DE, NO,
  tea, coffee, milk, beer, water,
  dog, bird, cat, horse, fish,
  PM, DH, Blend, BM, Prince

VARIABLES houses

TypeOK == TRUE

Numbers == 1 .. 5
Colors == { red, green, white, yellow, blue }
Nationalities == { UK, SE, DK, DE, NO }
Drinks == { tea, coffee, milk, beer, water }
Pets == { dog, bird, cat, horse, fish }
Smokes == { PM, DH, Blend, BM, Prince }
Categories == { Numbers, Colors, Nationalities, Drinks, Pets, Smokes }

(*
The Englishman lives in the house with red walls.
The Swede keeps dogs.
The Dane drinks tea.
The owner of the house with green walls drinks coffee.
The man in the center house drinks milk.
The Norwegian lives in the first house.
The man who smokes Pall Mall keeps birds.
The owner of the house with yellow walls smokes Dunhills.
The man who smokes Blue Masters drinks beer.
The German smokes Prince.
*)

Facts == {
  { NO, 1 },
  { 3, milk },  
  { UK, red },
  { SE, dog },
  { DK, tea },
  { green, coffee },
  { PM, bird },
  { yellow, DH },
  { BM, beer },
  { DE, Prince }
}

\* The house with green walls is just to the left of the house with white walls.

NotGreenLeftOfWhite ==
  { s \in { { { n, green }, { m, white } } : n \in Numbers, m \in Numbers } :
    \E h \in s, k \in s :
      /\ h # k 
      /\ \E n \in h \intersect Numbers, m \in k \intersect Numbers :
        n + 1 # m
  }

(*
The Blend smoker has a neighbor who keeps cats.
The man who keeps horses lives next to the Dunhill smoker.
The Norwegian lives next to the house with blue walls.
The Blend smoker has a neighbor who drinks water.
*)  

Exclusions ==
  NotGreenLeftOfWhite

\* TODO add additional exclusions corresponding to the rules.

Populate ==
  \E h \in houses, c \in Categories : 
    /\ h \intersect c = {}
    /\ \E x \in c \ UNION houses : 
      houses' = (houses \ { h }) \union { h \union { x } }

Init == houses = { { k } : k \in Numbers }

Next == Populate

Spec == Init /\ [][Next]_houses 

Solved == 
  /\ Cardinality(houses) = Cardinality(Numbers)
  /\ \A k \in houses : Cardinality(k) = Cardinality(Categories)
  /\ \A f \in Facts : \E k \in houses : f \subseteq k /\ ~ \E h \in houses \ { k } : f \subseteq h
  /\ ~ \E k \in houses, f \in Exclusions : f \subseteq k

Unsolved == ~ Solved

====
