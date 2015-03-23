# Some Program Manipulating Programs in Teyjus #

The code accessible from this page illustrates the use of higher-order abstract syntax as it is supported in Lambda Prolog in representing and manipulating programs in a simple (functional) programming language. One component to understand here is the way programs are represented. Four manipulation tasks are also considered and these illustrate the benefits of beta reduction in realizing substitution into formulas, of higher-order unification in probing formula structure and of the new scoping primitives in Lambda Prolog in carrying out computations over abstraction structure. The menu below provides some help in understanding the structure of the code. All of the code listed here is available in the distribution of Teyjus under _examples/handbook/progs_.


  * Term encodings for programs in a functional programming language
    * [Kinds and constants for encoding function structure (abstraction and application)](http://teyjus.googlecode.com/svn/trunk/examples/handbook/progs/fp_types.sig)
    * [Constants representing programming language primitives](http://teyjus.googlecode.com/svn/trunk/examples/handbook/progs/fp_vocab.sig)
    * [Encodings of some simple programs](http://teyjus.googlecode.com/svn/trunk/examples/handbook/progs/terms.mod)
    * [Signature](http://teyjus.googlecode.com/svn/trunk/examples/handbook/progs/refl_syntax.sig) and [code](http://teyjus.googlecode.com/svn/trunk/examples/handbook/progs/refl_syntax.mod) for a recognizer for valid program terms

  * Implementing an interpreter for the programming language
    * [Signature](http://teyjus.googlecode.com/svn/trunk/examples/handbook/progs/eval_basic.sig) and [code](http://teyjus.googlecode.com/svn/trunk/examples/handbook/progs/eval_basic.mod) for an evaluator for the 'pure' terms
    * [Signature](http://teyjus.googlecode.com/svn/trunk/examples/handbook/progs/eval.sig) and [code](http://teyjus.googlecode.com/svn/trunk/examples/handbook/progs/eval.mod) for an evaluator for the full programming language
    * [Signature](http://teyjus.googlecode.com/svn/trunk/examples/handbook/progs/eval_examples.sig) and [code](http://teyjus.googlecode.com/svn/trunk/examples/handbook/progs/eval_examples.mod) for a testing harness
    * [Script](http://teyjus.googlecode.com/svn/trunk/examples/handbook/progs/script1) depicting a run of the code

  * An example of program analysis using higher-order unification
    * [Signature](http://teyjus.googlecode.com/svn/trunk/examples/handbook/progs/curry_transform.sig) and [code](http://teyjus.googlecode.com/svn/trunk/examples/handbook/progs/curry_transform.mod) for performing a currying transformation on binary functions
    * [Signature](http://teyjus.googlecode.com/svn/trunk/examples/handbook/progs/curry_test.sig) and [code](http://teyjus.googlecode.com/svn/trunk/examples/handbook/progs/curry_test.mod) for a testing harness
    * [Script](http://teyjus.googlecode.com/svn/trunk/examples/handbook/progs/script2) depicting a run of the code

  * Another example of program analysis using higher-order unification
    * [Signature](http://teyjus.googlecode.com/svn/trunk/examples/handbook/progs/tr_recognizer.sig) and [code](http://teyjus.googlecode.com/svn/trunk/examples/handbook/progs/tr_recognizer.mod) for recognizing tail recursiveness of binary functions
    * [Signature](http://teyjus.googlecode.com/svn/trunk/examples/handbook/progs/tr1_test.sig) and [code](http://teyjus.googlecode.com/svn/trunk/examples/handbook/progs/tr1_test.mod) for a testing harness
    * [Script](http://teyjus.googlecode.com/svn/trunk/examples/handbook/progs/script3) depicting a run of the code

  * A final example of program analysis, this time using scoping primitives for recursion over abstraction structure
    * [Signature](http://teyjus.googlecode.com/svn/trunk/examples/handbook/progs/general_tr.sig) and [code](http://teyjus.googlecode.com/svn/trunk/examples/handbook/progs/general_tr.mod) for a tail recursion recognizer for arbitrary arity functions
    * [Signature](http://teyjus.googlecode.com/svn/trunk/examples/handbook/progs/tr2_test.sig) and [code](http://teyjus.googlecode.com/svn/trunk/examples/handbook/progs/tr2_test.mod) for a testing harness
    * [Script](http://teyjus.googlecode.com/svn/trunk/examples/handbook/progs/script4) illustrating the use of the code

The code in this directory is based on the paper "Higher-Order Logic Programming" by Gopalan Nadathur and Dale Miller