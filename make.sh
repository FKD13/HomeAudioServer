#!bin/bash

subdirs="$(find /var/www/html/* -type d | sed 's/$/\//' | tr '\n' ' ' )"

function makehtml() {
	#find all files in this directory
	files="$(find -maxdepth 1 -type f | grep .mp3 | sort | tr '\n' ' ')"
	#find all directory in this dir
	directories="$(find -maxdepth 1 -type d | sort | tr '\n' ' ')"
	
	#create empty index.html
	echo -e "<!DOCTYPE html>\n<html>\n<head>\n\t<link rel=\"stylesheet\" type=\"text/css\" href=\"http://fkserver/style.css\">\n</head>\n<body>" > index.html
	
	echo -e "\t<h1>$(pwd | sed 's/^.*\///')</h1>" >> index.html
	#add link to all subdirs
	for d in $directories
	do
		echo -e "\t<a href=\"$d\">$d</a><br>" >> index.html
	done
	
	#add all songs to the index.html
	echo "<table>" >> index.html #make a table
	count=1
	for file in $files
	do
		echo -e "\t<tr>\n\t\t<td>$file</td>\n\t\t<td><button id=\"${count}a\" type=\"button\" onclick=\"play(this)\">Play</button></td><td><button id=\"${count}b\" type=\"button\" onclick=\"stop(this)\">Pause</button><audio id=\"$count\" onended=\"playNext(this)\"><source src=\"$file\" type=\"audio/mpeg\">No Audio For You</audio></td>\n\t</tr>" >> index.html

		count=$((count + 1))
	done
	echo "</table>" >> index.html #close the table

	echo "<h2 id=\"playing\">Now playing: none</h2>" >> index.html
	
	echo "</body>" >> index.html 
	
	if [[ $count -gt 1 ]]
	then
		echo -e "<script>" >> index.html
		echo -e "function playNext(element) {\n\tnewid = parseInt(element.id) + 1;\n\tif (newid > $count) {\n\t\tnewid = 1;\n\t}\n\tdocument.getElementById(newid).play();\n}" >> index.html
		echo -e "function play(element) {\n\tlet id = element.id.substring(0,1);\ndocument.getElementById(id).play();\ndocument.getElementById(\"playing\").innerHTML = \"Now playing: \" + id;\n}" >> index.html
		echo -e "function stop(element) {\n\tlet id = element.id.substring(0,1);\ndocument.getElementById(id).pause();\ndocument.getElementById(\"playing\").innerHTML = \"Now playing: none\";\n}" >> index.html
		echo -e "</script>" >> index.html
	fi

	echo "</html>" >> index.html
	echo -e "\e[92m\e[1mSUCCES\e[0m\t$1"
}

for dir in $subdirs
do
        cd "$dir"
        echo -en "Making: " 
	makehtml "$dir"
done
