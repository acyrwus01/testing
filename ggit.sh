#!/usr/bin/env sh

wget -q --spider http://google.com;

if [ $? -eq 0 ]; then
    echo "Yay we are online";
else
    echo "Could not connect to internet";
fi
# Since the scope is optional, wrap it in parentheses if it has a value.

# Pre-populate the input with the type(scope): so that the user may change it
SUMMARY=$(gum write --placeholder "Commit Message (CTRL+D to finish)")

# Commit these changes
gum confirm "Commit changes?" && git commit -m "$SUMMARY"
gum confirm "Push changes?"   && git push origin master
