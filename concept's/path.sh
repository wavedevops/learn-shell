script=$(realpath "$0")          # Get the full (absolute) path of the current script
script_path=$(dirname "$script") # Extract only the directory path from the full script path

echo "$script"                   # Print the full script path
echo "$script_path"              # Print the script's directory path

exit 1                           # Exit the script with status code 1 (indicates an error)
