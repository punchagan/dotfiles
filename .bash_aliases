PHONE_IP=192.168.0.195

alias phone="adb connect \$PHONE_IP:5555; scrcpy"

alias rsvp-docker='docker run -d -p 27017:27017 -v ~/software/thatte-idli/rsvpapp/data/mongodb:/data/db mongo'

yt-to-phone () {
    DIR=$(mktemp -d)
    pushd "$DIR" || exit;
    youtube-dl --continue --output "%(title)s-%(id)s.%(ext)s" "$1";
    adb connect $PHONE_IP:5555;
    adb push -- * "/sdcard/Videos";
    popd || exit;
}
