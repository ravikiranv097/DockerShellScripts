#!/bin/bash

# Check if there are running Docker containers
if [ "$(docker ps -q)" == "" ]; then
  echo "No Running Docker Containers found."
  exit 1
fi

# List all running Docker containers and assign an index
echo "List of Running Docker Containers:"
container_index=0
docker ps --format "table {{.ID}}\t{{.Image}}\t{{.Names}}" | tail -n +2 | nl -w2 -s'. ' > /tmp/container_list
cat /tmp/container_list

# Ask the user to select containers to stop
echo "Enter the numbers of containers to stop (space-separated), or type 'all' to stop all containers:"
read selection

# Check if the user wants to stop all containers
if [ "$selection" == "all" ]; then
  docker stop $(docker ps -q)
  echo "All running containers have been stopped."
else
  # Split the user input into an array
  containers=($selection)

  # Loop through the selected container numbers and stop them
  for container in "${containers[@]}"; do
    container_id=$(sed -n "${container}p" /tmp/container_list | awk '{print $2}')
    docker stop "$container_id"
  done

  echo "Selected containers have been stopped."
fi

# Clean up the temporary file
rm /tmp/container_list

