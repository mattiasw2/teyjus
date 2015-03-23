Lambda Prolog is a logic programming language that is based on the
intuitionistic theory of _higher-order hereditary Harrop
formulas_. This class of formulas
enriches that of Horn clauses---the logical basis of Prolog---with the
possibilities of quantifying over function and (certain occurrences
of) predicate variables, of explicitly representing binding in terms
and of using a fuller complement of connectives and quantifiers.  By
systematically exploiting the new features in the underlying logic,
Lambda Prolog provides support at the programming level for
capabilities such as higher-order programming, polymorphic typing,
scoping over names and procedures, modular programming, abstract data
types and the use of lambda terms as data structures.

Much research has been conducted towards fully
understanding the usefulness of the additions to logic programming
embodied in Lambda Prolog.  Two aspects that have received special
attention are the availability of lambda terms for representing
objects and of a suitable set of primitives for manipulating such
representations.  These features enable Lambda Prolog to support the
notion of _higher-order abstract syntax_, a profitable way to
view the syntax of objects whose structures involve binding. Several
detailed studies have, in fact, indicated the utility of this language
in building symbolic systems that manipulate objects such as formulas,
programs, proofs and types.

It is beyond the (present) scope of this manual to provide a
comprehensive introduction to Lambda Prolog or to its underlying
theory. If you are interested learning more about these aspects, one
place to look may be the paper

  * G. Nadathur and D. Miller, Higher-Order Logic Programming, in _Handbook of Logic in Artificial Intelligence and Logic Programming_, D. M. Gabbay, C. J. Hogger and J. A. Robinson (eds.), Oxford University Press, January 1998, pages 499--590. ([dvi](http://www-users.cs.umn.edu/~gopalan/papers/holp.dvi)) ([ps](http://www-users.cs.umn.edu/~gopalan/papers/holp.ps))


The distribution material also contains several examples of Lambda
Prolog code with pointers to papers describing conceptual aspects of the
code as relevant. It would be quite useful to try to understand
some of these examples in depth before you begin writing your own
programs. There is some divergence in the language treated between
different implementations of Lambda Prolog, so you
may want also to pay attention to the particular rendition of these
examples into code for the Teyjus system. If you are already familiar
with Lambda Prolog but want to understand how to program using the _Teyjus_ system, you might want to proceed to the page that describes [the general structure of programs in Teyjus](ProgramStructure.md) and, subsequently to the page that specifies [the syntax supported by Teyjus](TeyjusPrograms.md).