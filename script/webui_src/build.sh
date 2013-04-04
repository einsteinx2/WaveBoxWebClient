#!/bin/sh

echo "THIS MUST BE RUN FROM INSIDE THE webui_src FOLDER OR IT CAN DELETE YOUR JS FILES :)"
echo " "
read -p "Press [Enter] key to build..."

echo "Compiling TypeScript to JavaScript and placing in scripts folder as webuits.js"
tsc --out ../webuits.js main.ts
echo "Done!"

read -p "Press [Enter] to remove temporary js files. BE CAREFUL THAT YOU DIDN'T RUN THIS SCRIPT FROM SOMEWHERE ELSE OTHER THAN THE webui_src FOLDER! :)"
echo "Removing temporary js files"
find . -name \*.js -type f -delete
echo "Done!"
