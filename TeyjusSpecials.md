# Special Characteristics of the Teyjus Implementation #

Listed below are some special characteristics of the _Teyjus_ system, knowledge of which may be relevant to programming:

  * The present implementation interprets the restrictions on the occurrences of implications and on the antecedents of implication goals in the definition of higher-order hereditary Harrop formulas strictly. In particular, implications cannot appear within arguments of predicates. Further, the antecedent of an implication goal cannot be a flexible atom. The pragmatic reason for this is that the compilation model does not allow for a program clause whose structure is determined at runtime. These restrictions may be eased when interpretation and compilation are integrated in the implementation.

  * The current model takes an interpretive approach towards solving queries. Thus, the query G is actually interpreted as the goal solve G where solve is an internal predicate embodying the treatment of goals whose structure is determined at runtime. A consequence of this treatment is that implication goals at the query level cannot be handled. This restriction will soon be eased by adopting a compilation scheme for top-level queries as well.

  * There is an interaction between cut and disjunctive goals that may not follow the lines of older implementations of Lambda Prolog. Specifically, a cut within a disjunctive branch in Teyjus cuts off choices only within that branch, leaving the choices over disjunctive branches unchanged. Thus, in the goal
```
      G1, !, G2 ; G3; G4
```

> the crossing of the cut removes alternative solution paths only within G1. If there is a failure in solving G2, the disjunctive goal may still be solved by solving G3 or G4.