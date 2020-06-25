#!/bin/bash
mom_certname=$(/opt/puppetlabs/bin/puppet config print server --section main)
bolt command run '/opt/puppetlabs/bin/puppet node purge localcert' --targets $mom_certname
