# r-sl3_conda-recipe

Successfully tested conda build recipe (created with `conda skeleton`), which (at least on Mac OS X) should create a conda package for tlverse's [sl3](https://github.com/tlverse/sl3) package.

*Note*: This package has dependencies which are not in Anaconda's default channel. One way to work around this is to use `conda build -c krinsman r-sl3`, since all of the dependencies for this package have been uploaded to [the conda channel `krinsman`](https://anaconda.org/krinsman). (This won't work for Windows, however, since I was not able to make Windows binaries for the dependencies on my Mac OS X. In that case you will have to do what I did, which is manually create packages for all of those dependencies yourself. This is extremely tedious, yet nevertheless possible.)

See [the page](https://anaconda.org/krinsman/r-sl3) for the corresponding package uploaded to Anaconda.org.