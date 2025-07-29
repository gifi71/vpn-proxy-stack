set -a
source .env
set +a

docker exec acme --set-default-ca --server letsencrypt \
                 --issue -d ${OCERV_DOMAIN} --standalone \
                 --key-file       /etc/ocserv/server-key.pem  \
                 --fullchain-file /etc/ocserv/server-cert.pem
