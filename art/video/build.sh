#!/bin/bash

INPUT_FILE=$1
OBJECT_CODE=$2
OUTPUT_FILE=$3

TMP_DIR=tmp_${OBJECT_CODE}
mkdir -p $TMP_DIR

width=$(convert $INPUT_FILE -ping -format "%w" info:)
height=$(convert $INPUT_FILE -ping -format "%h" info:)
shortest=$width
if [ $width -gt $height ]
then
   shortest=$height
fi

if [ $shortest -gt 3000 ]
then
   shortest=3000
fi

radius=$(expr $shortest / 2)
shortest=$(echo $radius' * 2' | bc) # ffmpeg fucks up with odd images sizes

convert $INPUT_FILE -resize ${shortest}x${shortest} ${TMP_DIR}/square.jpeg
#convert $INPUT_FILE -gravity center -crop ${shortest}x${shortest}+0+0 +repage ${TMP_DIR}/square.jpeg
mogrify -format png ${TMP_DIR}/square.jpeg

convert -size ${shortest}x${shortest} xc:black -fill white -draw 'circle '$radius','$radius' '$radius',5' -blur 0x8 ${TMP_DIR}/write_mask_fg_blur.png

cp ${TMP_DIR}/square.png ${TMP_DIR}/astro_rotate_100.png
convert ${TMP_DIR}/astro_rotate_100.png ${TMP_DIR}/write_mask_fg_blur.png -alpha Off -compose CopyOpacity -composite ${TMP_DIR}/tmp.png
convert ${TMP_DIR}/tmp.png -background black -alpha remove -alpha off ${TMP_DIR}/astro_rotate_100.png
cp ${TMP_DIR}/astro_rotate_100.png ${OUTPUT_FILE}.preview.png

for i in {100..1}
do
   progress=$(echo 'scale=3; '$i' / 100' | bc)
   arg=$(echo 'scale=3; 1 - '$progress | bc)
   power=$(echo 'scale=3; '$arg'^3' | bc)
   change=$(echo 'scale=3; 1 - '$power | bc)
   next=`expr $i - 1`
   convert ${TMP_DIR}/astro_rotate_$i.png -distort SRT 0$power ${TMP_DIR}/astro_rotate_$next.png 
   convert ${TMP_DIR}/astro_rotate_$next.png ${TMP_DIR}/write_mask_fg_blur.png -alpha Off -compose CopyOpacity -composite ${TMP_DIR}/tmp_file.png
   convert ${TMP_DIR}/tmp_file.png -background black -alpha remove -alpha off ${TMP_DIR}/astro_rotate_$next.png
done

ffmpeg -framerate 20 -i ${TMP_DIR}/astro_rotate_%d.png -pix_fmt yuv420p -vf "tpad=stop_mode=clone:stop_duration=15" $OUTPUT_FILE

rm -rf $TMP_DIR
