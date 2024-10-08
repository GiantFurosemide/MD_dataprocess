
# change here
movie_maker_output_dir="./movies"
frame_name="ABL1r_0006"
frame_step=20


echo -e "run this script in vmd to make movies. This will generate the images"
echo -e "> source make_trajectory.tcl"

echo -e "\nthen run this in bash. This will renumber the files and make the movie"
echo -e "> cd movies ; source renumber.sh ;make_movie ${frame_name}"

################################################
mkdir $movie_maker_output_dir


cat > make_trajectory.tcl << EOF
proc take_picture {args} {
  global take_picture

  # when called with no parameter, render the image
  if {\$args == {}} {
    set f [format \$take_picture(format) \$take_picture(frame)]
    # take 1 out of every modulo images
    if { [expr \$take_picture(frame) % \$take_picture(modulo)] == 0 } {
      render \$take_picture(method) \$f
      # call any unix command, if specified
      if { \$take_picture(exec) != {} } {
        set f [format \$take_picture(exec) \$f \$f \$f \$f \$f \$f \$f \$f \$f \$f]
        eval "exec \$f"
       }
    }
    # increase the count by one
    incr take_picture(frame)
    return
  }
  lassign \$args arg1 arg2
  # reset the options to their initial stat
  # (remember to delete the files yourself
  if {\$arg1 == "reset"} {
    set take_picture(frame)  0
    set take_picture(format) "${movie_maker_output_dir}/${frame_name}.%05d.ppm"
    set take_picture(method) snapshot
    set take_picture(modulo) ${frame_step}
    set take_picture(exec)    {}
    return
  }
  # set one of the parameters
  if [info exists take_picture(\$arg1)] {
    if { [llength \$args] == 1} {
      return "\$arg1 is \$take_picture(\$arg1)"
    }
    set take_picture(\$arg1) \$arg2
    return
  }
  # otherwise, there was an error
  error {take_picture: [ | reset | frame | format  | \
  method  | modulo ]}
}
# to complete the initialization, this must be the first function
# called.  Do so automatically.
take_picture reset



proc make_trajectory_movie_files {} {
	set num [molinfo top get numframes]
	# loop through the frames
	for {set i 0} {\$i < \$num} {incr i} {
		# go to the given frame
		animate goto \$i
                # force display update
                display update 
		# take the picture
		take_picture 
        }
}

# main
make_trajectory_movie_files


EOF



cat > movies/renumber.sh <<EOF
#!/bin/bash

# Directory containing your images
image_dir="./"

# Initialize the new index
new_index=0

# Loop through all .rgb files in the directory
for image in "\$image_dir"/*.ppm; do
  # Extract the base name and extension
  base_name=\$(basename "\$image" .ppm)
  
  # Format the new index with leading zeros
  formatted_index=\$(printf "%05d" \$new_index)
  
  # Construct the new file name
  new_name="\${base_name%.*}.\$formatted_index.ppm"
  
  # Rename the file
  mv "\$image" "\$image_dir/\$new_name"
  
  # Increment the new index
  new_index=\$((new_index + 1))
done

echo "Files renumbered successfully!"

EOF

################################################


echo -e "run this script in vmd to make movies"
echo -e "> source make_trajectory.tcl"

echo -e "\nthen run this in bash"
echo -e "> cd movies ; source renumber.sh ;make_movie ${frame_name}"