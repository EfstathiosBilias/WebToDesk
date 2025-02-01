#!/bin/zsh

# Step 1: Get Variables from User Input
echo "Enter the Application name (e.g. ExampleApp):"
read NAME
echo "Enter the URL (e.g. https://exampleapp.com):"
read URL

# Check if the user entered both variables
if [[ -z "$NAME" || -z "$URL" ]]; then
  echo "Both NAME and URL must be provided!"
  exit 1
fi

# Convert NAME to lowercase for use in .desktop and file paths
LOWERCASE_NAME=$(echo "$NAME" | tr '[:upper:]' '[:lower:]')

# Step 2: Create Desktop App using nativefier in the home directory
cd "$HOME"
nativefier --name "$NAME" "$URL"
cd "$HOME/$NAME-linux-x64"

# Step 3: Fix Permissions (for sandboxing)
sudo chown root:root chrome-sandbox
sudo chmod 4755 chrome-sandbox

# Step 4: Create Desktop Shortcut
echo -e "[Desktop Entry]\n\
Name=$NAME\n\
Exec=/home/$USER/$NAME-linux-x64/$NAME\n\
Icon=/home/$USER/$NAME-linux-x64/resources/app/icon.png\n\
Terminal=false\n\
Type=Application\n\
Categories=Network;" | tee ~/.local/share/applications/$LOWERCASE_NAME.desktop > /dev/null

chmod +x ~/.local/share/applications/$LOWERCASE_NAME.desktop 

# Step 6: Refresh Application Menu
xdg-desktop-menu forceupdate
