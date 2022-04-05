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


<h2> jetbrains/teamcity-server </h2>
docker run -it --name teamcity-server-instance  \
    -v team_city_data:/data/teamcity_server/datadir \
    -v team_city_logs:/opt/teamcity/logs  \
    -p 8111:8111 \
    -d jetbrains/teamcity-server
    
 # After Adding Gradle Build--> Docker Build --> Docker Push Step, Now need to establish docker login connection
 # Click on Java-App-->Connections-->docker registry and provide all Options
 # Now need to use this on Build Setups --> Build --> Build Feature -->Add Build Feature --> docker suport-->Add registry connection
 
 
 # Now to Run a Build we need to configure an AGENT --> Run A Docker Image Again for AGENt
 docker run -it -v team_city_agent_config:/data/teamcity_agent/conf -e SERVER_URL="http://13.59.96.198:8111" -d jetbrains/teamcity-agent
 # GO to TeamCity-->AGENT-->POOLS and Authorize The AGENT
 # SInce TEamCity Automaticall Detects which Agent to Choose to Run Which Code...(In this case its not an suitable Agent because Agent does't have docker installed in it)
 # for Verification == Click Top "Projects"  -> Chhoose Project--> BUild --> Compatible agents --> Shows 0
 
 # for Compatible Agent need to mount local docker to agent volume
 ## start TeamCity agent with docker volume mount

