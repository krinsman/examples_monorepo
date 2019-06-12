**Note:** most of this is largely borrowed from the setup created by Rollin Thomas, Shane
  Canon, Kelly Rowland, and Shreyas Cholia at [NERSC](https://github.com/NERSC/jupyterhub-deploy).

To run the container, do

```docker run -it -d -p 8000:8000 jupyter:cloneviewer```

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
`hi`, or **user:** `krinsman` **password:** `bye`. The only difference
is that `krinsman` is a JupyterHub admin but `william` is not. Now,
after logging in, you can access the nbviewer instance. Do this by
entering the URL `localhost:8000/services/nbviewer` into your browser. It should be
possible to browse around, click things, everything working. Now, to
go to nbviewer's file explorer, enter the URL
`localhost:8000/services/nbviewer/localfile` into your browser. This
should take you to a file browser starting at the root directory of
the container. For notebook files to look at, you can go to e.g.

```/tmp/nbviewer/notebook-5.7.8/tools/tests```
