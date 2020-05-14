#!/bin/bash
mom_certname=$(puppet config print server --section main)
/opt/puppetlabs/bin/bolt command run '/opt/puppetlabs/bin/puppet node purge localcert' --targets $mom_certname --no-host-key-check --private-key /root/.ssh/nodripa_rsa
