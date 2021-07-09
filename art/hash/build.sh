INPUT_FILE=$1
OBJECT_CODE=$2
OUTPUT_FILE=$3

TMP_DIR=tmp_${OBJECT_CODE}
mkdir -p $TMP_DIR
TMP_HASH_FILE=${TMP_DIR}/hash.mp4

SIZE=$(wc -c $INPUT_FILE | awk -F " " '{print $1}')

cp $INPUT_FILE $TMP_HASH_FILE
FOUND=$(sha1sum $TMP_HASH_FILE | awk -F ' ' '{print $1}' | grep -E "^${OBJECT_CODE}")

while [ -z $FOUND ];
do
	RND=$(cat /dev/urandom | base64 | head -c 128)
	ffmpeg -i $INPUT_FILE -codec copy -metadata comment="$RND" -y $TMP_HASH_FILE 2> /dev/null
   FOUND=$(sha1sum $TMP_HASH_FILE | awk -F ' ' '{print $1}' | grep -E "^${OBJECT_CODE}")
done

cp $TMP_HASH_FILE $OUTPUT_FILE
rm -rf $TMP_DIR
