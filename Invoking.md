# How to Run Teyjus #

As a typical user of Teyjus, you will regularly use the compiler `tjcc`, the linker `tjlink`, and the simulator `tjsim`.

## Compiling ##

To compile a Teyjus module named `<modname>` you must have both the module file `<modname>.mod` and the signature file `<modname>.sig`. You can compile this module with the following command

```
tjcc <modname>
```

If compilation is successful, the file `<modname>.lpo` will be created. If your project has multiple module files, they must all be compiled before you can link them together.

## Linking ##

Compiled code must be linked before it can be executed. The linker should be invoked on the module that you intend to be the root, or top level, module in your project. It is invoked as follows

```
tjlink <modname>
```

If linking is successful, the file `<modname>.lp` will be created.

## Running the Simulator ##

To run the simulator execute the following command.

```
tjsim <modname>
```

This will load `<modname>.lp` and allow you to perform queries on it. It is also possible to run queries in batch mode using the command line flags of `tjsim`. Execute `tjsim --help` to find out more.

## Putting it Together ##

As your project grows, you may find it difficult to keep track of which modules need to be recompiled after each change. TeyjusMakefiles provides a Makefile which will automatically handle all such dependencies.