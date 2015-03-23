# Pervasive Constants in Teyjus #

The following symbols are recognized as constants with the associated attributes. Those of these symbols that are not categorized as keywords (see section Characterization of Tokens in Teyjus) can be redefined by the user.

~
> overloaded prefix operator of type (int -> int) or (real -> real). Nonassociative and with higher precedence than everything else except application.

+

> overloaded infix left associative operator with precedence level 150 and type either (int -> int -> int) or (real -> real -> real).

-

> overloaded infix left associative operator with precedence level 150 and type either (int -> int -> int) or (real -> real -> real).

`*`
> overloaded infix left associative operator with precedence level 160 and type either (int -> int -> int) or (real -> real -> real).
abs

> overloaded prefix operator of type (int -> int) or (real -> real).
div

> infix left associative operator with precedence level 160 and type int -> int -> int.
/

> infix left associative operator with precedence level 160 and type real -> real -> real.
mod

> infix left associative operator with precedence level 160 and type int -> int -> int.
int\_to\_real

> of type int -> real.
sqrt

> of type real -> real.
sin

> of type real -> real. Argument is in radians.
cos

> of type real -> real. Argument is in radians.
arctan

> of type real -> real. Result (when evaluation is forced) is in radians.
ln

> of type real -> real.
floor

> of type real -> int.
ceil

> of type real -> int.
truncate

> of type real -> int.
^

> of type string -> string -> string, representing string concatenation.
size

> of type string -> int, representing the length function on strings.
chr

> of type int -> string.
string\_to\_int

> of type string -> int representing the usual ord function on characters (encoded as single character strings).
substring

> of type string -> int -> int -> string. When evaluated, (substring s i j) returns the string of length j that starts at position i (zero indexed) in s; it is a runtime error if i < 0, j < 0 or the length of s is less than i + j.
int\_to\_string

> of type int -> string. When evaluated, the result returned is a string rendition of the integer value of the first argument.
real\_to\_string

> of type real -> string. When evaluated, the result returned is a string rendition of the real value of the first argument.
std\_in

> of type in\_stream, representing the standard input stream
std\_out

> of type out\_stream, representing the standard output stream
std\_err

> of type out\_stream, representing the standard error stream
nil

> of type (list A), representing the (polymorphic) nil list
::

> representing the usual list constructor; infix right associative with precedence level 140 and type (A -> (list A) -> (list A)).