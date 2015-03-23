# Building Teyjus on Linux and Similar Operating Systems #

The instructions describe how to build and install Teyjus on a Linux or similar operating system. This includes 32-bit and 64-bit versions of Linux as well as Mac OS X.

## Required Software ##

  * [OCaml](http://caml.inria.fr/download.en.html)
  * [OMake](http://omake.metaprl.org/download.html)
  * The Teyjus source distribution

You will also need the programs `gcc`, `flex`, and `bison` which are standard on most Linux distributions.

## Building Teyjus ##

From a command shell, navigate to the directory which contains the downloaded Teyjus code and execute `omake all`. This will create the programs `tjcc`, `tjsim`, `tjlink`, `tjdepend`, and `tjdis`. You should add the directory with these files to your path. Alternatively you can install Teyjus simply by copying these programs to your preferred installation directory. For example, `cp tj* /usr/bin/local`.

## For Teyjus Developers ##

If you want to work on the code of Teyjus, you will need a few more tools in order to run the automated tests. In particular, you need `perl` and `diff`, both of which are standard on most Linux distributions.

You should also obtain the full source code of Teyjus from the [subversion repository](http://code.google.com/p/teyjus/source/checkout). You can then run the automated tests with the command `omake test`.