# Builtin Comparison Predicates #

The following comparison operators are supported by Teyjus.

```
   <        >        =<        >=
```

These operators are overloaded in an ad hoc way. In particular, they each have the type _A -> A -> o_, where _A_ may be instantiated by the types _int_, _real_ and _string_. All these operators are of the infix variety, none is associative and each has the precedence level of 130. The disambiguation rule is the following. If either argument is determined to have a specific type from the set _{int,real,string}_, then this dictates, else the operator is assumed to require integer arguments.