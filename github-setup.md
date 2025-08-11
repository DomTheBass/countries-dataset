# GitHub Repository Setup Commands (COMPLETED ✅)
# 
# This repository has been successfully published to:
# https://github.com/DomTheBass/countries-dataset

# Commands that were used:
git init
git add .
git commit -m "Initial commit: Countries dataset with 195 countries"
git branch -M main
git remote add origin https://github.com/DomTheBass/countries-dataset.git

# Authentication was done using GitHub CLI:
brew install gh
gh auth login
git push -u origin main

# Future updates can be pushed with:
git add .
git commit -m "Your commit message"
git push
