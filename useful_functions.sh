img_init() {
hash=$(docker run -it -d -p 8000:8000 $1)
docker exec -it $hash bash
}

img_exit() {
hash=$(docker ps -a -q --filter=ancestor=$1)
docker rm -f $hash
}

