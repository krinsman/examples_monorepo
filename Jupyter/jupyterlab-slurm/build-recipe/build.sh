# Fill in the name of the git directory from which the extension is to be installed here:
export PKG_NAME=jupyterlab-slurm

# If Jupyter data and config directories have already been set by the user,
# the contents of those directories are copied into the newly created data and config directories.
# This ensures that the user does not lose any Jupyter settings which they were used to having
# in the particular conda environment. At the same time, it still also ensures that the values of
# the Jupyter data and config directories are specific to the given conda environment ONLY, and
# thus that any changes in settings occurring as a result of installing this package are localized
# to the given conda environment (into which the package is being installed) ONLY.

/bin/mkdir -p $CONDA_PREFIX/etc $CONDA_PREFIX/etc/$PKG_NAME

# make sure repository contents actually at desired location
/bin/cp -a ./. $CONDA_PREFIX/etc/$PKG_NAME
cd $CONDA_PREFIX/etc

/bin/mkdir -p ./jupyter/nbdata ./jupyter/nbconfig ./conda/activate.d ./conda/deactivate.d
touch ./conda/activate.d/env_vars.sh ./conda/deactivate.d/env_vars.sh

##### Create activation script

# create a shell script to run upon activation of the conda environment
echo "#\!/bin/bash" >> ./conda/activate.d/env_vars.sh
# if a Jupyter data directory already exists, copy its contents to the new Jupyter data directory
if [ ! -z "$JUPYTER_DATA_DIR" ]
then
    /bin/cp -a $JUPYTER_DATA_DIR/. $CONDA_PREFIX/etc/jupyter/nbdata
    echo ""
    echo "WARNING: Your Jupyter data directory for this conda environment has been changed."
    echo "Your Jupyter data directory has been changed ONLY for this conda environment."
    echo "Your Jupyter data directory has been changed from $JUPYTER_DATA_DIR to $CONDA_PREFIX/etc/jupyter/nbdata"
    echo ""
fi
# ensure that a value for the Jupyter data directory is set for the current conda environment
# and that this choice is reflected in the shell environment variables upon activation of the environment
echo "export JUPYTER_DATA_DIR=\$CONDA_PREFIX/etc/jupyter/nbdata" >> ./conda/activate.d/env_vars.sh

# if a Jupyter config directory already exists, copy its contents to the new Jupyter config directory
if [ ! -z "$JUPYTER_CONFIG_DIR" ]
then
    /bin/cp -a $JUPYTER_CONFIG_DIR/. $CONDA_PREFIX/etc/jupyter/nbconfig
    echo ""
    echo "WARNING: Your Jupyter config directory for this conda environment has been changed."
    echo "Your Jupyter config directory has been changed ONLY for this conda environment."
    echo "Your Jupyter config directory has been changed from $JUPYTER_CONFIG_DIR to $CONDA_PREFIX/etc/jupyter/nbconfig"
    echo ""
fi
# ensure that a Jupyter config directory is set for the current conda environment
# and that this choice is reflected in the shell environment variables upon activation of the environment
echo "export JUPYTER_CONFIG_DIR=\$CONDA_PREFIX/etc/jupyter/nbconfig" >> ./conda/activate.d/env_vars.sh
    
##### Create deactivation script

echo "#\!/bin/bash" >> ./conda/deactivate.d/env_vars.sh
echo "unset JUPYTER_DATA_DIR" >> ./conda/deactivate.d/env_vars.sh
echo "unset JUPYTER_CONFIG_DIR" >> ./conda/deactivate.d/env_vars.sh

##### Deactivate then reactivate conda environment so that changes take effect

export ENVIRONMENT_DIRECTORY=$CONDA_PREFIX
conda deactivate
source activate $ENVIRONMENT_DIRECTORY

##### Actually install the JupyterLab extension
cd $PKG_NAME

##### COPY AND PASTE DEVELOPER INSTALL INSTRUCTIONS HERE

# In case you get an error about NPM running out of memory:
# export NODE_OPTIONS=--max-old-space-size=4096

# If developer install instructions aren't provided, first try the pattern found in the docs:
# http://jupyterlab.readthedocs.io/en/stable/developer/extension_dev.html#extension-authoring

pip install .
jupyter serverextension enable --py jupyterlab-slurm --sys-prefix

npm install
npm run build
jupyter labextension install .

cd ..
/bin/rm -rf ./$PKG_NAME

# The idea was to re-build JupyterLab so that extension is loaded upon startup
# but it doesn't seem to actually do anything in practice
# Lab still needs to be rebuilt for the installation to complete
# jupyter lab build
# Likewise Lab still needs to be rebuilt for any uninstall to be complete
