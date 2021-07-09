#!/bin/bash

BLIP_FILE=$1
OBJECT_CODE=$2
OUTPUT_FILE=$3

PAD_FILE=$(ls pads/* | sort -u | sed -n "$OBJECT_CODE p")

echo $PAD_FILE

TMP_DIR=tmp_${OBJECT_CODE}
mkdir -p $TMP_DIR

MIXED_BLIP=${TMP_DIR}/blip_m${OBJECT_CODE}.flac
MIXED_PAD=${TMP_DIR}/pad_m${OBJECT_CODE}.flac

ffmpeg -i ${BLIP_FILE} -filter:a "volume=0.5" -y ${MIXED_BLIP}
ffmpeg -i ${PAD_FILE} -filter:a "volume=1.0" -y ${MIXED_PAD}
ffmpeg -i ${MIXED_PAD} -i ${MIXED_BLIP} -filter_complex amix=inputs=2:duration=shortest -y ${OUTPUT_FILE}


rm -rf $TMP_DIR
