#!/bin/bash
certname=$(/opt/puppetlabs/bin/puppet config print certname)
sed -i "s/localcert/${certname}/g" /tmp/bolt-nodripa.sh
