#!/bin/bash

# Function to display a list of images and prompt the user to select images for deletion
select_and_delete_images() {
  local image_type="$1"  # 'child' or 'unused'

  # Check if there are images of the specified type
  if [ "$image_type" == "child" ]; then
    images=$(docker images --format "table {{.ID}}\t{{.Repository}}:{{.Tag}}\t{{.Size}}" | tail -n +2 | awk '{if ($3 != "0B") print}')
    message="child Docker images:"
  elif [ "$image_type" == "unused" ]; then
    images=$(docker images -f "dangling=true" --format "table {{.ID}}\t{{.Repository}}:{{.Tag}}\t{{.Size}}" | tail -n +2)
    message="unused Docker images:"
  else
    return
  fi

  # Display the images
  if [ -z "$images" ]; then
    echo "No $message found."
    return
  else
    echo "Available $message"
    echo "$images" | nl -w2 -s'. '
  fi

  # Ask the user to select images to delete
  echo "Enter the numbers of $message to delete (space-separated), or type 'all' to delete all $image_type images:"
  read selection

  # Check if the user wants to delete all images
  if [ "$selection" == "all" ]; then
    docker rmi -f $(echo "$images" | awk '{print $2}')
    echo "All $image_type images have been deleted."
  else
    # Split the user input into an array
    selected_indexes=($selection)

    # Loop through the selected image numbers and delete them
    for index in "${selected_indexes[@]}"; do
      image_id=$(echo "$images" | sed -n "${index}p" | awk '{print $2}')
      docker rmi -f "$image_id"
    done

    echo "Selected $image_type images have been deleted."
  fi
}

# Menu to choose which images to delete
echo "Select the type of Docker images to manage:"
select image_type in "Child Images" "Unused and Stopped Images" "Quit"; do
  case $image_type in
    "Child Images")
      select_and_delete_images "child"
      ;;
    "Unused and Stopped Images")
      select_and_delete_images "unused"
      ;;
    "Quit")
      break
      ;;
    *)
      echo "Invalid selection. Please choose a valid option."
      ;;
  esac
done

