# SimSwap Docker

Quick start to run [neuralchen/SimSwap](https://github.com/neuralchen/SimSwap) in a Docker container. By default, it is configured to use only the CPU.

## Disclaimer

I have no plans to improve this project in any way. It was created solely for my research purposes, as there was no ready-to-use Docker image with SimSwap available, so I decided to create one.

## Installation

You must have Docker installed on your host machine.

```shell
git clone https://github.com/antonkomarev/simswap-docker.git
cd simswap-docker
sh fetch-simswap-include.sh
docker compose build
```

## Usage

### Run container

```shell
docker compose up -d
```

### Process data

1. Put source image and target video files in `./input` directory
2. Run swap-face bash script `sh swap-face.sh <source_image_file_name> <target_video_file_name>`
3. Check output video in `./output` directory

#### Example

Take person's face from `example/example-source.jpg` image and replace person's face in `example/example-target.mp4` video.

```shell
cp example/example-source.jpg example/example-target.mp4 input/
sh swap-face.sh example-source.jpg example-target.mp4
```

### Advanced usage

If the default settings do not meet your needs, you can modify them in the `swap-face.sh` file.
The [official SimSwap usage guide](https://github.com/neuralchen/SimSwap/blob/main/docs/guidance/usage.md) is available for reference.

#### Crop size

Default crop size is 224. You can modify crop size by passing `--crop_size=512` argument to the console command.
The results can vary: sometimes they are better, sometimes worse.

```shell
sh swap-face.sh <source_image_file_name> <target_video_file_name> --crop_size=512
```

## Cut long video

If you have long video, but you need only part of it, you can use simple video cutter bash script.
It requires `ffmpeg` installed on your host machine.

```shell
sh cut-video.sh <input_file_path> <output_file_path> <start_time> <duration>
```

- `start_time` should be in format HH:MM:SS
- `duration` should be in seconds

#### Example

Cut 10 seconds of the `input/full.mp4` video from the 1st minute and have result in `input/cutted.mp4`.

```shell
sh cut-video.sh input/full.mp4 input/cutted.mp4 00:01:00 10
```
