#!/bin/bash

echo -e "\033[0;32mDeploying updates to GitHub...\033[0m"

# Build the project.
hugo # if using a theme, replace with `hugo -t <YOURTHEME>`

cd public && git add --all && git commit -m "Publishing to gh-pages" && cd ..
git push upstream gh-pages
