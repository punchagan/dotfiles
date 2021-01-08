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

alias rsr-prod-backend='kubectx gke_akvo-lumen_europe-west1-d_production; kubectl exec $(kubectl get pods -l "run=rsr" -o jsonpath="{.items[0].metadata.name}" --field-selector=status.phase=Running) --container rsr-backend -it -- bash'
alias rsr-test-backend='kubectx gke_akvo-lumen_europe-west1-d_test; kubectl exec $(kubectl get pods -l "run=rsr" -o jsonpath="{.items[0].metadata.name}" --field-selector=status.phase=Running) --container rsr-backend -it -- bash'
alias sys-update='sudo apt update; sudo apt upgrade'
alias music='cd ~/Music; mplayer -vo null -shuffle -loop 0 *'
alias aliases='e ~/.bash_aliases'
