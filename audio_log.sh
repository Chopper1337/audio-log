#!/bin/bash

# Take the first arg as the name of the model
# If no arg is given, use ggml-small.bin as default
model=${1:-ggml-small.bin}

check_whisper()
{
    # Check if whisper.cpp/main exists
    if [ ! -f whisper.cpp/main ]; then
        echo "whisper.cpp/main not found!"
        echo "Please build whisper.cpp first by running setup.sh or manually following whisper.cpp/README.md"
        exit 1
    fi

    # Check if the model exists
    if [ ! -f "whisper.cpp/models/$model" ]; then
        echo "$model not found, please run setup.sh first or manually download the model following whisper.cpp/README.md"
        exit 1
    fi
}

check_whisper
today=$(date +%Y%m%d_%H%M%S)
echo "Today is $today"
echo "Creating directory $today"
mkdir -p "$today"
cd "$today" || exit
echo Recording started, press Ctrl+C to stop
arecord -f cd -r 16000 -t wav "$today.wav"
../whisper.cpp/main -m ../whisper.cpp/models/ggml-small.bin -f "$today.wav" --output-txt
cd ..
echo "Transcript saved to $today/$today.txt"
echo "Audio saved to $today/$today.wav"
