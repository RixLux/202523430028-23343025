# Getting Started

Well, this is a basic instruction to get Flutter working on Linux, specifically tailored for **Bazzite** using **Homebrew** and **Fish Shell**.

## 1. Prerequisites (The SDKs)

Since we are skipping the heavy Android Studio IDE, we will use **Homebrew** to manage our toolchain.

### Install the Core Tools

Open your terminal and run:

```
# Install Flutter and the Android Command Line Tools
brew install --cask flutter
```
```
brew install --cask android-commandlinetools

# Install Java 17 (Required for Android builds)
brew install openjdk@17
```

Or you can get flutter from their official website and put it anywhere you like , later on you can expose it's path on your shell config
## 2. Shell Configuration (Fish)

Bazzite's came with Fish shell (my favorite). You need to tell it where these tools live. Add these to your `~/.config/fish/config.fish`:

use nano or whatever to edit these config  
```
nano ~/.config/fish/config.fish

```
or use these gui text editor that came with bazzite  
```
kate ~/.config/fish/config.fish

```

```
# Android Home and Path
set -gx ANDROID_HOME /home/linuxbrew/.linuxbrew/share/android-commandlinetools
fish_add_path $ANDROID_HOME/cmdline-tools/latest/bin
fish_add_path $ANDROID_HOME/platform-tools

# Java Home
set -gx JAVA_HOME /home/linuxbrew/.linuxbrew/opt/openjdk@17
fish_add_path $JAVA_HOME/bin

# Chrome Executable (For Web Development)
set -gx CHROME_EXECUTABLE /var/lib/flatpak/exports/bin/com.google.Chrome

```

that's the basic if you use brew and flatpak  

feel free to steal mine if you get flutter from their official website
```
# ~/.config/fish/config.fish

# 1. Environment Variables
set -gx CHROME_EXECUTABLE /var/lib/flatpak/exports/bin/com.google.Chrome
set -gx ANDROID_HOME /home/linuxbrew/.linuxbrew/share/android-commandlinetools
set -gx JAVA_HOME /home/linuxbrew/.linuxbrew/opt/openjdk@17


# 2.PATH Setup
# fish_add_path will only add these if they exist and aren't already there
fish_add_path $HOME/develop/flutter/bin
fish_add_path $HOME/.local/bin
fish_add_path $HOME/bin
fish_add_path $JAVA_HOME/bin
fish_add_path $ANDROID_HOME/cmdline-tools/latest/bin
fish_add_path $ANDROID_HOME/platform-tools
```

## 3. The "Android Toolchain" 

this is the what i did at 19/02/2026:

```
# 1. Update the manager
sdkmanager --update

# 2. Install the specific build tools Flutter requires
sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0" "build-tools;28.0.3"

# 3. Accept the licenses (Press 'y' for all)
flutter doctor --android-licenses

```




