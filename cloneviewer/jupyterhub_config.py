c.JupyterHub.services = [
    {
        # the /services/<name> path for accessing the notebook viewer
        'name': 'nbviewer',
        # the interface and port nbviewer will use
        'url': 'http://127.0.0.1:9000',
        # command to start the nbviewer
        'command': ['python', '-m', 'nbviewer',
                        '--localfiles=/tmp/nbviewer/notebook-5.7.8/tools/tests',
                        '--clone-notebooks',
                        '--template-path=/media/templates',
                        '--local_handler=clonenotebooks.renderers.LocalRenderingHandler',
                        '--url_handler=clonenotebooks.renderers.URLRenderingHandler',
                        '--github_blob_handler=clonenotebooks.renderers.GitHubBlobRenderingHandler',
                        '--gist_handler=clonenotebooks.renderers.GistRenderingHandler']
    }
]

c.Authenticator.admin_users = set(["krinsman"])

c.JupyterHub.hub_ip = '0.0.0.0'

# following advice here: https://jupyterlab.readthedocs.io/en/stable/user/jupyterhub.html
c.Spawner.default_url = '/lab'
# also advice here: https://github.com/jupyterhub/jupyterlab-hub
c.Spawner.cmd = ['jupyter-labhub']
