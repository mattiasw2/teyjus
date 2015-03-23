# Some Formula Manipulating Programs in Teyjus #

The code accessible from this page illustrates the use of higher-order abstract syntax as it is supported in Lambda Prolog in representing and manipulating formulas in quantificational logic. One component to understand here is the way formulas are encoded. Three manipulation tasks are also considered and these illustrate the benefits of beta reduction in realizing substitution into formulas, of higher-order unification in probing formula structure and of the new scoping primitives in Lambda Prolog in carrying out computations over abstraction structure. The menu below provides some help in understanding the structure of the code. All of the code listed here is available in the distribution of Teyjus under _examples/handbook/logic_.

  * Term encodings for formulas in a first order logic
    * [Types for basic categories of expressions](http://teyjus.googlecode.com/svn/trunk/examples/handbook/logic/logic_types.sig)
    * [Constants representing logical symbols](http://teyjus.googlecode.com/svn/trunk/examples/handbook/logic/logic_basic.sig)
    * [Constants representing a few non-logical symbols](http://teyjus.googlecode.com/svn/trunk/examples/handbook/logic/logic_vocab.sig)

  * Implementing a Horn clause logic interpreter
    * [Signature](http://teyjus.googlecode.com/svn/trunk/examples/handbook/logic/hc_interp.sig) and [code](http://teyjus.googlecode.com/svn/trunk/examples/handbook/logic/hc_interp.mod) for the interpreter
    * [Signature](http://teyjus.googlecode.com/svn/trunk/examples/handbook/logic/hcinterp_examples.sig) and [code](http://teyjus.googlecode.com/svn/trunk/examples/handbook/logic/hcinterp_examples.mod) for a testing harness

  * Analyzing formula structure
    * [Signature](http://teyjus.googlecode.com/svn/trunk/examples/handbook/logic/refl_syntax.sig) and [code](http://teyjus.googlecode.com/svn/trunk/examples/handbook/logic/refl_syntax.mod) for recognizing terms and quantifier free formulas
    * [Signature](http://teyjus.googlecode.com/svn/trunk/examples/handbook/logic/hc_syntax.sig) and [code](http://teyjus.googlecode.com/svn/trunk/examples/handbook/logic/hc_syntax.mod) for recognizing goals and clauses in Horn clause logic
    * [Signature](http://teyjus.googlecode.com/svn/trunk/examples/handbook/logic/hcsyntax_examples.sig) and [code](http://teyjus.googlecode.com/svn/trunk/examples/handbook/logic/hcsyntax_examples.mod) for a testing harness

  * Analysis and synthesis of formula structure
    * [Signature](http://teyjus.googlecode.com/svn/trunk/examples/handbook/logic/pnf.sig) and [code](http://teyjus.googlecode.com/svn/trunk/examples/handbook/logic/pnf.mod) for a transformer to prenex normal form
    * [Signature](http://teyjus.googlecode.com/svn/trunk/examples/handbook/logic/pnf_examples.sig) and [code](http://teyjus.googlecode.com/svn/trunk/examples/handbook/logic/pnf_examples.mod) for a testing harness

  * A [Makefile](http://teyjus.googlecode.com/svn/trunk/examples/handbook/logic/Makefile) for creating linked images of relevant formula processing modules

  * Scripts illustrating the use of the code
    * [Horn clause interpreter](http://teyjus.googlecode.com/svn/trunk/examples/handbook/logic/script1)
    * [Recognizers for formula categories](http://teyjus.googlecode.com/svn/trunk/examples/handbook/logic/script2)
    * [Prenex normal form transformer](http://teyjus.googlecode.com/svn/trunk/examples/handbook/logic/script3)

The code in this directory is adapted by Gopalan Nadathur from material in the paper "Higher-Order Logic Programming" by Gopalan Nadathur and Dale Miller.