# docker-ts3
Teamspeak 3 Server in a docker container

## Usage

### Without Persistent Storage:

```
docker run -d --name teamspeak-server \
  -p 9987:9987/udp -p 10011:10011 -p 30033:30033 \
  ahmedwaleedmalik/docker-ts3
```

### With persistent storage:

```
docker run -d --name teamspeak-server \
  -p 9987:9987/udp -p 10011:10011 -p 30033:30033 \
  -v /ts3server/data:/data \  
  ahmedwaleedmalik/docker-ts3
```

### Using docker-compose file

`docker-compose up -d`

**NOTE:** For mounted volume set permissions and users accordingly:

```
chown 9999:9999 /ts3server/data
chmod 777 /ts3server/data
```

## Configuration

### Retrieving Credentials

For retrieving `Admin Token` and `Server Query Admin Token` go through container logs. It will print both credentials
at startup. 

`docker logs teamspeak-server`

# Useful resources

- https://help.tcadmin.com/Teamspeak_Server_Configuration