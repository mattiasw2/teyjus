# An Interactive Theorem Prover Implemented in Teyjus #

The code accessible from this page shows the implementation of an interactive theorem prover based on tactics and tacticals in Teyjus. This code brings out many of the good features of Lambda Prolog: lambda terms as a means for capturing the higher-order abstract syntax of formulas and proofs, beta conversion as a means for realizing substitution correctly, benefits of higher-order programming and the support for search in logic programming as a natural basis for realizing tactics and tacticals. The menu below provides some help in understanding the structure of the code. All of the code listed here is available in the distribution of Teyjus under _examples/ndprover_.

  * Encodings for formulas and proofs in a first order logic
    * Sorts and contants encoding the [logical](http://teyjus.googlecode.com/svn/trunk/examples/ndprover/logic.sig) and [nonlogical](http://teyjus.googlecode.com/svn/trunk/examples/ndprover/nonlogical.sig) vocabulary of a first-order logic.
    * [Illustrations of the encodings of formulas](http://teyjus.googlecode.com/svn/trunk/examples/ndprover/formulas.mod)
    * [Encodings of proofs in a natural deduction calculus](http://teyjus.googlecode.com/svn/trunk/examples/ndprover/ndproofs.sig)

  * Implementation of tactics and tacticals
    * [Encodings of goals in theorem proving](http://teyjus.googlecode.com/svn/trunk/examples/ndprover/goaltypes.sig)
    * [Signature](http://teyjus.googlecode.com/svn/trunk/examples/ndprover/ndtac.sig) and [code](http://teyjus.googlecode.com/svn/trunk/examples/ndprover/ndtac.mod) realizing some primitive tactics ([Signature](http://teyjus.googlecode.com/svn/trunk/examples/ndprover/listmanip.sig) and [code](http://teyjus.googlecode.com/svn/trunk/examples/ndprover/listmanip.mod) for list manipulation routines used in this code)
    * [Signature](http://teyjus.googlecode.com/svn/trunk/examples/ndprover/goalred.sig) and [code](http://teyjus.googlecode.com/svn/trunk/examples/ndprover/goalred.mod) for goal simplification code
    * [Signature](http://teyjus.googlecode.com/svn/trunk/examples/ndprover/tacticals.sig) and [code](http://teyjus.googlecode.com/svn/trunk/examples/ndprover/tacticals.mod) for some tacticals

  * [Signature](http://teyjus.googlecode.com/svn/trunk/examples/ndprover/inter.sig) and [code](http://teyjus.googlecode.com/svn/trunk/examples/ndprover/inter.mod) for the interactive theorem prover

  * A [Makefile](http://teyjus.googlecode.com/svn/trunk/examples/ndprover/Makefile) for building a linked image of the interactive theorem prover module

  * [Script](http://teyjus.googlecode.com/svn/trunk/examples/ndprover/script) illustrating the use of the code

The code in this directory is based on work in the doctoral dissertation of Amy Felty and has been adapted to Teyjus from an demo of the first implementation of Lambda Prolog.