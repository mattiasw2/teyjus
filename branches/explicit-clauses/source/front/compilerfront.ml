(****************************************************************************
*Copyright 2008
*  Andrew Gacek, Steven Holte, Gopalan Nadathur, Xiaochu Qi, Zach Snow
****************************************************************************)
(****************************************************************************
* This file is part of Teyjus.
*
* Teyjus is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* Teyjus is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with Teyjus.  If not, see <http://www.gnu.org/licenses/>.
****************************************************************************)
open Parseargs

let abortOnError () =
  if !Errormsg.anyErrors then
    exit 1

let parse basename =
  (* Parse the input module and signature and generate preabsyn. *)
  let modresult = Compile.compileModule basename in
  let _ = abortOnError () in
    
  let sigresult = Compile.compileSignature basename in
  let _ = abortOnError () in
    (modresult, sigresult)


let compile basename outfile =
  let (modresult, sigresult) = parse basename in
      
  (* Construct an absyn module.  At this point only the module's *)
  (* constant, kind, and type abbrev information is valid.       *)
  let (absyn, sigabsyn) = Translate.translate modresult sigresult in
  let _ = abortOnError () in

  (* Get the list of clauses and new clauses. *)
  let (absyn, clauses, newclauses, closeddefs) = 
    Clauses.translateClauses modresult absyn in
  let _ = abortOnError () in

  (*
  let outchannel = Compile.openFile (basename ^ ".clauses.txt") open_out in
   Clauses.printTranslatedClauses clauses newclauses outchannel;
   Compile.closeFile outchannel close_out;
  *)

  (* Reduce skeleton *)
  let absyn = Typereduction.reduceSkeletons absyn in
  let _ = abortOnError () in
  
  (* Process the clauses. *)
  let absyn = 
  	Processclauses.processClauses absyn clauses newclauses closeddefs in
  let _ = abortOnError () in
 
  (* Reduce predicate types *)
  (* let absyn = Typereduction.reducePredicates absyn in *)
  (* let _ = abortOnError () in *)
				
  (* Process the clauses. *)
  let _ = Annvariables.processClauses absyn in
  let _ = abortOnError () in
				  
  (* Construct a codegen module. *)
  let cg = Codegen.generateModuleCode absyn in
  let _ = abortOnError () in
					
  (* Open the correct output file. *)
  let _ = Bytecode.openOutChannel outfile in
  let _ = abortOnError () in

	Bytecode.setWordSize () ;
	Spitcode.writeByteCode cg ;
    abortOnError ()

let explicify basename = 
  let (modresult, sigresult) = parse basename in
  let modresultExp = Explicify.explicify modresult in
  let sigresultExp = Explicify.explicify sigresult in
  Preabsyn.preAbsynToCode modresultExp basename;
  Preabsyn.preAbsynToCode sigresultExp basename


let outputName = ref ""

let setPath path =
  print_string "not implemented\n"

let explicit = ref false
  
let specList = dualArgs
  [("-o", "--output", Arg.Set_string outputName,
    " Specifies the name of the output bytecode file") ;
   ("-p", "--path", Arg.String setPath,
    " Add PATH to the search path.") ;
   ("-exp", "--explicit", Arg.Set explicit,
    " Transform clauses into explicit ones (experimental)") ;
   versionspec]

let usageMsg = 
  "Usage: tjcc [options] <files>\n" ^
  "options are:"

let _ =    
  Arg.parse (Arg.align specList) (setInputName ~filter:getModName) usageMsg ;
  ensureInputName () ;

  if !outputName = "" then
    outputName := Bytecode.makeByteCodeFileName !inputName ;

  if !explicit then
    explicify !inputName 
  else
    compile !inputName !outputName