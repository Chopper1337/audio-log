#!/bin/bash


# Variables
BUILD_OPENCL=0
BUILD_CUDA=0

amd_gpu(){
    # If the user has an AMD GPU, ask if they want to build with OpenCL support
    read -p "Do you want to build whisper.cpp with OpenCL support? (Recommended for AMD GPUs) [Y/n] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        BUILD_OPENCL=1
    fi
}

nvidia_gpu(){
    # If the user has an NVIDIA GPU, ask if they want to build with CUDA support
    read -p "Do you want to build whisper.cpp with CUDA support? (Recommended for NVIDIA GPUs) [Y/n] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        BUILD_CUDA=1
    fi
}

determine_gpu(){
    # Determine if the user has an AMD or NVIDIA GPU
    if lspci | grep -i amd\/ati | grep -i vga; then
        echo "AMD GPU detected"
        amd_gpu
    elif lspci | grep -i nvidia | grep -i vga; then
        echo "NVIDIA GPU detected"
        nvidia_gpu
    else
        echo "No GPU detected, you can manually build whisper.cpp, following the whisper.cpp README.md, if your GPU was not detected."
fi
}

model_msg(){
    echo -e "\nPlease ignore the usage message above, it is outputted by the model downloader."
    echo -e "\nTo use the audio log, you can run:"
    echo -e "\t./audio_log.sh"
}

select_model_download(){
    # Show a list of available models
    echo "Available models:"
    echo "0. Tiny (~75MB)"
    echo "1. Small (~450MB)"
    echo "2. Medium (~1.5GB)"
    echo "3. Large (~3GB)"
    echo "4. Cancel"
    echo
    read -p "Which model do you want to download? " -n 1 -r
    echo
    if [[ $REPLY =~ ^[0]$ ]]; then
        ./download-ggml-model.sh tiny
        model_msg
    elif [[ $REPLY =~ ^[1]$ ]]; then
        ./download-ggml-model.sh small
        model_msg
    elif [[ $REPLY =~ ^[2]$ ]]; then
        ./download-ggml-model.sh medium
        model_msg
    elif [[ $REPLY =~ ^[3]$ ]]; then
        ./download-ggml-model.sh large
        model_msg
    elif [[ $REPLY =~ ^[4]$ ]]; then
        echo -e "Not downloading a model. You can return to this menu by running:\n\t./setup.sh -m"
    else
        echo "Invalid selection, please try again."
        select_model_download
    fi

}


clear
# Navigate into the whisper.cpp directory
cd ./whisper.cpp/ || exit

# If the models flag is passed, download the models and exit
if [ "$1" == "-m" ]; then
    select_model_download
    exit 0
fi

clear
determine_gpu

if [ $BUILD_OPENCL -eq 1 ]; then
    echo "Building whisper.cpp with OpenCL GPU support via CLBlast..."
    WHISPER_CLBLAST=1 make -j
elif [ $BUILD_CUDA -eq 1 ]; then
    echo "Building whisper.cpp with NVIDIA GPU support via cuBLAS..."
    WHISPER_CUBLAS=1 make -j
else
    echo "Building whisper.cpp..."
    make
fi

read -p "Press enter to continue..."

clear
cd ./models/ || exit
select_model_download
exit 0
