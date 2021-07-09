#!/bin/bash

INPUT_FILE_VIDEO=$1
INPUT_FILE_AUDIO=$2
OBJECT_CODE=$3
OUTPUT_FILE=$4

TMP_DIR=${OBJECT_CODE}_tmp
mkdir -p $TMP_DIR

# Compose audio and video with fades
ffmpeg -i $INPUT_FILE_VIDEO -vf "fade=in:0:50, fade=out:350:50" -y ${TMP_DIR}/fade.mp4
ffmpeg -i ${TMP_DIR}/fade.mp4 -i $INPUT_FILE_AUDIO -af "afade=t=in:st=0:d=5,afade=t=out:st=10:d=10" -map 0:v -map 1:a -c:v copy -shortest -y ${TMP_DIR}/composition.mp4

# Normalize loudness
ffmpeg -i ${TMP_DIR}/composition.mp4 -af loudnorm=I=-23:LRA=7:tp=-2:print_format=json -f null - 2> ${TMP_DIR}/output.json
eval "$(cat ${TMP_DIR}/output.json | tail -12 | jq -r ' to_entries | .[] | .key + "=\"" + .value + "\""')"
ffmpeg -i ${TMP_DIR}/composition.mp4 -af loudnorm=I=-23:LRA=7:tp=-2:measured_I=${output_i}:measured_LRA=${output_lra}:measured_tp=${output_tp}:measured_thresh=${output_thresh}:offset=${target_offset} -ar 48k -y ${TMP_DIR}/norm.mp4

# Metadata
ffmpeg -i ${TMP_DIR}/norm.mp4 -codec copy -metadata artist="Inner Space" -metadata album="Messier Collection" -y $OUTPUT_FILE



rm -rf $TMP_DIR
