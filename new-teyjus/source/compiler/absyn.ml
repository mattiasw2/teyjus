(*****************************************************************************
*Absyn:
* The abstract syntax representation.
*****************************************************************************)
type pos = Errormsg.pos
type symbol = Symbol.symbol

(*****************************************************************************
*Kinds:
* (symbol, arity, index, position)
*****************************************************************************)
type akindinfo = (symbol * int option * int ref * pos) 

and akind = 
    LocalKind of akindinfo
  | GlobalKind of akindinfo
  | PervasiveKind of akindinfo

(*****************************************************************************
*Type Variable Data:
* (firstuse, lastuse, perm, safety, heapvar, offset, firstgoal, lastgoal)
*****************************************************************************)
and atypevar = 
  TypeVar of (atype option ref * atype option ref * bool ref * bool ref * 
				bool ref * int option ref * int ref * int ref)


(****************************************************************************
*Type Var Information:
*****************************************************************************)
and atypevarinfo =
	BindableTypeVar of atype option ref
  |	FreeTypeVar of (atypevar option ref * bool option ref)


(*****************************************************************************
*Type:
*****************************************************************************)
and atype = 
    SkeletonVarType of (int ref)
  | TypeVarType of (atypevarinfo ref)
  |	ArrowType of (atype * atype)
  | ApplicationType of (akind * atype list)
  | TypeSetType of (atype * atype list ref * atype option ref)
  | ErrorType

(*****************************************************************************
*Type Skeleton: (type, tyskel table index, adjust)
*****************************************************************************)
and askeleton = Skeleton of (atype * int option ref * bool ref)

(*****************************************************************************
*Type Abbreviations:
*****************************************************************************)
and atypeabbrev =
  TypeAbbrev of (symbol * symbol list * atype * pos)

(****************************************************************************
*Constants:
* Symbol
* Fixity
* Precedence
* Export Def
* Use Only
* No Defs
* Closed
* (Type Preserving)
* Reducible (true for exportdef and anonymous constants or local constants
*            marked as useonly in the imported and accumulated modules)
* Skeleton
* Type Environment Size
* Neededness
* Code Info
* Constant Type
* Index
* Position
***************************************************************************)
and aconstant = 
  Constant of (symbol * afixity ref * int ref * bool ref * bool ref *
	  bool ref * bool ref * bool ref * bool ref * askeleton option ref * 
    int ref * bool array option ref * bool array option ref *
    acodeinfo option ref * aconstanttype ref * int ref * pos)

and aconstanttype =
    GlobalConstant
  | LocalConstant
  | PervasiveConstant of bool (*  Can this constant be redefined? *)
  | HiddenConstant
  | AnonymousConstant

and afixity = 
    Infix
  | Infixl
  | Infixr
  | Prefix
  | Prefixr
  | Postfix
  | Postfixl
  | NoFixity

and acodeinfo = 
    Builtin of int
  | Clauses of aclausesblock

(*****************************************************************************
*Variables (name based):
*   (symbol, hidden constant, newtysy, type)
*****************************************************************************)
and atypesymbolinfo = (symbol * aconstant option ref * bool ref * 
						 atype option ref)
 
and atypesymbol = 
    ImplicitVar of atypesymbolinfo
  | AnonymousImplicitVar of atypesymbolinfo
  | BoundVar of atypesymbolinfo

(*****************************************************************************
*Variables (logic variables):
*   (oneuse, perm, safety, heapvar, offset, firstgoal, lastgoal, lastuse)
*****************************************************************************)
and avar =
  Var of (bool option ref * bool ref * bool ref * bool ref * int option ref * 
			int ref * int ref * aterm option ref)

(*****************************************************************************
*Variable occurrences:
*****************************************************************************)
and afreevarinfo = 
    NamedFreeVar of (atypesymbol)
  | FreeVar of (avar * bool option ref)

and aboundvarinfo =
    NamedBoundVar of (atypesymbol)
  | DBIndex of int
	
(*****************************************************************************
*Strings:
*****************************************************************************)
and astringdata = (string * int option ref * bool option ref)

and astringinfo =
    StringLiteral of (string)
  | StringData of (astringdata)

(*****************************************************************************
*Abstractions:
*****************************************************************************)
and aabstractioninfo =
    NestedAbstraction of (atypesymbol * aterm)
  | UNestedAbstraction of (atypesymbol list * int * aterm)

(*****************************************************************************
*Applications:
*****************************************************************************)
and aapplicationinfo =
    CurriedApplication of (aterm * aterm)
  | FirstOrderApplication of (aterm * aterm list * int)

(*****************************************************************************
*Terms:
*****************************************************************************)
and aterm =
    IntTerm of (int * bool * pos)
  | RealTerm of (float * bool * pos)
  | StringTerm of (astringinfo * bool * pos)
  | ConstantTerm of (aconstant * atype list * bool * pos)
  | FreeVarTerm of (afreevarinfo * bool * pos)
  | BoundVarTerm of (aboundvarinfo * bool * pos)
  | AbstractionTerm of (aabstractioninfo * bool * pos)
  | ApplicationTerm of (aapplicationinfo * bool * pos)
  | ErrorTerm

(*****************************************************************************
*Goals:
*****************************************************************************)
and agoal = 
    AtomicGoal of (aconstant * int * int * aterm list * atype list)
  | AndGoal of (agoal * agoal)
  | ImpGoal of (adefinitions * avarinits * atypevarinits * agoal)
  | AllGoal of (ahcvarassoc * agoal)
  | SomeGoal of (avar * agoal)
  | CutFailGoal 
(*| OrGoal of (agoal * agoal) *)

and adefinitions = Definitions of ((aconstant * aclausesblock) list)
and avarinits = VarInits of (avar list)
and atypevarinits = TypeVarInits of (atypevar list)
and ahcvarassoc = HCVarAssocs of ((avar * aconstant) list)


(****************************************************************************
 *Clauses:
 * (head, args, tyargs, numargs, numtargs, body, offset, varmap, tyvarmap   *
 *gesplist, cutvar, hasenv, impmods)                                      *
 ***************************************************************************)
and aclause = 
    Fact of (aconstant * aterm list * atype list * int * int * 
			   atermvarmap * atypevarmap * avar list * int option ref * 
			   aimportedmodule list)
  | Rule of (aconstant * aterm list * atype list * int * int * atermvarmap *
			   atypevarmap * avar list * int option ref * agoal * 
               agoalenvassoc ref * avar option ref * bool ref * 
			   aimportedmodule list)

(* Goal number and environment size association list*)
and agoalenvassoc =  GoalEnvAssoc of ((int * int) list)

(* term variable map list *)
and atermvarmap  = TermVarMap of ((avar * avar) list)

(* type variable map list *)
and atypevarmap  = TypeVarMap of ((atypevar * atypevar) list)

(* clauses block: (clauses, closed, offset, nextclause)*)
and aclausesblock = (aclause list ref * bool ref * int ref * int option ref)

(*****************************************************************************
*Modules:
* (modname, imported, accumulated, kind table, constant table,
* type abbre table, string list, local kind list, global kind list,
* local constant list, global constant list, hidden constant list,
* skeleton list, hskeleton list, clauses blocks list)
*****************************************************************************)
and amodule = 
    Module of (string * aimportedmodule list * aaccumulatedmodule list *
      aconstant Table.SymbolTable.t ref * akind Table.SymbolTable.t ref *
      atypeabbrev Table.SymbolTable.t * astringinfo list * akind list *
      akind list * aconstant list * aconstant list * aconstant list ref *
      askeleton list * askeleton list * aclauseinfo ref)
  | Signature of (string * akind list * aconstant list)
  | ErrorModule

and aimportedmodule = 
  ImportedModule of (string * amodule)

and aaccumulatedmodule =
  AccumulatedModule of (string * amodule)

and aclauseinfo = 
    ClauseBlocks of aclausesblock list
  | PreClauseBlocks of adefinitions

(*****************************************************************************)
(*Auxiliary functions:                                                       *)
(*****************************************************************************)


(*************************************************************************)
(*  akind:                                                               *)
(*************************************************************************)
let string_of_kind = function
  LocalKind(n,_,_,_) -> (Symbol.name n) 
| GlobalKind(n,_,_,_) -> (Symbol.name n)
| PervasiveKind(n,_,_,_) -> (Symbol.name n)

(* makeKindType                          *)
let makeKindType kind =
  ApplicationType(kind, [])

(* getKindPos:                           *)
(* Get a kind's position information.    *)
let getKindPos = function
  LocalKind(_,_,_,p) -> p
| GlobalKind(_,_,_,p) -> p
| PervasiveKind(_,_,_,p) -> p

(* getKindArity:                         *)
(* Get a kind's arity.                   *)
let getKindArity = function
  LocalKind(_,Some a,_,_) -> a
| GlobalKind(_,Some a,_,_) -> a
| PervasiveKind(_,Some a,_,_) -> a
| k -> (Errormsg.impossible (getKindPos k)  "getKindArity(): invalid kind arity")

(* getKindArityOption:                   *)
let getKindArityOption = function
  LocalKind(_,a,_,_) -> a
| GlobalKind(_,a,_,_) -> a
| PervasiveKind(_,a,_,_) -> a

(* getKindName:                          *)
let getKindName = function
  LocalKind(n,_,_,_) -> (Symbol.name n)
| GlobalKind(n,_,_,_) -> (Symbol.name n)
| PervasiveKind(n,_,_,_) -> (Symbol.name n)

(* getKindSymbol:                          *)
let getKindSymbol = function
  LocalKind(n,_,_,_) ->  n
| GlobalKind(n,_,_,_) -> n
| PervasiveKind(n,_,_,_) -> n

(* getKindIndexRef:                      *)
let getKindIndexRef = function
   LocalKind(_,_,index,_) -> index
|  GlobalKind(_,_,index,_) -> index
|  PervasiveKind(_,_,index,_) -> index
(* getKindIndex:                         *)
let getKindIndex kind = !(getKindIndexRef kind)
(* setKindIndex:                         *)
let setKindIndex kind index = (getKindIndexRef kind) :=  index

(* isGlobalKind:                         *)
let isGlobalKind = function 
   GlobalKind(_) -> true
| _ -> false


let makeGlobalKind symbol arity index =
  (* to check: is this the correct usage of option for arity? *)
  let arityInfo = if (arity = 0) then None else Some arity in
  GlobalKind(symbol, arityInfo, ref index, Errormsg.none)

let makeLocalKind symbol arity index =
  let arityInfo = if (arity = 0) then None else Some arity in
  LocalKind(symbol, arityInfo, ref index, Errormsg.none)

(*************************************************************************)
(*  atypevar:                                                            *)
(*************************************************************************)

(* last goal *)
let getTypeVariableDataLastGoalRef = function
  TypeVar(fu, lu, p, s, h, o, fg, lg) -> lg
let getTypeVariableDataLastGoal v = !(getTypeVariableDataLastGoalRef v)
let setTypeVariableDataLastGoal v o = (getTypeVariableDataLastGoalRef v) := o

(* first goal *)
let getTypeVariableDataFirstGoalRef = function
  TypeVar(fu, lu, p, s, h, o, fg, lg) -> fg
let getTypeVariableDataFirstGoal v = !(getTypeVariableDataFirstGoalRef v)
let setTypeVariableDataFirstGoal v o = (getTypeVariableDataFirstGoalRef v) := o

(* offset     *)
let getTypeVariableDataOffsetRef = function
  TypeVar(fu, lu, p, s, h, o, fg, lg) -> o
let getTypeVariableDataOffset v =
  let r = !(getTypeVariableDataOffsetRef v) in
  if (Option.isSome r) then
    Option.get r
  else
    Errormsg.impossible Errormsg.none "Absyn.getTypeVariableDataOffset: invalid type variable"

let setTypeVariableDataOffset v o =
  (getTypeVariableDataOffsetRef v) := Some o

(* permanent *)
let getTypeVariableDataPermRef = function
  TypeVar(_, _, p, _, _, _, _, _) -> p
let getTypeVariableDataPerm v = !(getTypeVariableDataPermRef v)
let setTypeVariableDataPerm v p = (getTypeVariableDataPermRef v) := p

(* heap var *)
let getTypeVariableDataHeapVarRef = function
  TypeVar(_, _, _, _, h, _, _, _) -> h
let getTypeVariableDataHeapVar v = !(getTypeVariableDataHeapVarRef v)
let setTypeVariableDataHeapVar v h = (getTypeVariableDataHeapVarRef v) := h

(* safety *)
let getTypeVariableDataSafetyRef = function
  TypeVar(_, _, _, s, _, _, _, _) -> s
let getTypeVariableDataSafety v = !(getTypeVariableDataSafetyRef v)
let setTypeVariableDataSafety v s = (getTypeVariableDataSafetyRef v) := s

(* last use *)
let getTypeVariableDataLastUseRef = function
  TypeVar(_, lu, _, _, _, _, _, _) -> lu
let getTypeVariableDataLastUse v = 
  let r = !(getTypeVariableDataLastUseRef v) in
  if Option.isSome r then
    Option.get r
  else
    Errormsg.impossible Errormsg.none "Absyn.getTypeVariableDataLastUse: invalid type variable"


(* first use *)
let getTypeVariableDataFirstUseOpt = function
	TypeVar(fu, _, _, _, _, _, _, _) -> !fu 

let makeNewTypeVariableData () =
  TypeVar(ref None, ref None, ref false, ref false, ref false, ref None, 
	  ref 0, ref 0)

(*************************************************************************)
(*  atype:                                                               *)
(*************************************************************************)
(* dereference a type *)
let rec dereferenceType = fun ty ->
  match ty with
    TypeVarType(r) ->
      (match !r with
        BindableTypeVar(tr) ->
          (match !tr with
            Some(t) -> dereferenceType t
          | None -> ty)
      | FreeTypeVar(_) ->
          Errormsg.impossible Errormsg.none "dereferenceType: Invalid type variable")
  | TypeSetType(_,_,r) ->
      (match !r with
        Some(ty') -> dereferenceType ty'
      | None -> ty)
  | _ -> ty

(* string_of_type                    *)
let rec string_of_type = fun ty ->
  let rec print' = function
      t::[] -> (string_of_type t)
    | t::ts -> (string_of_type t) ^ " " ^ (print' ts)
    | [] -> ""
  in
  let ty' = dereferenceType ty in
  match ty' with
    ArrowType(t1, t2) -> "(" ^ (string_of_type t1) ^ " -> " ^ (string_of_type t2) ^ ")"
  | TypeVarType(r) ->
      let i : int = (Obj.magic r) in
      "'" ^ (string_of_int i)
  | ApplicationType(kind, tlist) ->
      if (List.length tlist) > 0 then
        "(" ^ (string_of_kind kind) ^ " " ^ (print' tlist) ^ ")"
      else
        (string_of_kind kind)
  | SkeletonVarType(i) -> "SkeletonVarType(" ^ (string_of_int !i) ^ ")"
  | TypeSetType(d, tl, _) ->
      (match !tl with
        [t] -> string_of_type t
      | _ -> string_of_type d)
  | ErrorType -> "ErrorType"

(* errorType                         *)
let errorType = ErrorType
let isErrorType t =
  t == errorType


(* arrow type                        *)
let rec getArrowTypeTarget = function
  ArrowType(l, r) -> (getArrowTypeTarget r)
| t -> t

let rec getArrowTypeArguments ty =
  let rec get' = function
    ArrowType(l,r) -> l :: (get' r)
  | t -> []
  in  
  match ty with
    ArrowType(_) -> get' ty
  | t -> Errormsg.impossible Errormsg.none ("getArrowTypeArguments: invalid type: " ^ (string_of_type t))

let isArrowType = function
  ArrowType(_) -> true
| _ -> false

let rec makeArrowType = fun targ args ->
  match args with
    arg::args -> ArrowType(arg, (makeArrowType targ args))
  | [] -> (targ)


(* type set                          *)
let getTypeSetSet = function
  TypeSetType(_, set, _) -> set
| _ -> (Errormsg.impossible Errormsg.none "getTypeSetType: invalid type")

let getTypeSetDefault = function
  TypeSetType(def, _, _) -> def
| _ -> (Errormsg.impossible Errormsg.none "getTypeSetType: invalid type")

let getTypeSetRef = function
  TypeSetType(_,_,r) -> r
| _ -> (Errormsg.impossible Errormsg.none "getTypeSetRef: invalid type")

let isTypeSetType = function
  TypeSetType(_) -> true
| _ -> false

let makeTypeSetVariable def tl = TypeSetType(def, ref tl, ref None)

(* application type (including sort type) *)
let getTypeArguments = function
  ApplicationType(_, args) -> args
| t -> (Errormsg.impossible Errormsg.none ("getTypeArguments: invalid type: " ^ (string_of_type t)))

let getTypeKind = function
  ApplicationType(k,_) -> k
| t -> (Errormsg.impossible Errormsg.none ("getTypeKind: invalid type: " ^ (string_of_type t)))


let isConstantType = function
  ApplicationType(_, args) -> (List.length args) = 0
| _ -> false


(* type reference                   *)
let getTypeVariableReference = function
  TypeVarType(info) ->
    (match !info with
      BindableTypeVar(r) -> r
    | _ -> (Errormsg.impossible Errormsg.none "getTypeVariableReference: invalid type variable info"))
| _ -> (Errormsg.impossible Errormsg.none "getTypeVariableReference: invalid type")

let isVariableType = function
  TypeVarType(r) ->
    (match !r with
      BindableTypeVar(tr) ->
        (match !tr with
          Some(t) -> (Errormsg.impossible Errormsg.none "isVariableType: bound variable")
        | None -> true)
    | _ -> (Errormsg.impossible Errormsg.none "isVariableType: type variable info"))
| _ -> false


(* type variable                    *)
let getTypeFreeVariableVariableData = function
  TypeVarType(r) ->
    (match !r with
      FreeTypeVar(varDataRef, _) -> 
        (match !varDataRef with
           Some(varData) -> varData
         | None -> (Errormsg.impossible Errormsg.none "getTypeFreeVariableVariableData: varData"))
     | _ -> (Errormsg.impossible Errormsg.none "getTypeFreeVariableVariableData: bound variable"))
 |_ -> (Errormsg.impossible Errormsg.none "getTypeFreeVariableVariableData: not a type variable")

let getTypeFreeVariableFirstRef = function
  TypeVarType(r) ->
	(match !r with
	  FreeTypeVar(_, firstRef) -> firstRef
	|  _ -> (Errormsg.impossible Errormsg.none "getTypeFreeVariableFirstRef: bound variable"))
  |_ -> (Errormsg.impossible Errormsg.none "getTypeFreeVariableFirstRef: not a type variable")

let getTypeFreeVariableFirst var = 
  let r = !(getTypeFreeVariableFirstRef var) in
  if Option.isSome r then
    Option.get r
  else
    Errormsg.impossible Errormsg.none "Absyn.getTypeFreeVariableFirst: invalid variable"

let setTypeFreeVariableFirst var first = (getTypeFreeVariableFirstRef var) := Some(first)

let isTypeFreeVariable = function
  TypeVarType(r) ->
    (match !r with
      FreeTypeVar(_) -> true
    | _ -> false)
  | _ -> false

let makeTypeVariable () = TypeVarType(ref (BindableTypeVar(ref None)))
let makeNewTypeVariable varData =
  TypeVarType (ref (FreeTypeVar(ref (Some varData), ref None)))

(* type skeleton variable            *)
let getSkeletonVariableIndex = function
  SkeletonVarType(i) -> !i
| _ -> (Errormsg.impossible Errormsg.none "getSkeletonVariableIndex: invalid type")

let getSkeletonVariableIndexRef = function
  SkeletonVarType(i) -> i
| _ -> (Errormsg.impossible Errormsg.none "getSkeletonVariableIndex: invalid type")

let isSkeletonVariableType = function
  SkeletonVarType(_) -> true
| _ -> false


(* make type environment             *)
let rec makeTypeEnvironment i =
  match i with
      0 -> []
    | i' ->
        if i' < 0 then
          Errormsg.impossible Errormsg.none "Absyn.makeTypeEnvironment: invalid environment size"
        else
          (makeTypeVariable ()) :: (makeTypeEnvironment (i - 1))

let getApplicationTypeHead = function
    ApplicationType(k,_) -> k
  | _ -> Errormsg.impossible Errormsg.none "Absyn.getApplicationTypeHead: invalid type"

let getApplicationTypeArgs = function
    ApplicationType(_,args) -> args
  | _ -> Errormsg.impossible Errormsg.none "Absyn.getApplicationTypeArgs: invalid type"

let isApplicationType t =
  match t with
    ApplicationType(_) -> true
  | _ -> false

(*************************************************************************)
(*  askeleton:                                                           *)
(*************************************************************************)
let getSkeletonType = function
  Skeleton(f,_,_) -> f

let makeSkeleton ty =
  Skeleton(ty, ref None, ref true)

let getSkeletonIndex = function
  Skeleton(_,i,_) ->
    match !i with
      Some i' -> i'
    | None -> (Errormsg.impossible Errormsg.none
                "getSkeletonIndex: Skeleton has no index")

let setSkeletonIndex skeleton index =
  let Skeleton(_,i,_) = skeleton in
  i := Some(index)
 
let getSkeletonNew = function
  Skeleton(_,_,n) -> !n

let setSkeletonNew skeleton isNew =
  let Skeleton(_,_,n) = skeleton in
  n := isNew


(*************************************************************************)
(*  afixity:                                                             *)
(*************************************************************************)
(* * Convert an absyn fixity to a string.  Used only in print *)
let string_of_fixity = function
  Infix -> "Infix"
| Infixl -> "Infixl"
| Infixr -> "Infixr"
| Prefix -> "Prefix"
| Prefixr -> "Prefixr"
| Postfix -> "Postfix"
| Postfixl -> "Postfixl"
| NoFixity -> "No Fixity"

let isFixityPrefix = function
  Prefix -> true
| Prefixr -> true
| _ -> false

let isFixityPostfix = function
  Postfix -> true
| Postfixl -> true
| _ -> false

(*************************************************************************)
(*  aconstant:                                                           *)
(*************************************************************************)
let string_of_constant = function
  Constant(s,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_) ->
    Symbol.name s

let getConstantPos = function
  Constant(_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,p) ->
    p

let getConstantFixityRef = function
  Constant(_,fix,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_) ->
    fix
    
let getConstantFixity = function
  Constant(_,fix,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_) ->
    !fix

let getConstantPrec = function
  Constant(_,_,prec,_,_,_,_,_,_,_,_,_,_,_,_,_,_) ->
    !prec

let getConstantPrecRef = function
  Constant(_,_,prec,_,_,_,_,_,_,_,_,_,_,_,_,_,_) ->
    prec

let getConstantSymbol = function
  Constant(sym,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_) -> sym

let getConstantReducible = function
  Constant(_,_,_,_,_,_,_,_,r,_,_,_,_,_,_,_,_) ->
    !r

let getConstantSkeleton = function
  Constant(_,_,_,_,_,_,_,_,_,s,_,_,_,_,_,_,_) ->
    !s

let getConstantSkeletonValue = function 
  Constant(_,_,_,_,_,_,_,_,_,s,_,_,_,_,_,_,_) ->
    if Option.isSome (!s) then
      Option.get (!s)
    else
      Errormsg.impossible Errormsg.none "Absyn.getConstantSkeletonValue: invalid skeleton"


let getConstantSkeletonRef = function
  Constant(_,_,_,_,_,_,_,_,_,s,_,_,_,_,_,_,_) ->
    s

let getConstantName = fun c ->
  (Symbol.name (getConstantSymbol c))

let getConstantType = function
  Constant(_,_,_,_,_,_,_,_,_,_,_,_,_,_,ctype,_,_) ->
    !ctype

let getConstantTypeRef = function
  Constant(_,_,_,_,_,_,_,_,_,_,_,_,_,_,ctype,_,_) ->
    ctype

let isGlobalConstant c = 
  (getConstantType c) = GlobalConstant

let getConstantCodeInfo = function
  Constant(_,_,_,_,_,_,_,_,_,_,_,_,_,ci,_,_,_) ->
    ci

let setConstantCodeInfo c codeInfo = (getConstantCodeInfo c) := codeInfo

let getConstantCodeInfoBuiltinIndex = function
  Constant(_,_,_,_,_,_,_,_,_,_,_,_,_,ci,_,_,_) ->
   match (!ci) with
     Some(Builtin(index)) -> index
   | Some(_) -> 
      (Errormsg.impossible Errormsg.none
         "getConstantCodeInfoBuiltinIndex: not a builtin pred")
   | None -> 
      (Errormsg.impossible Errormsg.none
         "getConstantCodeInfoBuiltinIndex: no definition")      

(* retrieve the offset field in the clausesBlock of the pred *)
let getConstantCodeInfoClausesIndex = function
  Constant(_,_,_,_,_,_,_,_,_,_,_,_,_,ci,_,_,_) ->
   match (!ci) with
     Some(Clauses(_,_,offset,_)) -> !offset
   | Some(_) -> 
      (Errormsg.impossible Errormsg.none
         "getConstantCodeInfoClausesIndex: builtin pred")
   | None -> 
      (Errormsg.impossible Errormsg.none
         "getConstantCodeInfoClausesIndex: no definition")   

let constantHasCode = function
  Constant(_,_,_,_,_,_,_,_,_,_,_,_,_,ci,_,_,_) ->
   match (!ci) with
     Some(_) -> true
   | None -> false

let getConstantTypeEnvSize = function
  Constant(_,_,_,_,_,_,_,_,_,_,s,_,_,_,_,_,_) ->
    !s

let getConstantTypeEnvSizeRef = function
  Constant(_,_,_,_,_,_,_,_,_,_,s,_,_,_,_,_,_) ->
    s

let getConstantSkeletonNeededness = function
  Constant(_,_,_,_,_,_,_,_,_,_,_,n,_,_,_,_,_) ->
    !n

let getConstantSkeletonNeedednessRef = function
  Constant(_,_,_,_,_,_,_,_,_,_,_,n,_,_,_,_,_) ->
    n

let getConstantNeededness = function
  Constant(_,_,_,_,_,_,_,_,_,_,_,_,n,_,_,_,_) ->
    !n

let getConstantNeedednessRef = function
  Constant(_,_,_,_,_,_,_,_,_,_,_,_,n,_,_,_,_) ->
    n

let getConstantNeedednessValue = function
  Constant(_,_,_,_,_,_,_,_,_,_,_,_,n,_,_,_,_) ->
    if Option.isSome (!n) then
      Option.get (!n)
    else
      Errormsg.impossible Errormsg.none "Absyn.getConstantNeedednessValue: invalid neededness"

let getConstantNoDefs = function
  Constant(_,_,_,_,_,nd,_,_,_,_,_,_,_,_,_,_,_) ->
    !nd

let getConstantNoDefsRef = function
  Constant(_,_,_,_,_,nd,_,_,_,_,_,_,_,_,_,_,_) ->
    nd

let getConstantClosed = function
  Constant(_,_,_,_,_,_,c,_,_,_,_,_,_,_,_,_,_) ->
    !c

let getConstantClosedRef = function
  Constant(_,_,_,_,_,_,c,_,_,_,_,_,_,_,_,_,_) ->
    c

let getConstantUseOnly = function
  Constant(_,_,_,_,u,_,_,_,_,_,_,_,_,_,_,_,_) ->
    !u

let getConstantUseOnlyRef = function
  Constant(_,_,_,_,u,_,_,_,_,_,_,_,_,_,_,_,_) ->
    u

let getConstantExportDef = function
  Constant(_,_,_,e,_,_,_,_,_,_,_,_,_,_,_,_,_) ->
    !e

let getConstantExportDefRef = function
  Constant(_,_,_,e,_,_,_,_,_,_,_,_,_,_,_,_,_) ->
    e
  
let getConstantIndex = function
  Constant(_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,i,_) ->
    !i

let setConstantIndex c index =
  let Constant(_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,i,_) = c in
  i := index 

let getConstantRedefinable c =
  let t = getConstantType c in
  match t with
      PervasiveConstant(b) -> b
    | _ -> false

let makeGlobalConstant symbol fixity prec expDef useOnly tyEnvSize tySkel index =
  Constant(symbol, ref fixity, ref prec, ref expDef, ref useOnly, ref false,
		   ref true, ref false, ref false, ref (Some tySkel), ref tyEnvSize,
		   ref None, ref None, ref None, ref GlobalConstant, ref index, 
		   Errormsg.none)

let makeLocalConstant symbol fixity prec tyEnvSize tySkel index =
  Constant(symbol, ref fixity, ref prec, ref false, ref false, ref false,
		   ref true, ref false, ref false, ref (Some tySkel), ref tyEnvSize,
		   ref None, ref None, ref None, ref LocalConstant, ref index, 
		   Errormsg.none)

let makeAnonymousConstant i =
  Constant(Symbol.generate (), ref NoFixity, ref (-1), ref true, ref false,
    ref false, ref true, ref false, ref false, ref None, ref i,
    ref None, ref None, ref None, ref AnonymousConstant, ref 0, Errormsg.none)

let makeHiddenConstant skel =
  Constant(Symbol.symbol "", ref NoFixity, ref (-1), ref true, ref false,
    ref false, ref true, ref false, ref false, ref (Some skel), ref 0,
    ref None, ref None, ref None, ref HiddenConstant, ref 0, Errormsg.none)

let makeConstantTerm c env pos =
  let esize = getConstantTypeEnvSize c in
  if esize = (List.length env) then
    ConstantTerm(c, env, false, pos)
  else
    Errormsg.impossible (getConstantPos c)
      "makeConstantTerm: constant environment size and given environment don't match"

(*************************************************************************)
(*  atypesymbol:                                                         *)
(*************************************************************************)
let getTypeSymbolRawType = fun s ->
  let get' = function
      Some(t) -> t
    | _ -> Errormsg.impossible Errormsg.none "getTypeSymbolRawType: type symbol has no type"
  in
  
  match s with
    ImplicitVar(_,_,_,t) -> get' !t
  | AnonymousImplicitVar(_,_,_,t) -> get' !t
  | BoundVar(_,_,_,t) -> get' !t

let getTypeSymbolSymbol = function
    ImplicitVar(s,_,_,_) -> s
  | AnonymousImplicitVar(s,_,_,_) -> s
  | BoundVar(s,_,_,_) -> s

let getTypeSymbolName s = (Symbol.name (getTypeSymbolSymbol s))

let getTypeSymbolHiddenConstantRef tsym =
  match tsym with
    ImplicitVar(_,c,_,_) -> c
  | AnonymousImplicitVar(_,c,_,_) -> c
  | BoundVar(_,c,_,_) -> c

let getTypeSymbolHiddenConstant tsym =
  let get' = function
      Some(c) -> c
    | None -> Errormsg.impossible Errormsg.none "getTypeSymbolHiddenConstant: type symbol has no constant"
  in  
  get' !(getTypeSymbolHiddenConstantRef tsym)


let getTypeSymbolType ty =
  let get' t =
    if Option.isSome t then
      Option.get t
    else
      Errormsg.impossible Errormsg.none "getTypeSymbolType: invalid type"
  in
  match ty with
    ImplicitVar(_,_,_,t) -> get' !t
  | AnonymousImplicitVar(_,_,_,t) -> get' !t
  | BoundVar(_,_,_,t) -> get' !t

(*************************************************************************)
(*  avar:                                                                *)
(*************************************************************************)
let getVariableDataPerm = function
  Var(_,p,_,_,_,_,_,_) -> !p

let setVariableDataPerm v perm =
  match v with
	Var(_,p,_,_,_,_,_,_) -> p := perm

let getVariableDataLastUse = function
  Var(_,_,_,_,_,_,_,lu) ->
    if Option.isSome (!lu) then
      Option.get (!lu)
    else
      Errormsg.impossible Errormsg.none "Absyn.getVariableDataLastUse: invalid variable"

let setVariableDataLastUse v u =
  match v with
	Var(_,_,_,_,_,_,_,lu) -> lu := Some u

let setVariableDataOneUse v o =
  match v with
	Var(oneuse,_,_,_,_,_,_,_) -> oneuse := Some o

let getVariableDataHeapVar = function
  Var(_,_,_,h,_,_,_,_) -> !h

let setVariableDataHeapVar varData heapVar =
  let Var(_,_,_,h,_,_,_,_) = varData in
  h := heapVar 
   
let getVariableDataSafety = function
  Var(_,_,s,_,_,_,_,_) -> !s

let setVariableDataSafety varData safety =
  let Var(_,_,s,_,_,_,_,_) = varData in
  s := safety 

let getVariableDataFirstGoalRef = function
 Var(_,_,_,_,_,f,_,_) -> f
let getVariableDataFirstGoal v = !(getVariableDataFirstGoalRef v)
let setVariableDataFirstGoal v o =
  (getVariableDataFirstGoalRef v) := o

let getVariableDataLastGoalRef = function
  Var(oneuse, perm, safety, heapvar, offset, firstgoal, lastgoal, lastuse) ->
    lastgoal
let getVariableDataLastGoal v = !(getVariableDataLastGoalRef v)
let setVariableDataLastGoal v o = (getVariableDataLastGoalRef v) := o

let getVariableDataOffsetRef = function
  Var(oneuse, perm, safety, heapvar, offset, firstgoal, lastgoal, lastuse) ->
    offset
let getVariableDataOffset v =
  let r = !(getVariableDataOffsetRef v) in
  if Option.isSome (r) then
      Option.get (r)
  else
    Errormsg.impossible Errormsg.none "Absyn.getVariableDataOffset: invalid variable"

let setVariableDataOffset v o =
  (getVariableDataOffsetRef v) := Some o

let makeNewVariableData () =
  Var(ref None, ref false, ref false, ref false, ref None, ref 0, ref 0,
      ref None)

let makeCutVariableData gnum =
  Var(ref None, ref true, ref false, ref false, ref None, ref gnum, 
	  ref gnum, ref None)
(*************************************************************************)
(*  aterm:                                                               *)
(*************************************************************************)
let maxPrec = 255
let appFixity = Infixl
let appPrec = maxPrec + 2

let errorTerm = ErrorTerm

(**********************************************************************
*Term Context:
* Keeps track of what state the converter is in when going from
* a term to a string.
**********************************************************************)
type atermcontext =
  LeftTermContext
| RightTermContext
| WholeTermContext

(**********************************************************************
*needsParens:
* Determins whether or not to output parentheses based on the current
* operator precedence and fixity.
**********************************************************************)
let rec needsParens = fun opfix opprec context fix prec ->
  let checkLE = fun () -> opprec <= prec in
  let checkL = fun () -> opprec < prec in
  let checkLeft = fun () ->
    match opfix with
      Infix -> checkL ()
    | Infixl -> checkL ()
    | Prefix -> checkL ()
    | Postfix -> checkL ()
    | Postfixl -> checkL ()
    | _ -> checkLE ()
  in
  
  let checkRight = fun () ->
    match opfix with
      Infixl -> checkLE ()
    | Postfixl -> checkLE ()
    | _ -> checkL ()
  in
  
  match context with
    LeftTermContext ->
      (match fix with
        Infix -> checkLE ()
      | Infixr -> checkLE ()
      | Postfix -> checkLE ()
      
      | Infixl -> checkLeft ()
      | Postfixl -> checkLeft ()
      | _ -> (Errormsg.impossible Errormsg.none "needsParens: invalid fixity"))

  | RightTermContext ->
      (match fix with
        Infix -> checkLE ()
      | Infixl -> checkLE ()
      | Prefix -> checkLE ()
      
      | Infixr -> checkRight ()
      | Prefixr -> checkRight ()
      | _ -> (Errormsg.impossible Errormsg.none "needsParens: invalid fixity"))
  | WholeTermContext -> false

(* Converts an absyn term to a string representation. *)
let rec string_of_term_ast term =
  match term with
    IntTerm(i,_,_) -> string_of_int i
  | RealTerm(r,_,_) -> string_of_float r
  | StringTerm(StringLiteral(s),_,_) -> "\"" ^ (s) ^ "\""
  | StringTerm(StringData(s,_,_),_,_) -> "\"" ^ (s) ^ "\""
  | ConstantTerm(c,_,_,_) -> getConstantName c
  | FreeVarTerm(NamedFreeVar(s),_,_) -> Symbol.name (getTypeSymbolSymbol s)
  | BoundVarTerm(NamedBoundVar(s),_,_) -> Symbol.name (getTypeSymbolSymbol s)
  | AbstractionTerm(ai,_,_) -> "#ERROR#"
  | ApplicationTerm(FirstOrderApplication(h,args,_),_,_) ->
      let rec getargs = function
          [] -> ""
        | a::aa -> " " ^ (string_of_term_ast a) ^ (getargs aa)
      in
      
      "(" ^ (string_of_term_ast h) ^ (getargs args) ^ ")"
  | ApplicationTerm(CurriedApplication(l,r),_,_) ->
      "(" ^ (string_of_term_ast l) ^ " " ^ (string_of_term_ast r) ^ ")"
  | _ -> "#ERROR#"
  

and string_of_term term =
  let rec string_of_prefixterm = fun op opfix args context fix prec ->
    let opprec = getConstantPrec op in
    let paren = needsParens opfix opprec context fix prec in
    let result = (getConstantName op) ^ " " ^ (string_of_term' (List.hd args) RightTermContext opfix opprec) in

    if paren then
      "(" ^ result ^ ")"
    else
      result
  
  and string_of_infixterm = fun op opfix args context fix prec ->
    let opprec = getConstantPrec op in
    let paren = needsParens opfix opprec context fix prec in
    let result = (string_of_term' (List.hd args) LeftTermContext opfix opprec) ^ 
      " " ^ (getConstantName op) ^ " " ^
      (string_of_term' (List.hd (List.tl args)) RightTermContext opfix opprec) in
    
    if paren then
      "(" ^ result ^ ")"
    else
      result
  
  and string_of_postfixterm = fun op opfix args context fix prec ->
    let opprec = getConstantPrec op in
    let paren = needsParens opfix opprec context fix prec in
    let result = (string_of_term' (List.hd args) LeftTermContext opfix opprec) ^ " " ^ (getConstantName op) in
    
    if paren then
      "(" ^ result ^ ")"
    else
      result
  
  and string_of_app = fun term context fix prec ->
    let rec string_of_args args =
      match args with
          [] -> ""
        | a::[] -> (string_of_term' a WholeTermContext appFixity appPrec)
        | a::aa -> (string_of_term' a WholeTermContext appFixity appPrec) ^ " " ^ (string_of_args aa)
    in
    
    match term with
      ApplicationTerm(FirstOrderApplication(f, args, numargs),_,_) ->
        let string_of_head h =
          (match h with
            ConstantTerm(c,_,_,_) ->
              (match (getConstantFixity c) with
                  Prefix -> 
                    if numargs = 1 then
                      (string_of_prefixterm c Prefix args context fix prec,
                      [])
                    else
                      (string_of_prefixterm c Prefix args LeftTermContext appFixity appPrec,
                      List.tl args)
                | Prefixr ->
                    if numargs = 1 then
                      (string_of_prefixterm c Prefix args context fix prec,
                      [])
                    else
                      (string_of_prefixterm c Prefix args LeftTermContext appFixity appPrec,
                      List.tl args)
                | Infix ->
                    if numargs = 2 then
                      (string_of_infixterm c Infix args context fix prec,
                      [])
                    else
                      (string_of_infixterm c Infix args LeftTermContext appFixity appPrec,
                      List.tl (List.tl args))
                | Infixr ->
                    if numargs = 2 then
                      (string_of_infixterm c Infixr args context fix prec,
                      [])
                    else
                      (string_of_infixterm c Infixr args LeftTermContext appFixity appPrec,
                      List.tl (List.tl args))
                | Infixl ->
                    if numargs = 2 then
                      (string_of_infixterm c Infixl args context fix prec,
                      [])
                    else
                      (string_of_infixterm c Infixl args LeftTermContext appFixity appPrec,
                      List.tl (List.tl args))
                | Postfix ->
                    if numargs = 1 then
                      (string_of_postfixterm c Postfix args context fix prec,
                      [])
                    else
                      (string_of_postfixterm c Postfix args LeftTermContext appFixity appPrec,
                      List.tl args)
                | Postfixl ->
                    if numargs = 1 then
                      (string_of_postfixterm c Postfixl args context fix prec,
                      [])
                    else
                      (string_of_postfixterm c Postfixl args LeftTermContext appFixity appPrec,
                      List.tl args)
                | NoFixity ->
                    (string_of_term' f LeftTermContext appFixity appPrec,
                    args))
            | _ ->
              (string_of_term' f LeftTermContext appFixity appPrec,
              args))
          in
        
        let paren = needsParens appFixity appPrec context fix prec in        
        let (head, args') = (string_of_head f) in
        
        if paren && (List.length args' > 0) then
          "(" ^ head ^ " " ^ (string_of_args args') ^ ")"
        else if (List.length args' > 0) then
          (head ^ " " ^ (string_of_args args'))
        else
          head
    | ApplicationTerm(CurriedApplication(l, r),_,_) ->
        let paren = needsParens appFixity appPrec context fix prec in
        let result = (string_of_term' l LeftTermContext appFixity appPrec) ^ " " ^ (string_of_term' r RightTermContext appFixity appPrec) in
        if paren then
          "(" ^ result ^ ")"
        else
          result
    | _ -> Errormsg.impossible (getTermPos term) "string_of_app: term not an application"

  and string_of_abstraction = fun term context fix prec ->
    "error"
  
  and string_of_term' = fun term context fix prec ->
    match term with
      IntTerm(i,_,_) -> (string_of_int i)
    | RealTerm(r,_,_) -> (string_of_float r)
    | StringTerm(StringLiteral(s),_,_) -> "\"" ^ s ^ "\""
    | StringTerm(StringData(s,_,_),_,_) -> "\"" ^ s ^ "\""
    | ConstantTerm(c,_,_,_) -> (getConstantName c)
    | FreeVarTerm(NamedFreeVar(s),_,_) -> Symbol.name (getTypeSymbolSymbol s)
    | BoundVarTerm(NamedBoundVar(s),_,_) -> Symbol.name (getTypeSymbolSymbol s)
    | ApplicationTerm(_) -> string_of_app term context fix prec
    | AbstractionTerm(_) -> string_of_abstraction term context fix prec
    | ErrorTerm -> "#error#"
    | _ -> Errormsg.impossible (getTermPos term) "string_of_term': unimplemented for this term"
  in
  
  (string_of_term' term WholeTermContext NoFixity 0)

and getTermPos = function
  IntTerm(_,_,p) -> p
| StringTerm(_,_,p) -> p
| RealTerm(_,_,p) -> p
| AbstractionTerm(_,_,p) -> p
| ConstantTerm(_,_,_,p) -> p
| FreeVarTerm(_,_,p) -> p
| BoundVarTerm(_,_,p) -> p
| ApplicationTerm(_,_,p) -> p
| ErrorTerm -> Errormsg.none

(* free variable *)
let getTermFreeVariableVariableData = function
  FreeVarTerm(FreeVar(varData, _),_,_) -> varData
| _ -> Errormsg.impossible Errormsg.none 
        "getTermFreeVariableVariableData: invalid term"

let getTermFreeVariableFirst = function
  FreeVarTerm(FreeVar(_, first),_,_) ->
    if Option.isSome !first then
      Option.get (!first)
    else
      Errormsg.impossible Errormsg.none 
        "getTermFreeVariablFirst: invalid term free variable"
| _ -> Errormsg.impossible Errormsg.none 
        "getTermFreeVariablFirst: invalid term"

let setTermFreeVariableFirst var f = 
  match var with
	FreeVarTerm(FreeVar(_, first),_,_) -> first := Some(f)
  | _ -> Errormsg.impossible Errormsg.none 
        "getTermFreeVariablFirst: invalid term"	

let getTermFreeVariableTypeSymbol = function
  FreeVarTerm(NamedFreeVar(tySymbol),_, _) -> tySymbol
| _ -> Errormsg.impossible Errormsg.none
	    "getTernFreeVariableTypeSymbol: invalid term"


let isTermFreeVariable = function
  FreeVarTerm(_) -> true
| _ -> false

(* make a name based free variable *)
let makeFreeVarTerm tsym pos =
  FreeVarTerm(NamedFreeVar(tsym), false, pos)

let getTermBoundVariableDBIndex = function
  BoundVarTerm(DBIndex(ind),_,_) -> ind
| _ -> Errormsg.impossible Errormsg.none 
        "getTermBoundVariableDBIndex: invalid term"

(* make a name based bound variable *)
let makeBoundVarTerm tsym pos =
  BoundVarTerm(NamedBoundVar(tsym), false, pos)

(* constant *)
let getTermConstant = function
  ConstantTerm(c,_,_,_) -> c
| t -> Errormsg.impossible Errormsg.none ("Absyn.getTermConstant: invalid term: " ^ (string_of_term t))

let getTermTypeEnv = function
  ConstantTerm(_,te,_,_) -> te
| t -> Errormsg.impossible Errormsg.none ("Absyn.getTermTypeEnv: invalid term" ^ (string_of_term t))

let getTermConstantTypeEnv = function
  ConstantTerm(_,te,_,_) -> te
| _ -> Errormsg.impossible Errormsg.none 
         "getTermConstantTypeEnv: invalid term"  

let isTermConstant = function
  ConstantTerm(_) -> true
| _ -> false

(* abstraction term *)
let getTermAbstractionVar = function
  AbstractionTerm(NestedAbstraction(v,_),_,_) -> v
| _ -> Errormsg.impossible Errormsg.none "getTermAbstractionVar: invalid term"

let getTermAbstractionVars = function
  AbstractionTerm(UNestedAbstraction(vars,_,_),_,_) -> vars
| _ -> Errormsg.impossible Errormsg.none "getTermAbstractionVars: invalid term"

let getTermAbstractionBody = function
  AbstractionTerm(NestedAbstraction(_,b),_,_) -> b
| AbstractionTerm(UNestedAbstraction(_,_,b),_,_) -> b
| _ -> Errormsg.impossible Errormsg.none "getTermAbstractionBody: invalid term"

let getTermAbstractionNumberOfLambda = function
  AbstractionTerm(UNestedAbstraction(_,n,_),_,_) -> n
| _ -> Errormsg.impossible Errormsg.none 
         "getTermAbstractionNumberOfLambda: invalid term"

(* application term *)
(********************************************************************
*getTermApplicationHeadAndArguments:
* Gets the clause head and arguments, flattening an applications at
* the head.
********************************************************************)
let rec getTermApplicationHeadAndArguments term =  
  match term with
    ApplicationTerm(FirstOrderApplication(t', args, _), _, pos) ->
      let (head, args') = getTermApplicationHeadAndArguments t' in
      (head, args' @ args)
  | ApplicationTerm(CurriedApplication(l,r),_,pos) ->
      let (head, args') = getTermApplicationHeadAndArguments l in
      (head, args' @ [r])
  | _ -> (term, [])

let rec getTermApplicationHead t =
  let (f,_) = getTermApplicationHeadAndArguments t in
  f

let rec getTermApplicationArguments t =
  let (_,args) = getTermApplicationHeadAndArguments t in
  args
 
let getTermApplicationArity t = 
  let (_,args) = getTermApplicationHeadAndArguments t in
  List.length args

(*************************************************************************)
(*  astringinfo:                                                         *)
(*************************************************************************)
let getStringInfoNew = function
  StringData(_,_,n) -> Option.get (!n)
|_ -> Errormsg.impossible Errormsg.none 
         "getStringInfoNew: invalid term"

let setStringInfoNew stringInfo isNew =
  match stringInfo with
   StringData(_,_,n) ->  n := Some(isNew)
 | _ -> Errormsg.impossible Errormsg.none 
         "getStringInfoNew: invalid term"

let getStringInfoIndex = function
  StringData(_,i,_) -> Option.get (!i)
|_ -> Errormsg.impossible Errormsg.none 
         "getStringInfoIndex: invalid term"

let setStringInfoIndex stringInfo index =
  match stringInfo with
   StringData(_,i,_) -> i := Some(index)
  |_ -> Errormsg.impossible Errormsg.none 
          "getStringInfoIndex: invalid term"

let getStringInfoString = function
  StringData(str,_,_) -> str
| StringLiteral(str)  -> str

(*************************************************************************)
(*  agoal:                                                               *)
(*************************************************************************)
let rec string_of_goal g =
  match g with
    AtomicGoal(c,_,_,tl,_) -> (string_of_constant c)
  | AndGoal(g1, g2) -> "(" ^ (string_of_goal g1) ^ " & " ^ (string_of_goal g2) ^ ")"
  | ImpGoal(defs, vis, tvis, g) -> (string_of_goal g)
  | AllGoal(vars, g) -> (string_of_goal g)
  | SomeGoal(var, g) -> (string_of_goal g)
  | CutFailGoal -> "(" ^ "!, fail" ^ ")"

(* atomic goal *)
let getAtomicGoalNumberOfArgs = function
  AtomicGoal(_,numArgs,_,_,_) -> numArgs
| _ -> Errormsg.impossible Errormsg.none 
         "getAtomicGoalNumberOfArgs: invalid goal"   

let getAtomicGoalNumberOfTermArgs = function
  AtomicGoal(_,_,numTermArgs,_,_) -> numTermArgs
| _ -> Errormsg.impossible Errormsg.none 
         "getAtomicGoalNumberOfTermArgs: invalid goal"
 
let getAtomicGoalTermArgs = function
  AtomicGoal(_,_,_,tmArgs,_) -> tmArgs
| _ -> Errormsg.impossible Errormsg.none 
         "getAtomicGoalTermArgs: invalid goal"
  
let getAtomicGoalTypeArgs = function
  AtomicGoal(_,_,_,_,tyArgs) -> tyArgs
| _ -> Errormsg.impossible Errormsg.none 
         "getAtomicGoalTypeArgs: invalid goal"

let getAtomicGoalPredicate = function
  AtomicGoal(pred,_,_,_,_) -> pred
| _ -> Errormsg.impossible Errormsg.none 
         "getAtomicGoalPredicate: invalid goal"

(* and goal *)
let getAndGoalLeftOperand = function
  AndGoal(l, _) -> l
| _ -> Errormsg.impossible Errormsg.none 
         "getAndGoalLeftOperand: invalid goal"

let getAndGoalRightOperand= function
  AndGoal(_, r) -> r
| _ -> Errormsg.impossible Errormsg.none 
         "getAndGoalRightOperand: invalid goal"

(* all goal *)
let getAllGoalHCVarAssocs = function
  AllGoal(hc, _) -> hc
| _ -> Errormsg.impossible Errormsg.none 
         "getAllGoalHCVarAssocs: invalid goal"

let getAllGoalBody = function
  AllGoal(_, body) -> body
| _ -> Errormsg.impossible Errormsg.none 
         "getAllGoalBody: invalid goal"  

(* some goal *)
let getSomeGoalQuantVar = function
  SomeGoal(v, _) -> v
| _ -> Errormsg.impossible Errormsg.none 
         "getSomeGoalQuantVar: invalid goal"

let getSomeGoalBody = function
  SomeGoal(_, body) -> body
| _ -> Errormsg.impossible Errormsg.none 
         "getSomeGoalBody: invalid goal" 

(* imp goal *)
let getImpGoalVarInits = function
  ImpGoal(_, varInits, _, _) -> varInits
| _ -> Errormsg.impossible Errormsg.none 
         "getImpGoalVarInits: invalid goal" 

let getImpGoalTypeVarInits = function
  ImpGoal(_, _, tyVarInits, _) -> tyVarInits
| _ -> Errormsg.impossible Errormsg.none 
         "getImpGoalTyVarInits: invalid goal" 

let getImpGoalClauses = function
  ImpGoal(defs, _, _, _) -> defs
| _ -> Errormsg.impossible Errormsg.none 
         "getImpGoalClauses: invalid goal"

let getImpGoalBody = function
  ImpGoal(_, _, _, body) -> body
| _ -> Errormsg.impossible Errormsg.none 
         "getImpGoalBody: invalid goal"      

(*************************************************************************)
(*  aclause:                                                             *)
(*************************************************************************)
let isClauseFact = function
  Fact(_) -> true
| _ -> false

let getClausePred = function
  Fact(pred,_,_,_,_,_,_,_,_,_) -> pred
| Rule(pred,_,_,_,_,_,_,_,_,_,_,_,_,_) -> pred

let getClauseNumberOfArgs = function
  Fact(_,_,_,numArgs,_,_,_,_,_,_) -> numArgs
| Rule(_,_,_,numArgs,_,_,_,_,_,_,_,_,_,_) -> numArgs

let getClauseNumberOfTermArgs = function
  Fact(_,_,_,_,numTermArgs,_,_,_,_,_) -> numTermArgs
| Rule(_,_,_,_,numTermArgs,_,_,_,_,_,_,_,_,_) -> numTermArgs

let getClauseTermArgs = function 
  Fact(_,args,_,_,_,_,_,_,_,_) -> args
| Rule(_,args,_,_,_,_,_,_,_,_,_,_,_,_) -> args

let getClauseTypeArgs = function
  Fact(_,_,tyArgs,_,_,_,_,_,_,_) -> tyArgs
| Rule(_,_,tyArgs,_,_,_,_,_,_,_,_,_,_,_) -> tyArgs

let getClauseOffset = function
  Fact(_,_,_,_,_,_,_,_,offset,_) -> Option.get (!offset)
| Rule(_,_,_,_,_,_,_,_,offset,_,_,_,_,_) -> Option.get (!offset)
 
let setClauseOffset cl n = 
  match cl with
    Fact(_,_,_,_,_,_,_,_,offset,_) -> offset := Some(n)
  | Rule(_,_,_,_,_,_,_,_,offset,_,_,_,_,_) -> offset := Some(n)

let getClauseGoal = function 
  Rule(_,_,_,_,_,_,_,_,_,body,_,_,_,_) -> body
| _ -> Errormsg.impossible Errormsg.none 
         "getClauseGoal: fact" 

let getClauseCutVarOption = function
  Rule(_,_,_,_,_,_,_,_,_,_,_,cutvar,_,_) -> !cutvar
| _ -> Errormsg.impossible Errormsg.none 
         "getClauseCutVarOption: fact"  

let getClauseCutVar cl = Option.get (getClauseCutVarOption cl)

let getClauseImports = function 
  Fact(_,_,_,_,_,_,_,_,_,imp) -> imp
| Rule(_,_,_,_,_,_,_,_,_,_,_,_,_,imp) -> imp

let getClauseGespList = function
  Rule(_,_,_,_,_,_,_,_,_,_,gesp,_,_,_) -> !gesp
| _ -> Errormsg.impossible Errormsg.none 
         "getClauseGespList: fact"
  
let setClauseGespList cl gespList =
  match cl with
      Rule(_,_,_,_,_,_,_,_,_,_,gesp,_,_,_) -> gesp := gespList
  | _ -> Errormsg.impossible Errormsg.none 
         "setClauseGespList: fact"

let getClauseHasEnv = function
  Rule(_,_,_,_,_,_,_,_,_,_,_,_,hasenv,_) -> !hasenv
| _ -> Errormsg.impossible Errormsg.none 
         "getClauseHasEnv: fact"

let getClauseTypeVarMaps = function
  Fact(_,_,_,_,_,_,tyVarMap,_,_,_) -> tyVarMap
| Rule(_,_,_,_,_,_,tyVarMap,_,_,_,_,_,_,_) -> tyVarMap

let getClauseTermVarMaps = function
  Fact(_,_,_,_,_,tmVarMap,_,_,_,_) -> tmVarMap
| Rule(_,_,_,_,_,tmVarMap,_,_,_,_,_,_,_,_) -> tmVarMap

(*************************************************************************)
(*  agoalenvassoc:                                                       *)
(*************************************************************************)
(* get the nth entry in this list *) 
(* the given list must have a length larger than or equal to n *)
let getGoalEnvAssocNth gespList n =
  let rec getGoalEnvAssocNthAux gespList i =
    if (i = n) then List.hd gespList
    else getGoalEnvAssocNthAux (List.tl gespList) (i + 1)
  in
  let GoalEnvAssoc(gesp) = gespList in
  getGoalEnvAssocNthAux gesp 1


(* get envsize in the nth entry in this list; 0 is returned if empty list*)
let getGoalEnvAssocNthEnvSize gespList n =
  let rec getGoalEnvAssocNthEnvSizeAux gespList i =
    match gespList with
      [] -> 0
    | ((goalNum, envSize) :: rest) -> 
       if (i = n) then envSize
       else getGoalEnvAssocNthEnvSizeAux rest (i + 1)
  in
  let GoalEnvAssoc(gesp) = gespList in
  getGoalEnvAssocNthEnvSizeAux gesp 1  

(*************************************************************************)
(*  amodule:                                                             *)
(*************************************************************************)
let getModuleName = function
  Module(name,_,_,_,_,_,_,_,_,_,_,_,_,_,_) -> name
| Signature(_) -> Errormsg.impossible Errormsg.none "getModuleName: not a module"
| ErrorModule -> Errormsg.impossible Errormsg.none "getModuleName: invalid module"

let getModuleGlobalKindsList = function
  Module(_,_,_,_,_,_,_,gkinds,_,_,_,_,_,_,_) -> gkinds
| Signature(_) -> Errormsg.impossible Errormsg.none "getModuleGlobalKindList: not a module"
| ErrorModule -> Errormsg.impossible Errormsg.none "getModuleGlobalKindList: invalid module"


let getModuleGlobalConstantsList = function
  Module(_,_,_,_,_,_,_,_,_,gconsts,_,_,_,_,_) -> gconsts
| Signature(_) -> Errormsg.impossible Errormsg.none "getModuleGlobalConstList: not a module"
| ErrorModule -> Errormsg.impossible Errormsg.none "getModuleGlobalConstList: invalid module"

let getModuleHiddenConstantsRef = function
  Module(_,_,_,_,_,_,_,_,_,_,_,hcs,_,_,_) -> hcs
| Signature(_) -> Errormsg.impossible Errormsg.none "getModuleHiddenConstantsRef: not a module"
| ErrorModule -> Errormsg.impossible Errormsg.none "getModuleHiddenConstantsRef: invalid module"


let getModuleConstantTable = function
  Module(_,_,_,ctable,_,_,_,_,_,_,_,_,_,_,_) -> !ctable
| Signature(_) -> Errormsg.impossible Errormsg.none "getModuleConstantTable: not a module"
| ErrorModule -> Errormsg.impossible Errormsg.none "getModuleConstantTable: invalid module"

let getModuleKindTable = function
  Module(_,_,_,_,ktable,_,_,_,_,_,_,_,_,_,_) -> !ktable
| Signature(_) -> Errormsg.impossible Errormsg.none "getModuleKindTable: not a module"
| ErrorModule -> Errormsg.impossible Errormsg.none "getModuleKindTable: invalid module"

let getModuleTypeAbbrevTable = function
  Module(_,_,_,_,_,atable,_,_,_,_,_,_,_,_,_) -> atable
| Signature(_) -> Errormsg.impossible Errormsg.none "getModuleTypeAbbrevTable: not a module"
| ErrorModule -> Errormsg.impossible Errormsg.none "getModuleTypeAbbrevTable: invalid module"

let getModuleClausesRef = function
  Module(_,_,_,_,_,_,_,_,_,_,_,_,_,_,c) -> c
| Signature(_) -> Errormsg.impossible Errormsg.none "getModuleClausesRef: argument is a signature"
| ErrorModule -> Errormsg.impossible Errormsg.none "getModuleClausesRef: argument is invalid"

let getModuleClauses amod = !(getModuleClausesRef amod)
let setModuleClauses amod cls = (getModuleClausesRef amod) := cls

let getSignatureGlobalKindsList = function
  Signature(_,kl,_) -> kl
| Module(_) -> Errormsg.impossible Errormsg.none "getSignatureGlobalKindsList: argument is a module"
| ErrorModule -> Errormsg.impossible Errormsg.none "getSignatureGlobalKindsList: argument invalid"
  
  
let getSignatureGlobalConstantsList = function
  Signature(_,_,cl) -> cl
| Module(_) -> Errormsg.impossible Errormsg.none "getSignatureGlobalConstantsList: argument is a module"
| ErrorModule -> Errormsg.impossible Errormsg.none "getSignatureGlobalConstantsList: argument invalid"

let getSignatureName = function
  Signature(n,_,_) -> n
| Module(_) -> Errormsg.impossible Errormsg.none "getSignatureName: argument is a module"
| ErrorModule -> Errormsg.impossible Errormsg.none "getSignatureName: argument invalid"  

(*************************************************************************)
(*  aclauseinfo:                                                         *)
(*************************************************************************)
let getClauseInfoClauseBlocks = function
  ClauseBlocks(cls) -> cls
| _ -> Errormsg.impossible Errormsg.none
        "Absyn.getClauseInfoClauseBlocks: preclauseblocks"

(*************************************************************************)
(*  aclausesblock:                                                       *)
(*************************************************************************)
let getClauseBlockClauses = function
  (c,_,_,_) -> c
  
let getClauseBlockClose = function
  (_,closed,_,_) -> !closed

let setClauseBlockClose clb close = 
  let (_,closed,_,_) = clb in
  closed := close

let getClauseBlockNextClause = function
  (_,_,_,ncl) -> Option.get !ncl

let setClauseBlockNextClause clb nextClause =
  let (_,_,_,ncl) = clb in
  ncl := Some(nextClause)

let getClauseBlockClauses = function
  (cls,_,_,_) -> !cls

let getClauseBlockOffset = function
  (_,_,offset,_) -> !offset

let setClauseBlockOffset clb n =
  let (_,_,offset,_) = clb in
  offset := n

(* if the given clause has a body as CutFailGoal, then set the second   *)
(* field true and add an empty list as the clauses list                 *)
let makeNewClauseBlock cl closed =
  match cl with
	Rule(_) ->
	  if (getClauseGoal cl == CutFailGoal) then 
		(ref [], ref true, ref 0, ref None) 
	  else (ref [cl], ref closed, ref 0, ref None)
  | _ ->  (ref [cl], ref closed, ref 0, ref None)

(**********************************************************************
*printAbsyn:
* Prints the absyn representation of a module to the given out_channel.
**********************************************************************)
let printAbsyn = fun m out ->
  (*  Text output functions *)
  let output = function s -> (output_string out s) in
  let output_line = function s -> (output_string out (s ^ "\n")) in
  
  let printPos = fun p ->
    (output "Pos(";
    output (Errormsg.string_of_pos p);
    output ")")
  in
  
  let rec printTypeVar = function
    TypeVar(_) -> (output "TypeVar")
    
  and printTypeVarInfo = function
    BindableTypeVar(t) ->
      (match (!t) with
        Some t -> printType t
      | None -> output "None")
  | FreeTypeVar(tv, b) ->
      (match !tv with
        Some tvar -> printTypeVar tvar
      | None -> output "None")

  (*  Print an absyn type *)
  and printType = function
    TypeVarType(v) ->
      (output "TypeVar(";
      printTypeVarInfo (!v);
      output ")")
  | TypeSetType(def, l, r) ->
      let rec print' = function
        t::[] -> (printType t)
      | t::ts -> (printType t; output ", "; print' ts)
      | [] -> (output "")
      in
      
      let printRef = function
        Some(t) -> printType t
      | None -> output "None"
      in
      
      (output "TypeSetType(";
      printType def;
      output "[";
      print' !l;
      output "], ";
      printRef !r;
      output ")")
  | ArrowType(l, r) -> 
      (output "Arrow(";
      printType l;
      output ", ";
      printType r;
      output ")")
  | ApplicationType(f,t) ->
      let rec print' = function
        t::[] -> (printType t)
      | t::ts -> (printType t; output ", "; print' ts)
      | [] -> (output "None")
      in
      
      (output "App(";
      printKind f;
      output ", ";
      print' t;
      output ")")
  | SkeletonVarType(i) ->
      (output "SkeletonVar(";
      output (string_of_int !i);
      output ")")
  | ErrorType ->
      (output "Error")

  and printConstant const =
    printconstant' (Symbol.symbol "") const
  
  (*  Print a constant.  For use with printTable. *)
  and printconstant' sym const =
    let printConstantType = function
      GlobalConstant -> output "Global"
    | LocalConstant -> output "Local"
    | AnonymousConstant -> output "Anonymous"
    | HiddenConstant -> output "Hidden"
    | PervasiveConstant(b) -> 
        if b then
          output "Mutable Pervasive"
        else
          output "Immutable Pervasive"
    in
    
    let rec printSkeleton = function
      None -> output "None"
    | Some(Skeleton(t,i,b)) -> 
        (output "Skeleton(";
        printType t;
        output (", " ^ (Option.string_of_option !i string_of_int));
        output (", " ^ (string_of_bool !b));
        output ")")
    in
    
    match const with
      Constant(sym,fix,prec,exportdef,useonly,nodefs,closed,typepreserv,
        reducible,skel,envsize,_,_,codeinfo,ctype,index,pos) ->
        (output "Constant(";
        output (Symbol.name sym);
        output ", ";
        output (string_of_fixity !fix);
        output ", ";
        output (string_of_int !prec);
        output ", ";
        output (string_of_bool !exportdef);
        output ", ";
        output (string_of_bool !useonly);
        output ", ";
        output (string_of_bool !nodefs);
        output ", ";
        output (string_of_bool !closed);
        output ", ";
        output (string_of_bool !typepreserv);
        output ", ";
        output (string_of_bool !reducible);
        output ", ";
        printSkeleton !skel;
        output ", ";
        printConstantType !ctype;
        output ", ";
        printPos pos;
        output_line ")")
  
  (*  Print a kind.  For use with printTable. *)
  and printKind = fun k ->
    let print' = fun sym a kmap ->
      match a with
        Some a' ->
          (output (Symbol.name sym);
          output ", ";
          output (string_of_int a'))
      | None ->
          (output (Symbol.name sym);
          output ", ";
          output "None")
    in
    
    match k with
      LocalKind(sym,arity,kmap,p) ->
        (output "LocalKind(";
        print' sym arity kmap;
        output ")")
    | GlobalKind(sym,arity,kmap,p) ->
        (output "GlobalKind(";
        print' sym arity kmap;
        output ")")
    | PervasiveKind(sym,arity,kmap,p) ->
        (output "PervasiveKind(";
        print' sym arity kmap;
        output ")")
  in
  
  (*  Print the contents of a table *)
  let printTable = fun f table ->
    Table.iter f table
  in
  
  let printkind' = fun s k ->
    (output (Symbol.name s);
    output " : ";
    printKind k;
    output_line "")
  in

  (*
  let printClauseBlock = function
    (cl,_,_,_,_,_) ->
      (List.iter printClause (!cl))
  in
  
  let printClause = function
      Fact(c,tl,tyl,) ->
    | Rule() ->
  in
  
  let printClauses = function
      ClauseBlocks(cbs) -> List.iter printClauseBlock cbs
    | PreClauseBlocks(defs) -> List.iter printDefinition defs
  in
  *)
  match m with
    Module(name, impmods, accummods, ctable, ktable, tabbrevtable, strings,
      gkinds, lkinds, gconsts, lconsts, hconsts, gskels, lskels, clauses) ->
      
      (output "Module(";
      output name;
      output_line ", ";
      
      output_line "ConstantTable:";
      printTable printconstant' !ctable;
      output_line "";
      
      output_line "KindTable:";
      printTable printkind' !ktable;
      output_line "";
      
      (*
      output_line "Clauses:";
      printClauses !clauses;
      *)
      output_line ")")
      
  | Signature(name, kinds, consts) ->
      (output "Signature(";
      output_line name;
      output_line "Kinds:";
      List.iter printKind kinds;
      output_line "";
      output_line "Constants:";
      List.iter printConstant consts;
      output_line ")")
  | ErrorModule ->
      (output "ErrorModule")
