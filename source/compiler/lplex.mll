(****************************************************************************
*
****************************************************************************)
{
open Lexing
open Errormsg
open Lpyacc

let set_file_name = fun lexbuf name ->
  lexbuf.lex_curr_p <- { lexbuf.lex_curr_p with pos_fname = name }

let incrline lexbuf =
  lexbuf.lex_curr_p <- {
    lexbuf.lex_curr_p with
      pos_bol = lexbuf.lex_curr_p.pos_cnum ;
      pos_lnum = 1 + lexbuf.lex_curr_p.pos_lnum }

let maxStringLength = 257

let commentLev = ref 0

let strPos = ref 0
let escapePos = ref 0
let strErr = ref false
let quotedid = ref false

let stringBuffer = Buffer.create 16

let string_of_char = String.make 1

(**********************************************************************
*truncateString:
* Issue a warning and truncate string if longer than maxStringLength
**********************************************************************)
let truncateString s pos =
  if String.length s > maxStringLength then
    (Errormsg.warning pos ("Maximum string/id length exceeded; truncating to " ^
                             (string_of_int maxStringLength) ^ " characters") ;
     String.sub s 0 maxStringLength)
  else
    s

(**********************************************************************
* extractCurrentString:
*  Return the current string and reset the string buffer
**********************************************************************)
let extractCurrentString pos =
  let str = Buffer.contents stringBuffer in
  let trim_str = truncateString str pos in
    Buffer.reset stringBuffer ;
    trim_str
      
(**********************************************************************
*addString:
* Add a string to the current string.
**********************************************************************)
let addString s =
  Buffer.add_string stringBuffer s

(**********************************************************************
*addChar:
* Add a character to the current string.
**********************************************************************)
let addChar c =
  Buffer.add_char stringBuffer c

(**********************************************************************
*addHex:
* This *should* convert the given string into a character by interpreting
* it as either 1 or 2 hexadecimal characters.
**********************************************************************)
let addHex s =
  addChar (Char.chr (int_of_string ("0x" ^ s)))

(**********************************************************************
*addOctal:
* This *should* convert the given string into a character by interpreting
* it as either 1 or 3 octal characters.
**********************************************************************)
let addOctal s =
  addChar (Char.chr (int_of_string ("0o" ^ s)))

(**********************************************************************
*addControl:
* This *should* convert the given string into a character control.
**********************************************************************)
let addControl s =
  addChar (Char.chr ((Char.code (String.get s 0)) - (Char.code '@')))
}

let DIGIT = ['0'-'9']
let OCTAL = ['0'-'7']
let HEX = ['0'-'9' 'A'-'F' 'a'-'f']
let SCHAR = ['+' '-' '*' '/' '^' '<' '>' '=' '`' '\'' '?' '@' '#' '$' '&' '!' '_' '~']
let SCHAR1 = ['+' '-' '/' '^' '<' '>' '=' '`' '\'' '?' '@' '#' '$' '&' '!' '_' '~']
let SCHAR2 = ['+' '-' '*' '^' '<' '>' '=' '`' '\'' '?' '@' '#' '$' '&' '!' '~']
let FCHAR = [' ' '\t' '\x0b' '\x0d']
let PCHAR = ['\040' '!'-'&' '(' '[' ']'-'~']
let LCASE = ['a' - 'z']
let UCASE = ['A' - 'Z']
let IDCHAR = (LCASE|UCASE|DIGIT|SCHAR)
let IDCHAR1 = (LCASE|UCASE|DIGIT|SCHAR1)
let WSPACE = [' ' '\t' '\r']+
let NUM = DIGIT+



rule initial = parse
| WSPACE        {initial lexbuf}
| '\n'          {incrline lexbuf; initial lexbuf}

| "module"      {MODULE}
| "end"         {END}
| "import"      {IMPORT}
| "accumulate"  {ACCUMULATE}
| "accum_sig"   {ACCUMSIG}
| "use_sig"     {USESIG}
| "local"       {LOCAL}
| "localkind"   {LOCALKIND}
| "closed"      {CLOSED}
| "sig"         {SIG}
| "kind"        {KIND}
| "type"        {TYPE}
| "typeabbrev"  {TYPEABBREV}
| "exportdef"   {EXPORTDEF}
| "useonly"     {USEONLY}
| "infixl"      {INFIXL}
| "infix"       {INFIX}
| "infixr"      {INFIXR}
| "prefix"      {PREFIX}
| "prefixr"     {PREFIXR}
| "postfix"     {POSTFIX}
| "postfixl"    {POSTFIXL}
| ":-"          {COLONDASH}
| "=>"          {IMPLIES}
| "\\"          {INFIXLAMBDA}
| "->"          {TYARROW}
| "!"           {CUT}

| "pi"          {PI}
| "sigma"       {SIGMA}
| ","           {COMMA}
| ";"           {SEMICOLON}
| "&"           {AMPAND}
| "/"           {RDIVIDE}
| "nil"         {NILLIST}
| "::"          {LISTCONS}
| "="           {EQUAL}

| "+"           {PLUS}
| "-"           {MINUS}
| "*"           {TIMES}
| "<"           {LESS}
| "=<"          {LEQ}
| ">"           {GTR}
| ">="          {GEQ}
| "~"           {UMINUS}

| "."           {PERIOD}
| "("           {LPAREN}
| ")"           {RPAREN}
| "["           {LBRACK}
| "]"           {RBRACK}
| ":"           {COLON}
| "|"           {VBAR}

| (NUM? "." NUM) as num   {REALLIT(float_of_string(num))}
| NUM as num              {INTLIT(int_of_string(num))}

| UCASE IDCHAR* as name       {UPCID(name, Preabsyn.CVID)}
| LCASE IDCHAR* as name       {ID(name, Preabsyn.ConstID)}
| (("/"(IDCHAR1 IDCHAR*))|(SCHAR2 IDCHAR*)) as name {SYID(name, Preabsyn.ConstID)}

| "_" as word         {VID((string_of_char word), Preabsyn.AVID)}
| "_" IDCHAR+ as word {VID(word, Preabsyn.VarID)}

| "\""            {stringstate lexbuf; }

| "%"             {comment1 lexbuf}

| "/*"            {commentLev := 1; comment2 lexbuf}
| _ as c          {raise (Failure("Invalid token: " ^ string_of_char c));}
| eof             {EOF}

(**********************************************************************
*stringstate:
* This state handles reading a quoted string.
**********************************************************************)
and stringstate = parse
| [^ '"' '\\' '\n']+ as text  {addString text; stringstate lexbuf}
| '"'                         {STRLIT(extractCurrentString lexbuf.lex_curr_p)}
      
| '\n'          {Errormsg.error lexbuf.lex_curr_p "Error: String literal ended with newline";
                 incrline lexbuf; STRLIT(extractCurrentString lexbuf.lex_curr_p)}
| "\\b"         {addChar '\b'; stringstate lexbuf}
| "\\t"         {addChar '\t'; stringstate lexbuf}
| "\\n"         {addChar '\n'; stringstate lexbuf}
| "\\r"         {addChar '\r'; stringstate lexbuf}
| "\\\\"        {addChar '\\'; stringstate lexbuf}
| "\\\""        {addChar '"'; stringstate lexbuf}
| "\"\""        {addChar '"'; stringstate lexbuf}

| "\\^"['@'-'z'] as text            {addControl text; stringstate lexbuf}
| "\\" OCTAL as text                {addOctal text; stringstate lexbuf}
| "\\" (OCTAL OCTAL OCTAL) as text  {addOctal text; stringstate lexbuf}
| "\\x" HEX as text                 {addHex text; stringstate lexbuf}
| "\\x" (HEX HEX) as text           {addHex text; stringstate lexbuf}

| "\\x" _         {Errormsg.error lexbuf.lex_curr_p "Error: Illegal hex character specification";
                   stringstate lexbuf}
| "\\" FCHAR      {strflush1 lexbuf}
| "\\\n"          {incrline lexbuf; strflush1 lexbuf}
| "\\c"           {strflush2 lexbuf}
| "\\" _          {Errormsg.error lexbuf.lex_curr_p "Error: Illegal escape character in string";
                   stringstate lexbuf}

and strflush1 = parse
| FCHAR+    {strflush1 lexbuf}
| "\\"      {strflush1 lexbuf}
| _ as text {Errormsg.error lexbuf.lex_curr_p "Error: Unterminated string escape sequence";
             addChar text;
             stringstate lexbuf}

and strflush2 = parse
| FCHAR+    {strflush2 lexbuf}
| _ as text {addChar text; stringstate lexbuf}

and comment1 = parse
| [^ '\n']+       {comment1 lexbuf}
| "\n"            {incrline lexbuf; initial lexbuf}
| _ as text       {Errormsg.error lexbuf.lex_curr_p ("Illegal character " ^ (string_of_char text) ^ " in input");
                   comment1 lexbuf}

and comment2 = parse
| [^ '*' '/' '\n']+   {comment2 lexbuf}
| "/*"        {commentLev := !commentLev + 1; comment2 lexbuf}
| "*/"        {commentLev := !commentLev - 1;
               if !commentLev = 0 then
                 initial lexbuf
               else
                 comment2 lexbuf}
| "/*"        {comment2 lexbuf}
| _ as text   {Errormsg.error lexbuf.lex_curr_p ("Illegal character " ^ (string_of_char text) ^ " in input");
               comment2 lexbuf}