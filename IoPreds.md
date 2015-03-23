# Input/Output and other Side Effecting Predicates in Teyjus #

The following additional predicates are treated as builtin ones in Teyjus. Their interpretation is true for the most part to that in Terzo, the ML based interpreter for Lambda Prolog.

is

> This is the evaluation predicate familiar from Prolog. It is actually defined as an infix, non associative operator with precedence level 130. This predicate is overloaded in an ad hoc way: it can be used at the types int -> int -> o, real -> real -> o and string -> string -> o. The determination of specific type can be delayed to run-time and an illegal usage may result in a run-time type error.

time

> Predicate type: int -> int -> o. Calls the Unix 'gettimeofday' function. Instantiates the first and second arguments to the number of seconds and microseconds respectively, since 00:00 Universal Coordinated Time, Janurary 1, 1970. The arguments must be uninstantiated variables.

> _`[`Not yet implemented`]`_

getenv

> Predicate type: string -> string -> o. Calls the Unix 'getenv' function to return the value of environment variables. The first argument should be instantiated to the name of the environment variable. The second argument will be unified with the value of the variable.

open\_in

> Predicate type: string -> in\_stream -> o. Its first argument must be instantiated to a string literal and its second argument should be an uninstantiated variable. Its effect is to open a file with name given by the string literal as an input stream. It is an error if a file of the relevant name does not exist.

open\_out
open\_append

> Predicate type: string -> out\_stream -> o. Its first argument must be instantiated to a string literal and its second argument should be an unbound variable. Its effect is to open a file with name given by the string literal as an output stream and to set the variable argument to this stream. If a file of the given name does not exist, then a new one is created. If such a file exists, then open\_out initializes this file before it sets it up for writing whereas open\_append begins writing at the end of the file.

open\_string

> Predicate type: string -> in\_stream -> o. Its first argument must be instantiated to a string literal and its second argument must be an unbound variable. Its effect is to bind the variable to a stream containing the text in the string argument.

close\_in

> Predicate type: in\_stream -> o. Its argument must be instantiated to an open input stream. The effect is to close this stream.

close\_out

> Predicate type: out\_stream -> o. Its argument must be instantiated to an open output stream. The effect is to close this stream.

term\_to\_string

> Predicate type: A -> string -> o. A character string representation of the first argument is constructed and is unified with the second argument.

string\_to\_term

> Predicate type: string -> A -> o. The first argument must be instantiated to a string. The effect is to parse the portion of the string up to a period token (that excludes the decimal point) into a term and to try to unify this with the second argument. This predicate may fail because of type disparities as well.

input

> Predicate type: in\_stream -> int -> string -> o. (input strm i str) inputs at most i characters from strm and unifies this with str. This predicate blocks until i characters are available or EOF is reached. The second argument must be instantiated to a non-negative integer and the first to an open in\_stream.

output

> Predicate type: out\_stream -> string -> o. Outputs the string argument to the stream represented by the first argument. Both arguments must be instantiated, the first to an open output stream and the second to a string literal.

input\_line

> Predicate type: in\_stream -> string -> o. The first argument must be instantiated to an open input stream. The predicate blocks till a newline or EOF is present in the input stream, then reads all the characters up to and including the EOF or newline and unifies this with the string argument.

lookahead

> Predicate type: in\_stream -> string -> o. The first argument must be instantiated to an open input stream. The next character in the stream is looked up (but not consumed) and the result is unified with the string argument. The predicate blocks till a character or EOF is available.

eof

> Predicate type: in\_stream -> o. The argument must be instantiated to an open input stream. Succeeds if the end of stream has been reached and fails otherwise.

flush

> Predicate type: out\_stream -> o. The argument must be instantiated to an open output stream. Any buffered output is written out to the stream.

print

> Predicate type: string -> o. This predicate is equivalent to (output std\_out).

read

> Predicate type: A -> o. This predicate reads in the character sequence up to and including a newline or EOF from std\_in, attempts to parse this as a period terminated term, and unifies the result with the argument. Note: This predicate flushes the input beyond the period in the current line.

printterm

> Predicate type: out\_stream -> A -> o. The term constituting the second argument is written out to the out\_stream given by the first argument. The first argument must be instantiated to an open out\_stream.

readterm

> Predicate type: in\_stream -> A -> o. The first argument must be instantiated to an open in\_stream. A period terminated string is read in from the in\_stream, this is parsed as a term and then unified with the second argument. Note: This predicate does not flush the input from the current line even when the input port is std\_in.

open\_socket

> Predicate type: string -> int -> in\_stream -> out\_stream -> o. Establishes a TCP socket. The first argument should be instantiated to a host name such as 'tulip.cs.umn.edu' or an IP address such as '128.101.35.21'. The second argument should be instantiated to the port number of the service. The third and fourth arguments should be uninstantiated variables that will be instantiated respectively to input and output streams associated with the socket. This predicate only works under Unix/Linux platforms.

> _`[`Not yet implemented`]`_

system
> Predicate type: string -> int -> o.  Calls an external program.  The first argument should be instantiated to a command to be executed at the shell.  The second argument should be a variable; it will be bound to the return code of the called program.  This function is a wrapper around the Standard C function of the same name.