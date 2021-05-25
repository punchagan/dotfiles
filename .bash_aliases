PHONE_IP=192.168.0.195

alias phone="adb connect \$PHONE_IP:5555; scrcpy"

yt-video-to-phone () {
    DIR=$(mktemp -d)
    pushd "$DIR" || exit;
    youtube-dl --continue --output "%(title)s-%(id)s.%(ext)s" "$1";
    adb connect $PHONE_IP:5555;
    adb push -- * "/sdcard/Videos";
    mv ./* "${HOME}/Music/Uke-Songs/"
    popd || exit;
}

yt-audio-to-phone () {
    DIR=$(mktemp -d)
    pushd "$DIR" || exit;
    youtube-dl --extract-audio --audio-format "best" --continue \
        --output "%(title)s-%(id)s.%(ext)s" "$1";
    adb connect $PHONE_IP:5555;
    adb push -- * "/sdcard/Music";
    mv ./* "${HOME}/Music/"
    popd || exit;
}

alias rsr-prod-backend='kubectx gke_akvo-lumen_europe-west1-d_production; kubectl exec $(kubectl get pods -l "run=rsr" -o jsonpath="{.items[0].metadata.name}" --field-selector=status.phase=Running) --container rsr-backend -it -- bash'
alias rsr-test-backend='kubectx gke_akvo-lumen_europe-west1-d_test; kubectl exec $(kubectl get pods -l "run=rsr" -o jsonpath="{.items[0].metadata.name}" --field-selector=status.phase=Running) --container rsr-backend -it -- bash'
alias sys-update='sudo apt update; sudo apt upgrade'
alias music='cd ~/Music; mplayer -vo null -shuffle -loop 0 *'
alias aliases='e ~/.bash_aliases'
alias rpi='mosh pi@rpi.local'

function mongo-start () {
    docker run -d -p 27017:27017 -v $PWD/data/mongodb:/data/db mongo
}

# Phone backup mount
alias mount-phone-backup='sshfs pi@rpi.local:/mnt/backup-drive/PhoneBackup/ ~/PhoneBackup/'
alias unmount-phone-backup='fusermount -u /home/punchagan/PhoneBackup'

# Remove some bash_it aliases
unalias gh