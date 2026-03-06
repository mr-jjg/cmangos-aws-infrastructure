#!/bin/bash
set -euo pipefail
exec > >(tee /var/log/classic-db-bootstrap.log | logger -t user-data -s 2>/dev/console) 2>&1

if [ -f /etc/cmangos.env.sh ]; then
  set -a
  . /etc/cmangos.env.sh
  set +a
fi

: "${RDS_ENDPOINT:?}"
: "${RDS_PORT:=3306}"
: "${RDS_MASTER_USER:?}"
: "${RDS_MASTER_PASS:?}"
: "${PUBLIC_IP:?}"
: "${CORE_PATH:=/srv/cmangos/mangos}"

sudo apt-get update
sudo apt-get install -y mysql-client git

sudo mkdir -p /srv
cd /srv
if [ ! -d classic-db ]; then
  sudo git clone https://github.com/cmangos/classic-db.git
fi
sudo chown -R ubuntu:ubuntu /srv/classic-db
cd /srv/classic-db

cat > InstallFullDB.config <<EOF
MYSQL_HOST="${RDS_ENDPOINT}"
MYSQL_PORT="${RDS_PORT}"

MYSQL_USERNAME="${RDS_MASTER_USER}"
MYSQL_PASSWORD="${RDS_MASTER_PASS}"
MYSQL_USERIP="%"

WORLD_DB_NAME="classicmangos"
REALM_DB_NAME="classicrealmd"
CHAR_DB_NAME="classiccharacters"
LOGS_DB_NAME="classiclogs"

MYSQL_PATH="/usr/bin/mysql"
MYSQL_DUMP_PATH="/usr/bin/mysqldump"

CORE_PATH="${CORE_PATH}"

LOCALES="YES"
FORCE_WAIT="NO"
DEV_UPDATES="NO"
AHBOT="NO"
PLAYERBOTS_DB="NO"
EOF

chmod +x ./InstallFullDB.sh
./InstallFullDB.sh -InstallAll "${RDS_MASTER_USER}" "${RDS_MASTER_PASS}" DeleteAll

cat > post_bootstrap.sql <<EOF
USE classicrealmd;

UPDATE realmlist
SET address = '${PUBLIC_IP}'
WHERE id = 1;
EOF

mysql -h "$RDS_ENDPOINT" -P "$RDS_PORT" -u "$RDS_MASTER_USER" -p"$RDS_MASTER_PASS" classicrealmd < post_bootstrap.sql
