# define a shell function that runs a notebook from the command line without a timeout
execute_notebook()
{
NOTEBOOK=$1
jupyter nbconvert --ExecutePreprocessor.timeout=None --to notebook --execute $NOTEBOOK
}

conda env create -f environment.yml
source activate bioconda
execute_notebook # add file name of first notebook here
execute_notebook # ...
execute_notebook # add file name of nth notebook here