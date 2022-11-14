#!/bin/bash

archiver_name='yt-archiver'
downloader='yt-dlp'
unformatted_file="yt-archive-unformatted.log"
formatted_file="yt-archive.log"

# Helper Functions
function say {
  echo "[$archiver_name] $@"
}

# Start
say "downloading id(s)"

# Check for different output file
if [ $# -eq 2 ]; then
  formatted_file=$2
  if [ $# -eq 3 ]; then
    downloader=$3
  fi
fi

# Get Ids
$downloader -v --get-id $1 > $unformatted_file

# Write ids to file in proper format
say "formatting ids"
while read -r line; do
	echo "youtube $line" >> $formatted_file
done < $unformatted_file

# Clean Up
rm $unformatted_file
say "finished creating download archive"
