# install

Guide to installing the coturn server for STUN/TURN on a fresh box

## nginx + certbot

```bash

# setup nginx to serve hello page
sudo apt install nginx

# move in nginx conf
sudo cp setup/nginx_starter.conf /etc/nginx/sited-enabled/default

# (optional firewall stuff) confirm Nginx Full is listed, then allow it
sudo ufw app list
sudo ufw allow 'Nginx Full'
sudo ufw status

# install snap, then certbot
sudo snap install core; sudo snap refresh core
sudo snap install --classic certbot
sudo ln -s /snap/bin/certbot /usr/bin/certbot
sudo certbot --nginx

# OPTIONAL: to renew later on
sudo certbot renew --dry-run

```

## coturn

```bash

# install
sudo apt-get -y update
sudo apt-get install coturn

# installing auto-starts, shut that shit down
systemctl stop coturn

# uncomment the TURNSERVER_ENABLED line to enable TURN
sudo vi /etc/default/coturn

# Move the original turnserver configuration file to a backup in the same directory
sudo mv /etc/turnserver.conf /etc/turnserver.conf.original

# Copy/paste setup/turnserver.conf
sudo cp setup/turnserver.conf /etc/turnserver.conf

# create folder for turnserver certs
mkdir -p /etc/coturn/certs
chown -R turnserver:turnserver /etc/coturn/
chmod -R 700 /etc/coturn/

# set certbot hooks to provide accessible certs to turnserver
# copy/paste the contents of coturn-certbot-deploy.sh
cp setup/coturn-certbot-deploy.sh /etc/letsencrypt/renewal-hooks/deploy/coturn-certbot-deploy.sh
chmod 700 /etc/letsencrypt/renewal-hooks/deploy/coturn-certbot-deploy.sh

# start coturn
sudo systemctl restart coturn

# ensure both 3478 and 5349 are listening
sudo lsof -i -P -n | grep turnserver

```

## debugging

- [coturn config docs](https://github.com/coturn/coturn/blob/master/examples/etc/turnserver.conf)
- [online tool to test STUN/TURN endpoints](https://webrtc.github.io/samples/src/content/peerconnection/trickle-ice/)
- [certbot docs about permissions](https://eff-certbot.readthedocs.io/en/stable/using.html#where-are-my-certificates)
- [Fixing with certbot hook](https://serverfault.com/a/984575)
- [Fixing with certbot override](https://community.jitsi.org/t/tip-coturn-certbot-issue-on-debian-buster/68822)

```bash

# check which IPs are broadcasting
sudo lsof -i -P -n | grep turnserver

# check logs for turnserver errors
cat /var/log/syslog | grep turnserver

# permissions before mucking around
-rwxr--r-- 1 root root 1862 Nov 10 20:21 cert1.pem
-rwxr--r-- 1 root root 3749 Nov 10 20:21 chain1.pem
-rwxr--r-- 1 root root 5611 Nov 10 20:21 fullchain1.pem
-rw-r--r-- 1 root root 1704 Nov 10 20:21 privkey1.pem

```
