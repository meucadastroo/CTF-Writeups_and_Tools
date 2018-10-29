#!/bin/bash
if [ -z "$1" ]
	then
		echo "[!] Usage: $0 FileName"
	else
		"C:\\PentestBox\\base\\python\\Scripts\\pygmentize.exe" -g "$1" || "pygmentize" -g "$1"
fi
