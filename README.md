**Note:** This is modified from the setup created by Rollin Thomas, Shane
  Canon, Kelly Rowland, and Shreyas Cholia at [NERSC](https://github.com/NERSC/jupyterhub-deploy).

This base image just creates a setup which has both JupyterHub and
JupyterLab installed, with the LabHub extension installed (but without
the necessary configuration in `jupyterhub_config.py`, namely `c.Spawner.default_url = '/lab'` and
`c.Spawner.cmd = ['jupyter-labhub']`, although this configuration _is_ added in some of the child images). The child images use
this same setup, and then have various additional packages and/or
extensions installed to test how they work in a basic
JupyterHub+JupyterLab setup.

To run the container, do

```docker run -it -d -p 8000:8000 jupyter:nbviewer```

which will lead to some ugly hexadecimal hash string ("CONTAINER ID") being printed to stdout, then do

```docker ps```

to see the name of the container associated to the container ID, say `<name>`, and then do

```docker exec -it <name> bash```

This should land you inside of `/srv` inside of the container. Now
just run `jupyterhub` to load the hub. The hub will be associated with
the container's port 8000, which is mapped to your (localhost's) port
8000, and the nbviewer instance will be associated to the container's
port 9000. This will not be mapped to your (localhost's) port 9000, but that's not a problem, since we don't access or interact with the nbviewer service directly. Instead JupyterHub's proxy allows us to connect with the container's port 9000 (and thus the nbviewer instance) when we enter the correct URL, which will be associated with the container's port 8000 (where the JupyterHub instance lives).

So to log in, go to your browser and enter the URL `localhost:8000`,
and at the log in screen, either do: **user:** `william` **password:**
`hi`, or **user:** `krinsman` **password:** `bye`.

The only difference
is that `krinsman` is a JupyterHub admin in most of the child images but `william` is not.
