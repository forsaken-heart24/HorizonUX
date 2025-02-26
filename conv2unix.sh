# go fucking learn shit if you dont know what these does.

# force users to install dos2unix.
if [ -z "$(command -v dos2unix)" ]; then
    echo " - Please install dos2unix to proceed..."
    sleep 2
    exit 1
fi

# let's convert these script files.
for i in *; do 
    for j in "$(find ${i})"; do
        echo "$j" | grep -q .git || dos2unix "${j}"
    done
done