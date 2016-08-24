#!/bin/bash
# A script to create a one-off Public Jupyter Notebook server

PASSWORD=$(date +%N|md5sum|head -c 16)
echo "Use ${PASSWORD} as password"

# Create a new venv
DIR=$(mktemp -d)
echo $DIR
virtualenv -p python3 $DIR
source $DIR/bin/activate

# Install Jupyter
pip install jupyter

# Set password for jupyter
PASSWD=$(python -c 'from notebook.auth import passwd; print(passwd("'"${PASSWORD}"'"))')
echo "c.NotebookApp.password = u'${PASSWD}'" > $DIR/conf.py

# Create keys
openssl req -x509 -nodes -days 365 -newkey rsa:1024 -keyout $DIR/mykey.key -out $DIR/mycert.pem -subj "/C=US/ST=New York/L=New York City/O=Dis/CN=www.example.com"

# Start server
echo "Use ${PASSWORD} as password"
jupyter notebook --no-browser --config $DIR/conf.py --certfile=$DIR/mycert.pem --keyfile $DIR/mykey.key --ip=0.0.0.0

rm -rf $DIR
