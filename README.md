# audio-log
Using voice transcription to easily create audio logs

## Setup

Please be sure you meet the requirements to run [whisper.cpp](https://github.com/ggerganov/whisper.cpp)!

```
git clone https://github.com/Chopper1337/audio-log --recursive
cd audio-log
./setup.sh
```

## Usage

### Create an entry

`./audio_log.sh`

This will create a folder named for the current date, such as `20230914_231509`, this will contain your recorded audio file and the transcription.

### Download different models

`./setup.sh -m`

