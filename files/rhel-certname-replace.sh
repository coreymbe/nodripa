#!/bin/bash
certname=$(hostname -f)
sed -i "s/localcert/${certname}/g" /tmp/bolt-nodripa.sh
