# Debugging Aids for Teyjus #

The Teyjus system currently does not provide  direct support for debugging.  Fortunately, the ability to write higher-order programs in Lambda Prolog makes it possible for one to quickly build ones own debugging aids that could also be quite powerful. We illustrate two such tools here.

The particular programs that are of interest are defined by the following type declarations and clauses:

```
type announce, spy    o -> o.
type bracket          string -> o -> string -> o.  % Auxiliary

bracket Pre G Post :- print Pre, term_to_string G S, print S, print Post.
announce G :- bracket ">>" G "\n", fail.
spy G :- (bracket ">Entering " G "\n", G, bracket ">Success  " G "\n";
          bracket ">Leaving  " G "\n", fail).
```

These lines can be added to a .mod file containing the code that you wish debug. To be able to use the predicates at the top level, you must, of course, also include the type declarations in the corresponding .sig file.

The announce predicate never succeeds although it does a print.  It can be used to observe each of the invocations of a particular predicate. For example, consider the following modification of the specification of the usual append predicate on lists:

```
append A B C :- announce (append A B C).
append nil K K.
append (X :: L) K (X :: M) :- append L K M.
```

The addition of the first line to the usual definition has the effect of printing each call to append before its actual invocation based on the usual definition. To turn off the printing of this "trace" information, all that needs to be done is  commenting out the first line (and, of course, recompiling and re-loading before execution).

The predicate spy is intended to be used by supplying it as an argument the goal that one actually wants to invoke in a debugging mode. To understand how exactly this works, consider the following clause for the predicate test that essentially encodes a specific invocation of append.

```
test L :- spy (append L [2,3] [1,2,3])).
```

Assume now that this clause and the ones defining append are contained in a module called test that provides the context for solving queries in an activation of tjsim. The following interaction then illustrates the effect of spy.

```
[test] ?- test L.
>Entering append _156 (2 :: 3 :: nil) (1 :: 2 :: 3 :: nil)
>Success  append (1 :: nil) (2 :: 3 :: nil) (1 :: 2 :: 3 :: nil)

The answer substitution:
L = 1 :: nil

More solutions (y/n)? y
>Leaving  append _156 (2 :: 3 :: nil) (1 :: 2 :: 3 :: nil)

no (more) solutions

[test] ?- 
```

Notice that the difference between the printing of the goal before and
after its invocation can show the changes that have taken place in the bindings of logic variables through the invocation. Notice also that backtracking can lead to a string of "successes" before the printing of a "leaving".

The few lines above that define announce, spy and bracket can be inserted directly into any module containing the code you want to debug. Alternatively, they can be placed in a "library" module, identified via suitable .mod and .sig files, and this module can then be accumulated into any context in which the debugging predicates are needed.

Obviously, there can be many variants to the definition and deployment of the two debugging predicates discussed here. In general, the ability to use higher-order predicates supports a flexible approach to debugging of code.