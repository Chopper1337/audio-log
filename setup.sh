#!/bin/bash

echo "Building whisper.cpp..."

# Navigate into the whisper.cpp directory
cd ./whisper.cpp/ || exit

# Build whisper.cpp
make

# Ask the user if the want to download the small model
read -p "Do you want to download the small model? (Recommended for basic use) [Y/n] " -n 1 -r
echo
if [[ $REPLY =~ ^[Nn]$ ]]; then
    echo "Please run whisper.cpp/download-ggml-model.sh manually."
    exit 0
fi

# Navigate to the models directory
cd ./models/ || exit

# Download the small model by default
./download-ggml-model.sh small
