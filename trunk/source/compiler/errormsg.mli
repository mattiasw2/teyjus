(**********************************************************************
*Errormsg Module:
*	In the short run this is used simply to output meaningful error
*	messages with respect to character and line position.  In the long
*	run this will eventually allow for such things as specifying warnings
*	to ignore and the like.
*
*	This has not yet been tested almost at all.
**********************************************************************)
exception InternalError

type pos = Lexing.position

val string_of_pos : pos -> string

val anyErrors : bool ref

val errorsEnabled : bool ref
val warningsEnabled : bool ref
val loggingEnabled : bool ref

val warningsAsErrors : bool ref

val info : string -> string
val log : pos -> string -> unit
val warning : pos -> string -> unit
val error : pos -> string -> unit
val impossible : pos -> string -> 'a   (* raises InternalError *)
val see : pos -> string -> string
val reset : unit -> unit
val none : pos