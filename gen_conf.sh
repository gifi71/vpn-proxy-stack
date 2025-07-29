set -a
source .env
set +a

mkdir -p ./volumes/nginx ./volumes/ocserv
envsubst '${OCERV_DOMAIN} ${REALITY_DOMAIN} ${CAMOUFLAGE_SECRET} ${DEFAULT_HTTPS} ${DEFAULT_HTTP}' \
        < ./templates/nginx.conf.template > ./volumes/nginx/nginx.conf
envsubst '${OCERV_DOMAIN} ${REALITY_DOMAIN} ${CAMOUFLAGE_SECRET} ${DEFAULT_HTTPS} ${DEFAULT_HTTP}' \
        < ./templates/ocserv.conf.template > ./volumes/ocserv/ocserv.conf
