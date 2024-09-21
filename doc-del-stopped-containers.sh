#!/bin/bash

# Check if there are any stopped Docker containers
if [ "$(docker ps -q -f status=exited)" != "" ]; then
  # Delete all stopped Docker containers
  docker rm $(docker ps -q -f status=exited)
  echo "All stopped Docker containers have been deleted."
else
  echo "No stopped Docker containers are present."
fi

