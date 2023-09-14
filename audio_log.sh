#!/bin/bash

check_whisper()
{
    # Check if whisper.cpp/main exists
    if [ ! -f whisper.cpp/main ]; then
        echo "whisper.cpp/main not found!"
        echo "Please build whisper.cpp first by running setup.sh or manually following whisper.cpp/README.md"
        exit 1
    fi
}

select_model(){
    # For every .bin file in whisper.cpp/models, excluding those which contain "test", print the filename
    # and increment the count
    count=0
    for file in whisper.cpp/models/*.bin; do
        if [[ ! "$file" =~ "test" ]]; then
            echo "$count. $(basename "$file")"
            count=$((count+1))
        fi
    done

    if [ $count -eq 0 ]; then
        echo -e "No models were found, please run\n\tsetup.sh -m\nto download a model."
        exit 1
    fi


    read -p "Which model do you want to use? " -n 1 -r
    echo
    # If the input is a number, use that as the index
    if [[ $REPLY =~ ^[0-9]$ ]]; then
        # Get the filename of the model at the index
        model=$(ls whisper.cpp/models/*.bin | sed -n "$((REPLY+1))p")
        echo "Using $model"
    else
        echo "Invalid selection, please try again."
        select_model
    fi

}

check_whisper
select_model
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
