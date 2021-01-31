# mplfinance-docker

Dockerfile for hub.docker.com/repository/docker/asah/mplfinance

```
echo "$DOCKER_PASSWORD" | docker login -u asah --password-stdin
docker buildx build --push --platform linux/arm/v7,linux/arm64/v8,linux/amd64 --tag asah/mplfinance:buildx-latest .
```
