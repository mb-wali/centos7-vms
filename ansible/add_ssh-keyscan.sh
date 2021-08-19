# run this to add the results of ssh-keyscan to known_hosts
SERVER_LIST=$(cat ./hosts)
for host in $SERVER_LIST; do ssh-keyscan -H $host >> ~/.ssh/known_hosts; done
