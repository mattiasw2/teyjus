# Logical Constants and Primitive Goals in Teyjus #

The following constants are recognized by the Teyjus parser as logical constants or primitive goals; the types and interpretations of these symbols are indicated alongside them. Some of the symbols listed are treated as keywords (see the wiki on the [Characterization of Tokens in Teyjus](TeyjusTokens.md)) and so cannot be redefined. Others can be redefined by type declarations in user programs.

```
   true       of type o, representing the true proposition.

   !          of type o, representing the Prolog cut.

   fail       of type o, representing the goal that always fails.

   halt       of type o, representing a goal that terminates interaction.

   stop       of type o, representing a goal that terminates interaction.

   ,          of type o -> o -> o, representing conjunction.
 
   &          of type o -> o -> o, representing conjunction.
 
   ;          of type o -> o -> o, representing disjunction.

   :-         of type o -> o -> o, representing Prolog style implication.

   =>         of type o -> o -> o, representing implication written right.

   sigma      of type (A -> o) -> o, representing existential quantification.

   pi         of type (A -> o) -> o, representing universal quantification.

   not        of type o -> o, representing Prolog-style negation-by-failure.

   =          of type A -> A -> o, representing (Lambda Prolog) equality.
```

The predicates _,_ (comma), _&_, _;_ (semicolon), _:-_ and _=>_ are all actually recognized as infix operators with the following characteristics: comma is left associative with precedence level 110, _&_ is right associative with precedence level 120, semicolon is left associative with precedence level 100, _:-_ is non associative with precedence level 0 and _=>_ is right associative with precedence level 130.