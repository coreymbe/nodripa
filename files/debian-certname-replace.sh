#!/bin/bash
certname=$(hostname -A)
sed -i "s/localcert/${certname}/g" /tmp/bolt-nodripa.sh
