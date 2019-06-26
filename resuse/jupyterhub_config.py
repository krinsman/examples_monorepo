c.Authenticator.admin_users = set(["krinsman"])

c.JupyterHub.hub_ip = '0.0.0.0'

# following advice here: https://jupyterlab.readthedocs.io/en/stable/user/jupyterhub.html
c.Spawner.default_url = '/lab'
# also advice here: https://github.com/jupyterhub/jupyterlab-hub
c.Spawner.cmd = ['jupyter-labhub']
