img_init() {
    hash=$(docker run -it -d -p 8000:8000 $1)
    docker exec -it $hash bash
}

img_exit() {
    hash=$(docker ps -a -q --filter=ancestor=$1)
    docker rm -f $hash
}

# Check to see whether base image already exists; if it doesn't, then build it
if_not_base_image_then_build_it() {
    export baseDockerImage="jupyter:labhub"
  
    if ! docker inspect "$baseDockerImage" &> /dev/null; then
	docker build                   \
               --file=Dockerfile       \
               --force-rm              \
	       --tag $baseDockerImage  \
	       .
    fi
}

# Delete all intermediate images with label autodelete=true
destroy_intermediates() {
    # From: https://github.com/moby/moby/issues/34151#issuecomment-478802490
    list=$(docker images -q -f "label=autodelete=true")
    if [ -n "$list" ]; then
	docker rmi $list
    fi
}

$@
