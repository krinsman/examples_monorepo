c.Authenticator.admin_users = set(["krinsman"])

c.JupyterHub.hub_ip = '0.0.0.0'

# following advice here: https://jupyterlab.readthedocs.io/en/stable/user/jupyterhub.html
c.Spawner.default_url = '/lab'

# Advice seems to be unclear/inconsistent about whether this should still be done for JupyterLab 1.0
# https://github.com/jupyterlab/jupyterlab/blob/3d710e0a26bee56fa0a008ecd547e9f663ae6340/jupyterlab/labhubapp.py#L16
c.Spawner.cmd = ['jupyter-labhub']
# At the very least it doesn't break anything
