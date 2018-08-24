# Configuration file for jupyterhub.

## Allow named single-user servers per user
c.JupyterHub.allow_named_servers = True

## The ip address for the Hub process to *bind* to.
#  
#  See `hub_connect_ip` for cases where the bind and connect address should
#  differ.
#c.JupyterHub.hub_ip = '127.0.0.1'
c.JupyterHub.hub_ip = '0.0.0.0'

## The port for the Hub process
#c.JupyterHub.hub_port = 8081

## The public facing ip of the whole application (the proxy)
#c.JupyterHub.ip = ''

## The IP address (or hostname) the single-user server should listen on.
#  
#  The JupyterHub proxy implementation should be able to send packets to this
#  interface.
#c.Spawner.ip = ''
c.Spawner.ip = '0.0.0.0'

#  Admin access should be treated the same way root access is.
#  
#  Defaults to an empty set, in which case no user has admin access.
c.Authenticator.admin_users = set(["master"])

c.Spawner.http_timeout = 120
c.JupyterHub.spawner_class = 'sshspawner.sshspawner.SSHSpawner'

# The remote host to spawn notebooks on
# c.SSHSpawner.remote_host = 'app'
c.SSHSpawner.remote_hosts = ['app1', 'app2']
c.SSHSpawner.remote_port = '22'

# The system path for the remote SSH session. Must have the jupyter-singleuser and python executables
c.SSHSpawner.path = '/opt/anaconda3/bin:/usr/bin:/bin:/usr/bin/X11:/usr/games:/usr/lib/mit/bin:/usr/lib/mit/sbin'

# The command to return an unused port on the target system. See scripts/get_port.py for an example
c.SSHSpawner.remote_port_command = '/opt/anaconda3/bin/get_port.py'

c.SSHSpawner.ssh_keyfile = '/tmp/{username}.key'

c.SSHSpawner.hub_api_url = 'http://web:8081/hub/api'
