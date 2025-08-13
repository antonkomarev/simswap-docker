#!/bin/bash

# Usage:
# sh swap-face.sh <source_file_name> <target_file_name> [--crop_size=<crop_size>]
#
# Example:
# sh swap-face.sh source.jpg target.mp4 --crop_size=224

# Asserting arguments
if [ "$#" -lt 2 ] || [ "$#" -gt 3 ]; then
  echo "Usage: $0 <source_file_name> <target_file_name> [--crop=<crop_size>]"
  exit 1
fi

# Assigning variables
sourcefile=$1
targetfile=$2
crop_size=224 # Default crop size

# Check if the third argument is provided and starts with "--crop_size="
if [ "$#" -eq 3 ] && [[ $3 == --crop_size=* ]]; then
  crop_size=${3#--crop_size=}
fi

CURRENT_TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)

docker exec -it simswap \
  /opt/conda/envs/simswap/bin/python test_video_swapsingle.py \
    --isTrain false \
    --name people \
    --no_simswaplogo \
    --use_mask \
    --crop_size $crop_size \
    --Arc_path arcface_model/arcface_checkpoint.tar \
    --pic_a_path /home/input/$sourcefile \
    --video_path /home/input/$targetfile \
    --output_path /home/output/$CURRENT_TIMESTAMP.mp4 \
    --temp_path ./temp_results
