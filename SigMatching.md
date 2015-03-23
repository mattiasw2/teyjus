# Matching a Module with its Signature #

The commentary accompanying signature and module syntax already discussed issues relevant to their being well-formed in isolation. This wiki considers the specific issue of matching a signature that resides in a file with extension _.sig_ with the declarations in the associated module that resides in a file with extension _.mod_. Such matching has three essential effects:

  * It makes sure that the types for (global) constants and the arities for (global) type constructors that are defined in the module agree with what is expected of them in the signature.

  * It identifies the final list of global and local constants, sorts and type constructors corresponding to the module.

  * It ensures that the _useonly_ restrictions on predicates are satisfied by the code in the module.

The broad manner of processing is the following. First, all type and kind declarations in a module are processed to extract lists of global and local constant, sort and type constructor declarations. The global lists are enhanced by the declarations in accumulated and used signatures and in the signatures of imported and accumulated modules; note that in collecting the "global" lists in a signature, it is necessary to recursively collect these lists from the signatures that that signature includes via _accum\_sig_ and _use\_sig_ declarations. The global lists that are computed from looking only at the module are now filtered by the lists obtained from the signature for this module, with the eliminated objects going to relevant local lists. At each stage in this processing, the declared type and arity of objects in a given category having identical names in any given context must match.

The simplified signature of global and local sorts, type constructors and constants is used to analyze and type check the clauses in the module. In this context, we note that any constant that is used in the clauses in the module must (a) already appear in either the global or the local list calculated for the module and (b) have a type that is an instance of its defined type. It must also be ascertained in the course of processing clauses that _useonly_ predicates do not have defining clauses either at the top-level or in the antecedents of implication goals.