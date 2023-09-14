# audio-log
Using voice transcription to create easily recorded audio logs

## Setup

```git clone https://github.com/Chopper1337/audio-log
cd audio-log
./setup.sh
```

## Usage

To create an entry, simply run `./audio_log.sh`

If you wish to use a model other than the default `ggml-small.bin`:

Run `./setup.sh -m` to download skip to the model download menu and select your model

Then run `audio_log.sh` followed by the name of the model, example:

`./audio_log.sh ggml-large.bin`
