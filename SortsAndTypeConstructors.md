# Builtin sorts and type constructors #

Teyjus embodies an understanding of the following primitive types

```
   int          for integers in an implementation determined range. Teyjus supports
                32 bit integers similar to those provided by the int type in C.

   real         for reals in an implementation determined range. Teyjus supports reals 
                with the same precision and size restrictions as doubles in C.

   string       for the type of strings.

   in_stream    for input streams.

   out_stream   for output streams.

   o            for the type of propositions.
```

Teyjus also supports the following type constructors

```
   list         the unary type constructor for lists.
```