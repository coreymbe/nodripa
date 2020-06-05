#!/bin/bash
if [[ $(facter -p aio_agent_version) < 6 ]]
  then /usr/bin/rm /etc/puppetlabs/puppet/ssl -rf
else /opt/puppetlabs/bin/puppet ssl clean
fi