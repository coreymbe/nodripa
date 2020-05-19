# Node Reaper

## Module description

Node Reaper is a Puppet module for auto purging an agent node on scale-in. While this module is intended to be utilized with an autoscaling service, the minimum requirement is to have autosigning configured in your Puppet installation.

## Setup

This module will configure and manage the `nodripa` systemd service, which upon stopping will:

  * Deactivate the node in PuppetDB
  * Delete the Puppet master’s information cache for the node
  * Free up the license that the node was using
  * Allow you to re-use the hostname for a new node

#### Installation

Install this module with the following command:

```
puppet module install coreymbe-nodripa
```

To activate this module, classify your agent node with the `nodripa` class using your preferred classification method. Below is an example using `site.pp`.

```puppet
node 'agent.example.com' {
  include nodripa
}
```

#### Configuration

##### Parameters


**private_key**

`String`: Private `ssh-key`

**ssh_key**

`String`: `/path/to/privatekey.pem`
  * Default: `/root/.ssh/nodripa_rsa`  

**bolt_user**

`String`: User to execute `puppet node purge` command.
  * Default: `root`

#### Limitations

* For bolt to execute the `puppet node purge` command an ssh-key will need to be configured.
* If utilizing this module on AWS instances, the ssh-key needs to be in `.pem` format.
