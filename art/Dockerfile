FROM python:3.8-slim

RUN apt-get update && apt-get --yes --force-yes install sudo libjack-dev imagemagick ffmpeg git build-essential pkg-config libasound2-dev bc

RUN mkdir -p /app /app/build/art /app/images
COPY requirements.txt /app
RUN pip install --upgrade pip
RUN git clone https://github.com/luvsound/pippi.git && cd pippi && make install
RUN pip install -r /app/requirements.txt

RUN ffmpeg -version

RUN apt-get install wget && wget https://johnvansickle.com/ffmpeg/builds/ffmpeg-git-amd64-static.tar.xz && \
	tar xvf ffmpeg*.xz && \ 
	cd ffmpeg-*-static && \
	ln -s "${PWD}/ffmpeg" /usr/local/bin/ && \
 	ln -s "${PWD}/ffprobe" /usr/local/bin/

RUN apt-get -y install jq

RUN mkdir build
COPY objects.txt /app
COPY Makefile /app
COPY blips /app/blips
COPY audio /app/audio
COPY video /app/video
COPY composition /app/composition
COPY hash /app/hash

WORKDIR app
ENTRYPOINT ["make"]
