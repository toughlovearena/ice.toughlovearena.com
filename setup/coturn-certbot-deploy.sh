#!/bin/sh

# https://serverfault.com/a/984575

# mkdir -p /etc/coturn/certs
# chown -R turnserver:turnserver /etc/coturn/
# chmod -R 700 /etc/coturn/
# nano /etc/letsencrypt/renewal-hooks/deploy/coturn-certbot-deploy.sh
# chmod 700 /etc/letsencrypt/renewal-hooks/deploy/coturn-certbot-deploy.sh

set -e

for domain in $RENEWED_DOMAINS; do
        case $domain in
        ice.toughlovearena.com)
                daemon_cert_root=/etc/coturn/certs

                # Make sure the certificate and private key files are
                # never world readable, even just for an instant while
                # we're copying them into daemon_cert_root.
                umask 077

                cp "$RENEWED_LINEAGE/fullchain.pem" "$daemon_cert_root/$domain.cert"
                cp "$RENEWED_LINEAGE/privkey.pem" "$daemon_cert_root/$domain.key"

                # Apply the proper file ownership and permissions for
                # the daemon to read its certificate and key.
                chown turnserver "$daemon_cert_root/$domain.cert" \
                        "$daemon_cert_root/$domain.key"
                chmod 400 "$daemon_cert_root/$domain.cert" \
                        "$daemon_cert_root/$domain.key"

                service coturn restart >/dev/null
                ;;
        esac
done
