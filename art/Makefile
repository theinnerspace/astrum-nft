IMAGES_DIR ?= images
OBJECT_CODE ?= 42
IMAGE_FILE ?= ${IMAGES_DIR}/M${OBJECT_CODE}.jpg

OBJECTS_FILE ?= objects.txt
OBJECTS = $(shell cat ${OBJECTS_FILE})

BUILD_DIR ?= build
OUTPUT_DIR_BLIPS ?= ${BUILD_DIR}/art/blips
OUTPUT_DIR_AUDIO ?= ${BUILD_DIR}/art/audios
OUTPUT_DIR_VIDEO ?= ${BUILD_DIR}/art/videos
OUTPUT_DIR_COMPOSITION ?= ${BUILD_DIR}/art/composition
OUTPUT_DIR_HASHED ?= ${BUILD_DIR}/art/hashed

BLIP_FILE = ${OUTPUT_DIR_BLIPS}/M${OBJECT_CODE}.flac
AUDIO_FILE = ${OUTPUT_DIR_AUDIO}/M${OBJECT_CODE}.flac
VIDEO_FILE = ${OUTPUT_DIR_VIDEO}/M${OBJECT_CODE}.mp4
COMPOSITION_FILE = ${OUTPUT_DIR_COMPOSITION}/M${OBJECT_CODE}.mp4
HASHED_FILE = ${OUTPUT_DIR_HASHED}/M${OBJECT_CODE}.mp4

dummy:
	echo "dummy"

${BLIP_FILE}:
	mkdir -p ${OUTPUT_DIR_BLIPS}
	cd blips && /bin/bash build.sh ../${IMAGE_FILE} ${OBJECT_CODE} ../${BLIP_FILE}

blip: ${BLIP_FILE}
	echo "blip created"

${AUDIO_FILE}: blip
	mkdir -p ${OUTPUT_DIR_AUDIO}
	cd audio && /bin/bash build.sh ../${BLIP_FILE} ${OBJECT_CODE} ../${AUDIO_FILE}

audio: ${AUDIO_FILE}
	echo "audio created"

${VIDEO_FILE}:
	mkdir -p ${OUTPUT_DIR_VIDEO}
	cd video && /bin/bash build.sh ../${IMAGE_FILE} ${OBJECT_CODE} ../${VIDEO_FILE}

video: ${VIDEO_FILE}
	echo "video created"

${COMPOSITION_FILE}: audio video
	mkdir -p ${OUTPUT_DIR_COMPOSITION}
	cd composition && /bin/bash build.sh ../${VIDEO_FILE} ../${AUDIO_FILE} ${OBJECT_CODE} ../${COMPOSITION_FILE}

composition: ${COMPOSITION_FILE}
	echo "composition ${COMPOSITION_FILE} created"

${HASHED_FILE}: composition
	mkdir -p ${OUTPUT_DIR_HASHED}
	cd hash && /bin/bash build.sh ../${COMPOSITION_FILE} ${OBJECT_CODE} ../${HASHED_FILE}

hash: ${HASHED_FILE}
	echo "hash created"

nft: hash
	echo "Built final NFT for M${OBJECT_CODE}"

clean_blip:
	rm -f ${BLIP_FILE}

clean_audio:
	rm -f ${AUDIO_FILE}

clean_video:
	rm -f ${VIDEO_FILE}

clean_composition:
	rm -f ${COMPOSITION_FILE}

clean_hash:
	rm -f ${HASHED_FILE}

clean_nft: clean_blip clean_blip clean_video clean_composition clean_hash
	@echo "Cleaned NFT for M${OBJECT_CODE}"

# from https://stackoverflow.com/questions/1490949/how-to-write-loop-in-a-makefile

# Bulk build
BLIP_JOBS := $(addprefix blip_,${OBJECTS})
.PHONY_BLIP: all_blip ${BLIP_JOBS}
all_blip: ${BLIP_JOBS} ; echo "$@ success"
${BLIP_JOBS}: blip_%: ; make blip -e OBJECT_CODE=$*

AUDIO_JOBS := $(addprefix audio_,${OBJECTS})
.PHONY_AUDIO: all_audio ${AUDIO_JOBS}
all_audio: ${AUDIO_JOBS} ; echo "$@ success"
${AUDIO_JOBS}: audio_%: ; make audio -e OBJECT_CODE=$*

VIDEO_JOBS := $(addprefix video_,${OBJECTS})
.PHONY_VIDEO: all_video ${VIDEO_JOBS}
all_video: ${VIDEO_JOBS} ; echo "$@ success"
${VIDEO_JOBS}: video_%: ; make video -e OBJECT_CODE=$*

COMPOSITION_JOBS := $(addprefix composition_,${OBJECTS})
.PHONY_COMPOSITION: all_composition ${COMPOSITION_JOBS}
all_composition: ${COMPOSITION_JOBS} ; echo "$@ success"
${COMPOSITION_JOBS}: composition_%: ; make composition -e OBJECT_CODE=$*

HASH_JOBS := $(addprefix hash_,${OBJECTS})
.PHONY_HASH: all_hash ${HASH_JOBS}
all_hash: ${HASH_JOBS} ; echo "$@ success"
${HASH_JOBS}: hash_%: ; make hash -e OBJECT_CODE=$*

NFT_JOBS := $(addprefix nft_,${OBJECTS})
.PHONY_NFT: all_nft ${NFT_JOBS}
all_nft: ${NFT_JOBS} ; echo "$@ success"
${NFT_JOBS}: nft_%: ; make nft -e OBJECT_CODE=$*

# Bulk clean
CLEAN_BLIP_JOBS := $(addprefix clean_blip_,${OBJECTS})
.PHONY_CLEAN_BLIP: clean_all_blip ${CLEAN_BLIP_JOBS}
clean_all_blip: ${CLEAN_BLIP_JOBS} ; echo "$@ success"
${CLEAN_BLIP_JOBS}: clean_blip_%: ; make clean_blip -e OBJECT_CODE=$*

CLEAN_AUDIO_JOBS := $(addprefix clean_audio_,${OBJECTS})
.PHONY_CLEAN_AUDIO: clean_all_audio ${CLEAN_AUDIO_JOBS}
clean_all_audio: ${CLEAN_AUDIO_JOBS} ; echo "$@ success"
${CLEAN_AUDIO_JOBS}: clean_audio_%: ; make clean_audio -e OBJECT_CODE=$*

CLEAN_VIDEO_JOBS := $(addprefix clean_video_,${OBJECTS})
.PHONY_CLEAN_VIDEO: clean_all_video ${CLEAN_VIDEO_JOBS}
clean_all_video: ${CLEAN_VIDEO_JOBS} ; echo "$@ success"
${CLEAN_VIDEO_JOBS}: clean_video_%: ; make clean_video -e OBJECT_CODE=$*

CLEAN_COMPOSITION_JOBS := $(addprefix clean_composition_,${OBJECTS})
.PHONY_CLEAN_COMPOSITION: clean_all_composition ${CLEAN_COMPOSITION_JOBS}
clean_all_composition: ${CLEAN_COMPOSITION_JOBS} ; echo "$@ success"
${CLEAN_COMPOSITION_JOBS}: clean_composition_%: ; make clean_composition -e OBJECT_CODE=$*

CLEAN_HASH_JOBS := $(addprefix clean_hash_,${OBJECTS})
.PHONY_CLEAN_HASH: clean_all_hash ${CLEAN_HASH_JOBS}
clean_all_hash: ${CLEAN_HASH_JOBS} ; echo "$@ success"
${CLEAN_HASH_JOBS}: clean_hash_%: ; make clean_hash -e OBJECT_CODE=$*

CLEAN_NFT_JOBS := $(addprefix clean_nft_,${OBJECTS})
.PHONY_CLEAN_NFT: clean_all_nft ${CLEAN_NFT_JOBS}
clean_all_nft: ${CLEAN_NFT_JOBS} ; echo "$@ success"
${CLEAN_NFT_JOBS}: clean_nft_%: ; make clean_nft -e OBJECT_CODE=$*
