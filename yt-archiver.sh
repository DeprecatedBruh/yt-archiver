#!/bin/bash

archiver_name="yt-archiver"
downloader="yt-dlp"
unformatted_file="yt-archive-unformatted.log"
formatted_file="yt-archive.log"
url_prefix="youtube"
url=""

# Helper Functions
function say {
  echo "[$archiver_name] $@"
}

# Start
say "downloading id(s)"

# Parse Arguments
args=($@)

for ((i = 0; i < "${#args[@]}"; i+=2)); do
  next_arg="${args[$((i + 1))]}"
  # Check for arg type
  case "${args[$i]}" in
    # Formatted File
    -o | --formatted-file) 
      formatted_file="$next_arg"
    ;;
    # Url Prefix
    -u | --url-prefix)
      url_prefix="$next_arg"
    ;;
    # Downloader Command Name
    -d | --downloader)
      downloader="$next_arg"
    ;;
    # Unformatted File Name
    --unformatted-file)
      unformatted_file="$next_arg"
    ;;
    # Ordered Args
    *)
      url="${args[$i]}"
      ((--i)) # Decrement 'i' since ordered args only consume one argument
    ;;
  esac
done

# Get Ids
$downloader -v --get-id "$url" > $unformatted_file

# Write ids to file in proper format
say "formatting ids"
while read -r line; do
	echo "$url_prefix $line" >> $formatted_file
done < $unformatted_file

# Clean Up
rm $unformatted_file
say "finished creating download archive"
