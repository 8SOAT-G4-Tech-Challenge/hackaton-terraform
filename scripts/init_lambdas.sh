#!/bin/bash
base_folder="$(dirname "$(pwd)")/../lambdas"
echo $base_folder

folders=$(find "$base_folder" -mindepth 1 -maxdepth 1 -type d)

for folder in $folders;
do
  echo "Installing packages at folder: $folder..."
  
  cd "$folder" || { echo "Failed to enter $folder"; exit 1; }

  npm i
  
  cd ../..
done

echo "Packages installed succesfully!"