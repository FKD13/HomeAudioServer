#!bin/bash

subdirs="$(find /var/www/html/* -type d | sed 's/$/\//' | tr '\n' ' ' )"

function makehtml() {
	#find all files in this directory
	files="$(find -maxdepth 1 -type f | grep .mp3 | sort | tr '\n' ' ')"
	#find all directory in this dir
	directories="$(find -maxdepth 1 -type d | sort | tr '\n' ' ')"
	
	#create empty index.html
	echo -e "<!DOCTYPE html>\n<head>\n</head>\n<body>" > index.html
	
	#add link to all subdirs
	for d in $directories
	do
		echo -e "\t<a href=\"$d\">$d</a><br>" >> index.html
	done
	#add all songs to the index.html
	echo "<table>" >> index.html #make a table
	for file in $files
	do
		echo -e "\t<tr>\n\t\t<td>$file</td>\n\t\t<td><audio controls><source src=\"$file\" type=\"audio/mpeg\">No Audio For You</audio></td>\n\t</tr>" >> index.html
	done
	echo "</table>" >> index.html

	echo "</body>" >> index.html #close the table
}

for dir in $subdirs
do
        cd "$dir"
        echo "############################################" 
	makehtml
done
