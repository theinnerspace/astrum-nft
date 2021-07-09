#!/bin/bash

INPUT_FILE=$1
OBJECT_CODE=$2
OUTPUT_FILE=$3
TMP_DIR=${OBJECT_CODE}_tmp

mkdir -p $TMP_DIR 

BLIP_FILE=$(python sound.py $INPUT_FILE $TMP_DIR)

if [ -z $REVERB ]
then
	REVERB=medium_ambience.aif
fi

# Equalize
ffmpeg -i $BLIP_FILE -af "equalizer=f=10000:width_type=h:width=5000:g=-14,equalizer=f=650:width_type=h:width=200:g=-14" -y ${TMP_DIR}/eq.flac

# Reverberate
ffmpeg -i ${TMP_DIR}/eq.flac -i $REVERB  -filter_complex '[0] [1] afir=dry=10:wet=10 [reverb]; [0] [reverb] amix=inputs=2:weights=10 5, lowpass=f=3200' -y ${TMP_DIR}/reverb.flac

mv ${TMP_DIR}/reverb.flac $OUTPUT_FILE
rm -rf $TMP_DIR
