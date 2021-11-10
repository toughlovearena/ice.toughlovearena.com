# install

Guide to installing the coturn server for STUN/TURN on a fresh box

## nginx + certbot

```bash

# setup nginx to serve hello page
sudo apt install nginx

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

# Touch and then copy/paste the contents of the turnserver.conf
sudo touch /etc/turnserver.conf
sudo vi /etc/turnserver.conf

# start coturn
sudo systemctl restart coturn

```
