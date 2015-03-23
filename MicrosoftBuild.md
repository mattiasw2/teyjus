## Building Teyjus on Windows using the Microsoft Toolchain ##

## Required Software ##

  * [O'Caml](http://caml.inria.fr/download.en.html)
  * [OMake](http://omake.metaprl.org/download.html)
  * [Microsoft Visual Studio 2008](http://msdn2.microsoft.com/en-us/vstudio/default.aspx)
  * [Flex](http://gnuwin32.sourceforge.net/packages/flex.htm)
  * [Bison](http://gnuwin32.sourceforge.net/packages/bison.htm)
  * Ocamake (see below)
  * The Teyjus source distribution

> All of the above should be installed and in your PATH.

## Ocamake ##

Ocamake is a useful utility for compiling O'Caml programs.  It is available from [Motion-Twin](http://tech.motion-twin.com/ocamake.html), however you should use the version included in the Teyjus distribution (located at /util/ocamake.ml), as it has been patched to allow it to parse Microsoft Visual Studio 2008 project files.  To build ocamake, run the following command from the command line in the /util directory:
```
  ocamlc unix.cma str.cma ocamake.ml -o ocamake.exe
```

Then, place ocamake.exe in your path; one option is to copy the binary to the O'Caml /bin directory.


## Building Teyjus ##

Open the provided solution (located at /source/VisualStudio/Teyjus.sln) and select Build\Rebuild Solution, or type Ctrl + Alt + F7.  This will build all of the binaries, and place them in /bin.

Building has been tested on Microsoft Visual Studio 2008 Express, Standard and Professional editions.

## For Teyjus Developers ##

If you want to work on the code of Teyjus, you will need a few more tools in order to run the automated tests.  First, you should install the following tools.

  * [Perl](http://http://www.activestate.com/store/activeperl)
  * [DiffUtils](http://gnuwin32.sourceforge.net/packages/diffutils.htm)

You should also obtain the full source code of Teyjus from the [subversion repository](http://code.google.com/p/teyjus/source/checkout). You can then run the automated tests by running the following command at the command line in the /source directory:
```
  omake test
  omake compiler-test
  omake linker-test
```
Note that, due to the way ActivePerl executes programs from the command line, the test 'maps' (run when 'omake test' is invoked) will fail.