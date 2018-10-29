#!/bin/bash
if [ -z "$1" ]
	then
		echo "[!] Usage: cat_color.sh FileName"
	else
		"C:\\PentestBox\\base\\python\\Scripts\\pygmentize.exe" -g "$1" || "pygmentize" -g "$1"
fi
