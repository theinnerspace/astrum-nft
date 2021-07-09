from pippi import tune, dsp, noise, fx
from pippi.sineosc import SineOsc
import numpy as np
import random
from processor import load_centers
import sys

image_name = sys.argv[1]
output_dir = sys.argv[2]

centers, sizes = load_centers(image_name)

sizes_norm = (sizes - sizes.min()) / (sizes.max() - sizes.min())

big_size = np.quantile(sizes_norm, q=0.99)

height = centers[:, 1].max()
width = centers[:, 0].max()

col_size = 100
star_positions = [0]
star_sizes = [0]
for col in range(0, int(int(width) / col_size) + 1):
    condition = (centers[:, 0] >= col * col_size) & (
        centers[:, 0] < col_size + col_size * col
    )
    new_stars = centers[condition]
    new_sizes = sizes_norm[condition]
    star_positions += list(map(lambda x: x[1] + star_positions[-1], new_stars))
    star_sizes += list(new_sizes)

sort_condition = np.argsort(star_positions)
star_positions = list(
    np.take_along_axis(np.array(star_positions), sort_condition, axis=0)
)
star_sizes = list(np.take_along_axis(
    np.array(star_sizes), sort_condition, axis=0))

stars_length = star_positions[-1]
elapsed = 0

next_star = star_positions.pop(0)
next_size = star_sizes.pop(0)

keys = [
    "A",
    "B",
    "C",
    "D",
    "E",
    "F",
    "G",
    "A#",
    "B#",
    "C#",
    "D#",
    "E#",
    "F#",
    "G#",
    "Ab",
    "Bb",
    "Cb",
    "Db",
    "Eb",
    "Fb",
    "Gb",
]
big_key = random.choice(keys)
big_freqs = np.array(
    [tune.chord("i", key=big_key, octave=oct, ratios=tune.JUST)
     for oct in range(1, 2)]
).flatten()

small_key = random.choice(keys)
small_freqs = np.array(
    [
        tune.chord("I", key=small_key, octave=oct, ratios=tune.JUST)
        for oct in range(4, 6)
    ]
).flatten()

big_freq = random.choice(big_freqs)
small_freq = random.choice(small_freqs)

beat = 0.1
song_length = 20
out = dsp.buffer(length=song_length)
position = 0

MAX_DROPOUT = 0.999
dropout = 0


blip = dsp.read("blip2.wav")
original_freq = tune.ntf("C3")  # tune.ntf("A#3")

big_speed = big_freq / original_freq
small_speed = small_freq / original_freq

while elapsed < stars_length:

    if next_size >= big_size:
        note_length = dsp.rand(0.6, 1.5)
        freq = big_freq
        speed = big_speed
    else:
        note_length = dsp.rand(0.2, 0.5)
        freq = small_freq
        speed = small_speed

    while next_star == elapsed:
        if random.random() >= dropout or next_size >= big_size:
            sound = blip.speed(speed)
            sound = sound.cut(0, note_length)
            if speed == big_speed:
                sound = sound.adsr(
                    d=dsp.rand(0.1, 0.3),  # Decay between 100ms and 300ms
                    r=dsp.rand(1, 2)       # Release between 1 and 2 seconds*
                )
                sound = sound & sound.speed(2).pad(dsp.rand(0, 0.05))

            out.dub(
                sound,
                song_length / stars_length * elapsed,
            )
            dropout = MAX_DROPOUT
        if len(star_positions) == 0:
            elapsed = stars_length - 1
        else:
            next_star = star_positions.pop(0)
            next_size = star_sizes.pop(0)
    elapsed = elapsed + 1
    dropout = dropout * dropout

# out = fx.lpf(out, 3000) * 0.5
# print(f"{image_name} big {big_freq} small {small_freq}")
out.write(f'{output_dir}/{image_name.split("/")[-1].split(".")[0]}.flac')
print(f'{output_dir}/{image_name.split("/")[-1].split(".")[0]}.flac')
