<h2> jetbrains/teamcity-server </h2>
docker run -it --name teamcity-server-instance  \
    -v team_city_data:/data/teamcity_server/datadir \
    -v team_city_logs:/opt/teamcity/logs  \
    -p 8111:8111 \
    -d jetbrains/teamcity-server
