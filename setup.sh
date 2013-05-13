#!/usr/bin/env bash

# https://gist.github.com/bhang/2703599

set -o errexit
set -o verbose

apt-add-repository ppa:chris-lea/node.js
apt-get update

apt-get install -y \
  git \
  libcairo2 \
  libcairo2-dev \
  memcached \
  nodejs \
  npm \
  pkg-config \
  python-cairo \
  python-dev \
  python-pip \
  sqlite3

pip install --upgrade pip

depsfile=$( tempfile )

cat << EOF > $depsfile
carbon==0.9.10
django-tagging
django==1.3
graphite-web==0.9.10
python-memcached
twisted
whisper==0.9.10
EOF

pip install -r $depsfile

rm -f $depsfile

pushd /opt/graphite/conf

cp -f carbon.conf.example carbon.conf

cat << EOF > storage-schemas.conf
[stats]
priority = 110
pattern = ^stats\..*
retentions = 10s:6h,1m:7d,10m:1y
EOF

popd

mkdir -p /opt/graphite/storage/log/webapp

pushd /opt/graphite/webapp/graphite

cp -f local_settings.py.example
      local_settings.py

python manage.py syncdb

popd

git clone git://github.com/etsy/statsd.git /opt/statsd

pushd /opt/statsd

npm install

cat << EOF > config.js
{
  graphitePort: 2003,
  graphiteHost: "0.0.0.0",
  port: 8125
}
EOF

popd