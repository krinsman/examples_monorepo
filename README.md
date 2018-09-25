# Using the containers
(Zeroth, you need to have Docker installed and running for any of the below to work.)

First, in either of the two subfolders, run `setup.sh`. (You may need to do `chmod +x setup.sh` first to make the shell script executable on your computer.) Wait. (This will be really slow the first time since Docker has to create the images. Subsequent times it will be able to use the previously created images and start up the container much faster.) 

Then to enter the container, run `docker-compose exec biocondademo bash`. This will open up a BASH shell running _from inside the container_ (with root permissions). That means whatever commands you enter now will be run inside the container, not inside your computer.

To exit the container, type `exit`. To restart the container, run `restart-container.sh` (again you may need to first make it executable by running `chmod +x restart-container.sh`). To shut down the container (without restarting), run `docker-compose down`.

# What to run inside the container created from `demo-incomplete`

1. First install Miniconda using the provided Miniconda installer: `./M<now type TAB>`. 
2. Hold down `ENTER` to scroll through the terms and conditions. Then follow the installation directions.
3. Make sure to choose `/opt/anaconda` as the install directory (if you want\*\*\* the extra steps I took to make your life easier to take effect). 
4. Run `source ~/.bashrc` (so that the settings in the BASH configuration file I added, as well as those added by the conda installer, can now take effect).
5. `conda create --name bioconda` to create a conda virtual environment with the name (you guessed it) `bioconda`.
6. `conda activate bioconda` to activate the conda virtual environment.
7. Now let's follow the set-up information from the Bioconda website, _with one small twist_. First\*\*\*\* run `conda config --env --add channels defaults`, then run `conda config --env --add channels bioconda`, and finally run `conda config --env --add channels conda-forge`. The important difference to note with the instructions on the Bioconda website is the extra `--env` flag. This tells conda to apply the operation _to the active environment only_ -- without this flag the operation would be applied to the base environment (which by best practice should be kept as pristine and unchanged as possible). Since we ran `conda activate bioconda` above, the active environment is (should be) `bioconda`, so these changes to the channels will only apply to that environment.
8. Now that our conda channels are configured correctly, we can now install all the R and Bioconductor packages we want with impunity. Run

    ```
    conda install r-base r-irkernel jupyter bioconductor-biobase bioconductor-biocinstaller
    ```

This installs R, the R kernel for Jupyter notebook, Jupyter notebook, and the base Bioconductor packages _inside of the `bioconda` environment_ in your container. In particular, even inside of the container they won't be available outside of the `bioconda` environment (i.e. they won't mess anything outside of your environment up in case something goes wrong). (Note that inside `demo-complete` I also install the major Tidyverse packages for you. For the purposes of the in class demo I omitted that step so as to speed up the installation of everything.) Look at all of the packages it installs for you -- conda takes care of all of the messy work of dependency tracking for you, even installing the necessary Fortran compiler. This also makes your work reproducible in a way it could never be otherwise.

(Also all of this will get flushed once when you shut down the container, so don't do anything important you want to save in the container and then close the container. The point of the container is just to show you how you could do this on your own computer, without making you do this on your own computer. Also because I have already done this on my own computer and couldn't realistically do it again on my computer for the demo without using the container as a VM.)

# Running Jupyter notebook from either container
Inside of the container, run `jupyter` from the `bioconda` environment. (On your actual machine you would have to run `jupyter notebook` -- the only reason `jupyter` works here is because I added an alias for you -- note that this is a terrible alias since it overwrite an already existing shell command. I was lazy and didn't want to bother devising anything better for the purposes of the demo. You are welcome to suggest a better one to me and I'll change it.)

Note that the `docker-compose.yml`'s are deliberately set up so that the container's port `8888` is mapped to your computer's (i.e. the local host's) port `8888`. 

What this means in practical terms is that, when running the container, if you want to access the Jupyter notebook you've opened\* you need to go to `http://localhost:8888`.

At this point you will see the notebook asking for your "token". All you have to do is look at the terminal, copy the long complicated string following `token=` in the displayed URL, paste it into the text box, and click the button. Then everything will run like normal.

**Beginner's tip:** To kill the notebook process running in your terminal, use `Ctrl-C` (type it two times fast if you're impatient like me).

Why doesn't the Jupyter notebook run like normal\*\* here? Basically the reason is that the notebook is being run from the container, but you are accessing it "from a different computer" (i.e. outside of the container), so as a security measure the notebook asks you for the super-long and complicated string (i.e. hash) it generated upon startup -- if you know what that string is, then most likely you are the same person who started the notebook on the original computer, so it lets you run from a different computer. (This isn't 100\%) accurate but is a heuristic 0th order approximation of the truth.)

\* Provided you opened it with the `jupyter` alias I provided, the alias being deliberately designed to ensure that Jupyter notebook is ran on port 8888 inside of the container.

\*\* The way it would run if it wasn't ran from inside of a Docker container.

\*\*\* Note that on your actual computer there isn't any reason to necessarily choose this as the install directory if you don't want it as the install directory.

\*\*\*\* Actually running `conda config --env --add channels defaults` should be redundant if you followed the above steps perfectly. It's good practice to ensure reproducibility in case you didn't follow the above instructions perfectly enough, and even if you did follow them perfectly, it does no harm (in this case) to run.