# r-delayed_conda-recipe

Successfully tested conda build recipe (created with `conda skeleton`), which (at least on Mac OS X) should create a conda package for tlverse's [delayed](https://github.com/tlverse/delayed) package.

Note: This package has dependencies which are not in Anaconda's default channel. One way to work around this is to use `conda build -c krinsman r-delayed`, since all of the dependencies for this package have been uploaded to [the conda channel `krinsman`](https://anaconda.org/krinsman). (This won't work for Windows, however, since I was not able to make Windows binaries for the dependencies on my Mac OS X. In that case you will have to do what I did, which is manually create packages for all of those dependencies yourself. This is extremely tedious, yet nevertheless possible.)

See [the page](https://anaconda.org/krinsman/r-delayed) for the corresponding package uploaded to Anaconda.org.