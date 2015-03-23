# Using Signatures to Certify Module Interactions #

Part of the process of certifying module interactions involves checking for compatibility between symbols that are global to an imported module and the definitions of these symbols in the importing module or in the signatures of sibling imported modules. This aspect is covered under the topic of matching a module with its signature. The other part of the process concerns ensuring that the intended restrictions corresponding to _exportdef_ and _useonly_ declarations are satisfied. This has also been discussed at other places but, for the sake of completeness we consolidate this discussion here.

_Exportdef Declarations_

> A module whose signature annotates a predicate as _exportdef_ is signalling that it is providing a complete definition of that predicate whose name can be viewed from outside. This, in turn, implies that the definition of that predicate cannot be changed in any context into which that module is imported or accumulated. To enforce this requirement, a few different things must happen:
    * The importing or accumulating module should not contain any clauses that add to the definition of this predicate.
> > 
    * None of the sibling imported or accumulated modules should have the capability of changing the definition either. In the separate compilation model, such a restriction has to be determined by the signature that summarizes such modules. Specifically, either the predicate in question should not be global to such a sibling module or, if it is global, it should be identified as _useonly_ there.
> > 
    * The importing or accumulating module should propagate the restriction outwards as well. Specifically, any predicate declared to be _exportdef_ in the signature of a "child" module should either not be global to the "parent" module, i.e., should not be indentified in its signature, or should be declared to be _exportdef_ there.


_Useonly Declarations_


> To satisfy a _useonly_ annotation for a predicate in the signature complementing a module, the following conditions should hold:
    * There should be no clauses defining that predicate at the top-level in the module or embedded within goals constituting the bodies of such top-level clauses.
> > 
    * The predicate should either not be identified in the signature of any accumulated or imported module or, if it is identified there, it should be recursively annotated as _useonly_.


There is a complementarity relationship between _exportdef_ and _useonly_. It can therefore be useful to have the ability to include smaller signatures in larger ones that permit the implied complementation. This is the role played by the _use`_`sig_ directive for including signatures that is to be contrasted with the _accum`_`sig_ directive.