# 0. adjust display size to even number in VMD console
#> display resize 800 800

# 1. generate ppm files by in VMD
#
# Renderer:Select Snapshot(screen capture)
# Movie settings: select 'trajectory'; unselect 'delete image files'
# Format: no matter what to select, we will use another command
# set out_movie_name 

# 2. merge ppm files to one movie by ffmpeg
# time duration = frames / frame rate
# example: 251 frames, 25 frames per second, 251/25=10.04s movies will be generated

# (recommanded)
# decoder 'prores' for macos and ubuntu
# -csf [0-51]: 0 lossless 23 default 51 worst quality
out_movie_name='3imn_CYP'
ffmpeg -an -i ./${out_movie_name}.%05d.ppm -r 25 -c:v prores -crf 0  ${out_movie_name}_r25.mov
#ffmpeg -an -i ./${out_movie_name}.%05d.ppm -r 25 -c:v prores -crf 0  ${out_movie_name}_r25.mp4

# OR
# decoder 'libx264' for ubuntu, but not mac os
ffmpeg -an -i ./${out_movie_name}.%05d.ppm -r 25 -c:v libx264 -crf 0  ${out_movie_name}_r25.mov
