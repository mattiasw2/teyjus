# Building Teyjus on Windows using the Cygwin Toolchain #

## Required Software ##

  * [OCaml](http://caml.inria.fr/download.en.html) based on the **MinGW toolchain**.
  * [OMake](http://omake.metaprl.org/download.html)
  * [Cygwin](http://www.cygwin.com/)
  * The Teyjus source distribution

## Setting up Cygwin ##

When installing Cygwin you must select the following packages for installation.

  * Devel: bison
  * Devel: gcc
  * Devel: flex

After Cygwin is installed, you must put Cygwin's binary directory in your Window's path. For example, `C:\cygwin\bin`.

## Building Teyjus ##

From a command shell, navigate to the directory which contains the downloaded Teyjus code and execute `omake all`. This will create the programs `tjcc`, `tjsim`, `tjlink`, `tjdepend`, and `tjdis`. You should add the directory with these files to your Window's path.

## For Teyjus Developers ##

If you want to work on the code of Teyjus, you will need a few more tools in order to run the automated tests. First, you should install the following Cygwin packages.

  * Devel: perl
  * Utils: diffutils

You should also obtain the full source code of Teyjus from the [subversion repository](http://code.google.com/p/teyjus/source/checkout). You can then run the automated tests with the command `omake test`.