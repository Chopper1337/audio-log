#!/bin/bash

# Navigate into the whisper.cpp directory
cd ./whisper.cpp/ || exit

# Build whisper.cpp
make

# Navigate to the models directory
cd ./models/ || exit

# Download the small model by default
./download-ggml-model.sh small
