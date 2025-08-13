#!/bin/bash

# Usage:
# sh fetch-simswap-include.sh

# URLs and local destinations
files_and_dirs=(
    "https://github.com/neuralchen/SimSwap/releases/download/1.0/arcface_checkpoint.tar ./simswap-include/arcface_model"
    "https://github.com/neuralchen/SimSwap/releases/download/512_beta/512.zip ./simswap-include/checkpoints"
    "https://github.com/neuralchen/SimSwap/releases/download/1.0/checkpoints.zip ./simswap-include/checkpoints"
    "https://github.com/antonkomarev/simswap-docker/releases/download/0.1.0/antelope.zip ./simswap-include/insightface_func/models"
    "https://github.com/neuralchen/SimSwap/releases/download/1.0/79999_iter.pth ./simswap-include/parsing_model/checkpoint"
)

download_and_process() {
    local url="$1"
    local target_dir="$2"

    mkdir -p "$target_dir"

    local filename=$(basename "$url")
    local filepath="$target_dir/$filename"

    echo "Downloading $url в $filepath..."
    curl -L -o "$filepath" "$url"

    if [[ "$filename" == *.zip ]]; then
        echo "Unpacking $filepath into $target_dir..."
        unzip -o "$filepath" -d "$target_dir"
        rm "$filepath"
    fi
}

for entry in "${files_and_dirs[@]}"; do
    # Splitting string into URL and directory
    url=$(echo "$entry" | awk '{print $1}')
    target_dir=$(echo "$entry" | awk '{print $2}')
    download_and_process "$url" "$target_dir"
done

echo "Downloading and unzipping models & weights completed."
