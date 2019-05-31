c.JupyterHub.services = [
    {
        # the /services/<name> path for accessing the notebook viewer
        'name': 'nbviewer',
        # the interface and port nbviewer will use
        'url': 'http://127.0.0.1:9000',
        # the path to nbviewer repo
        'cwd': '/tmp/nbviewer',
        # command to start the nbviewer
        'command': ['python', '-m', 'nbviewer', '--localfiles=/']
    }
]

c.Authenticator.admin_users = set(["krinsman"])

c.JupyterHub.hub_ip = '0.0.0.0'
