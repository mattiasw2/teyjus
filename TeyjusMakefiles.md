# Introduction #

When working on a Teyjus project, a Makefile can help manage your build dependencies. The following Makefile should be used as a template.

```
TJROOT = /usr/local/bin

.PHONY: all
all: main.lp

%.lpo : %.mod %.sig
	$(TJROOT)/tjcc $*

%.lp : %.lpo
	$(TJROOT)/tjlink $*

-include depend
depend: *.mod *.sig
	$(TJROOT)/tjdepend *.mod > depend-stage
	mv depend-stage depend

.PHONY: clean
clean:
	rm -f *.lpo *.lp depend
```

To customize this Makefile for your project, adjust the `TJROOT` path as necessary and change `main.lp` to be the top-level module of your system. Multiple such top-level files can be specified. All other aspects of compilation-order and dependencies are managed by the generic portions of the Makefile.

**Note:** `make` requires that the indented lines above use a literal tab character and not simply spaces.

# Issues for Larger Developments #

If your Teyjus project becomes so large that dependency scanning is costly, it is possible to modify the Makefile so that dependencies are generated only when you request it. To do this, change the following line

```
depend: *.mod *.sig
```

to be simply

```
depend:
```

Then the file 'depend' which contains dependency information will be created only if it does not exist. To regenerate dependencies for your project, simply delete the 'depend' file and run make again.