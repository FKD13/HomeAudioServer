#!bin/bash

subdirs="$(find $PWD/* -type d | sed 's/$/\//' | tr '\n' ' ' )"
maindir="$PWD/"

function add() {
	echo -e "$1" >> index.html
}

function makehtml() {
	#find all files in this directory
	files="$(find -maxdepth 1 -type f | grep .mp3 | sort | tr '\n' ' ')"
	#find all directory in this dir
	directories="$(find -maxdepth 1 -type d | sort | tr '\n' ' ')"
	
	#create empty index.html
	echo -e "" > index.html
	add "<!DOCTYPE html>\n<html>\n<head>\n\t<link rel=\"stylesheet\" type=\"text/css\" href=\"/style.css\">\n</head>\n<body>"
	
	add "\t<h1>$(pwd | sed 's/^.*\///')</h1>"
	#add link to all subdirs
	for d in $directories
	do
		if [[ $d != "." ]]
		then
			add "\t<a href=\"$d\">$d</a><br>"
		fi
	done
	
	#add all songs to the index.html
	add "<table>" #make a table
	count=1
	for file in $files
	do
		add "\t<tr>\n\t\t<td>$file</td>\n\t\t<td><button id=\"a${count}\" type=\"button\" onclick=\"play(this)\">Play</button></td><td><button id=\"b${count}\" type=\"button\" onclick=\"stop(this)\">Pause</button><audio id=\"$count\" onended=\"playNext(this)\" ontimeupdate=\"updateBar(this)\"><source src=\"$file\" type=\"audio/mpeg\">No Audio For You</audio></td>\n\t</tr>"

		count=$((count + 1))
	done
	add "</table>" #close the table

	
	
	if [[ $count -gt 1 ]]
	then
		add "<h2 id=\"playing\">Now playing: none</h2>"
		add "<canvas id=\"progress\" width=\"500\" height=\"25\"></canvas>"
		add "</body>"
		
		add "<script src=\"/handle.js\">"
		add "</script>"
	fi

	add "</html>"
	echo -e "\e[92m\e[1mSUCCES\e[0m\t$1"
}

for dir in $subdirs
do
        cd "$dir"
        echo -en "Making: " 
	makehtml "$dir"
done
