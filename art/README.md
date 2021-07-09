# Astrunz
## Art pipeline
### Requirements

* python 3.7+ and pip
    * then `pip install -r requirements.txt`
* ffmpeg
* image-magik
* pippi (python library, install from github repo, not pip) -> should be installed automatically with the requirements. Else:
    * `git clone https://github.com/luvsound/pippi.git`
    * `cd pippi && make install`

## Build NFT
Always specify the object code that you would like to generate. So for M42, you should set the environment with
`OBJECT_CODE=42`
or run the make command with the `-e` flag, like:
`make audio -e OBJECT_CODE=42`

To run each build step on a bulk of objects, you have to prepend `all_` to the make command. Alos: you should make a txt file containing the objects you want to process, just the numbers, one per line. If the file is named anything else than `objects.txt` in the root directory, then you have to pass the env `OBJECTS_FILE` with the location. Full example:
```
# Make audio for 42,43,46
echo -e "42\n43\n46" > my_objects.txt
make all_audio -e OBJECTS_FILE=my_objects.txt

# Make full nft with 1,2,3 and standard objects file
echo -e "1\n2\n3" > objects.txt
make all_nft
```

To specify a different image folder, set the following env variable
`IMAGES_DIR=/your/path`

You will find the output of the make command inside the `build/art` folder.

### Blips
Generate equalized and reverberated blips from image(s):
```
# One object
make blip

# Multiple objects
make all_blip
```

### Audio
Generate full audio, blips and pads mixed together, from image(s):
```
# One object
make audio

# Multiple objects
make all_audio
```


### Video
Generate mute video without transition effects from image(s):
```
# One object
make video

# Multiple objects
make all_video
```

### Composition
Generate video+audio composition, with transition effects (like fade in/out etc) and loudness normalization:
```
# One object
make composition

# Multiple objects
make all_composition
```

### Hash magic
Fiddle with the composition bits until its sha1sum ends with the object code:
```
# One object
make hash

# Multiple objects
make all_hash
```
ATTENTION: check the results once its finished. If the wrong bit is flipped, the video might result damaged and you need to retry.

### The whole NFT
Everything described above.
```
# One object
make nft

# Multiple objects
make all_nft
```

## Cleaning
Same logic as above, just prepend `clean_` to the build you want to clean. Example:
```
make clean_audio
make clean_all_audio
```

## Docker way
Login
```
docker login -u triumvirato
password: <redacted, check channel>
```

Pull the right image
```
docker pull triumvirato/messier-collection:latest
```
Then use basically the same commands, but mounting the images and build directory from your local host:
```
# Generate blip for object 42
docker run -v /path/to/your/images:/app/images -v /path/to/your/build:/app/build messier_collection blip -e OBJECT_CODE=43

# Generate audio for objects 32,31,30
echo -e "32\n31\n30" > /path/to/your/images/objects.txt
docker run -v /path/to/your/images:/app/images -v /path/to/your/build:/app/build messier_collection all_blip -e OBJECTS_FILE=images/objects.txt
```

Find the generated stuff inside `/path/to/your/build`of your host.
