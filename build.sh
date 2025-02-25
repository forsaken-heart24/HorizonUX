# nuke the old log file.
rm -rf ./error_ring.log
TMPDIR=$(mktemp --tmpdir=.)

# check if mentioned files do exist or not.
chmod +x ./misc/build_scripts/setup.sh
./misc/build_scripts/setup.sh

# fuck this fucking directory before it fucking fucks up the fucking use cases man, fuck this fucking bullshit that i have to fuck with
# hope this fucking shit ends fucking soon.
rm -rf $TMPDIR