export TOKEN=$(jupyterhub token master) 
curl -X POST -H "Authorization: token $TOKEN" "http://localhost:8081/hub/api/users/master/servers/test"
