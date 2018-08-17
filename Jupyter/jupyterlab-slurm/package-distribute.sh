export PROJECT=jupyterlab-slurm
export VERSION=0.1.0
export PKG_NAME=$PROJECT-$VERSION-0.tar.bz2

declare -a platforms=("win-64" "win-32" "linux-64" "linux-32" "linux-armv6l" "linux-armv7l" "linux-ppc64le" "linux-aarch64")

# https://stackoverflow.com/questions/5564418/exporting-an-array-in-bash-script#comment82148888_46498704
source activate anaconda
# where anaconda is a conda environment in which conda-build is installed
# (and in which we may have built before)

/bin/rm $CONDA_PREFIX/conda-bld/osx-64/$PKG_NAME
# https://stackoverflow.com/questions/8880603/loop-through-an-array-of-strings-in-bash
for i in "${platforms[@]}"
do
    /bin/rm $CONDA_PREFIX/conda-bld/$i/$PKG_NAME
done

conda build jupyterlab-slurm

conda convert $CONDA_PREFIX/conda-bld/osx-64/$PKG_NAME -p all -o $CONDA_PREFIX/conda-bld/ -f

for i in "${platforms[@]}"
do
    anaconda upload $CONDA_PREFIX/conda-bld/$i/$PKG_NAME
done
