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

To activate this module with the ssh transport option, classify your agent node with the `nodripa` class using your preferred classification method. Below is an example using `site.pp`.

```puppet
node 'agent.example.com' {
  class { 'nodripa':
    private_key => <SSH-Private-Key>
}
```

#### Configuration

##### Parameters

**[access_token](https://puppet.com/docs/pe/2019.8/rbac_token_auth_intro.html#generate_a_token_using_puppet_access)**

`String`:

  * Requirements: [RBAC user](https://puppet.com/docs/pe/2019.8/rbac_user_roles_intro.html) will need the following permissions.
    * Job orchestrator -> Start, stop and view jobs
    * Tasks -> Run Tasks -> Task::bolt_shim::command -> Permitted on PE Master

**bolt_path**

`String`: `/path/to/bolt`
  * Default: `bolt`

**bolt_transport**

`String`: `pcp`
  * Default: `ssh`

**bolt_user**

`String`: User to execute `puppet node purge` command.
  * Default: `root`

**master_url**

`String`: https://MOM-FQDN:8143

**private_key**

`String`: Private `ssh-key`

**ssh_key**

`String`: `/path/to/privatekey.pem`
  * Default: `/root/.ssh/nodripa_rsa`

#### Limitations

* For bolt to execute the `puppet node purge` command an ssh-key will need to be configured with the `ssh` transport option set.
* For bolt to execute the `puppet node purge` command an access token will need to be configured with the `pcp` trasnport option set.
