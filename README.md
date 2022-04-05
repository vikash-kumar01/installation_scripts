## start TeamCity server as docker container
    docker run \
    -v team_city_data:/data/teamcity_server/datadir \
    -v team_city_logs:/opt/teamcity/logs  \
    -p 8111:8111 \
	-d jetbrains/teamcity-server


## start TeamCity agent without docker volume mount
    docker run -e SERVER_URL="http://public-ip:8111"  \
    -v team_city_agent_config:/data/teamcity_agent/conf  \
    -d jetbrains/teamcity-agent


## start TeamCity agent with docker volume mount
    docker run -e SERVER_URL="http://public-ip:8111"  \
    -v team_city_agent_config_two:/data/teamcity_agent/conf  \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v /usr/local/bin/docker:/usr/bin/docker \
    -d jetbrains/teamcity-agent

##### NOTE: for docker mount to work and docker commands to be executable inside the container, you need to set less stricter permission on docker on the host with the following command
    chmod 666 /var/run/docker.sock
    
![image](https://user-images.githubusercontent.com/35370115/161730805-06096c00-fa2d-4e52-b010-870430f6cfbf.png)
