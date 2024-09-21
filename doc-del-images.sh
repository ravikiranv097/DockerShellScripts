#!/bin/bash

# List all unused and stopped Docker images and assign an index
echo "Unused and Stopped Docker Images:"
image_index=0
docker images --filter "dangling=false" --format "table {{.ID}}\t{{.Repository}}:{{.Tag}}\t{{.Size}}" | tail -n +2 | nl -w2 -s'. ' > /tmp/image_list
cat /tmp/image_list

# Ask the user to select images to delete
echo "Enter the numbers of images to delete (space-separated), or type 'all' to delete all images:"
read selection

# Check if the user wants to delete all images
if [ "$selection" == "all" ]; then
  docker rmi -f $(docker images -q --filter "dangling=false")
  echo "All selected images have been deleted."
else
  # Split the user input into an array
  images=($selection)

  # Loop through the selected image numbers and delete them
  for image in "${images[@]}"; do
    image_id=$(sed -n "${image}p" /tmp/image_list | awk '{print $2}')
    docker rmi "$image_id"
  done

  echo "Selected images have been deleted."
fi

# Clean up the temporary file
rm /tmp/image_list

