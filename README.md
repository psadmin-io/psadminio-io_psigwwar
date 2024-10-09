
# io_psigwwar

This module is used to configure various settings in the WebLogic Domain servlet PSIGW.war for Peoplesoft to complement the DPK.

# Setup

## Setup Requirements

This module has a requirement of the puppetlabs/inifile module. https://forge.puppet.com/puppetlabs/inifile

If you are using PeopleTools 8.55, that version of Puppet will need version 1.6.0 of the `inifile` module.

## Beginning with io_portalwar  

Add `contain ::io_portalwar` to a delivered or custom DPK profile. To change defaults, see usage below.

# Usage

## Integration Broker Properties

```
# IB Gateway Configuration
igw_prop_list:
  "%{hiera('db_name')}:
    '':
      ig.isc.serverURL: ' '
      ig.isc.userid:    ' '
      ig.isc.password:  ' '
      ig.isc.toolsRel:  ' '
      "ig.isc.%{hiera('db_name')}.serverURL":  "%{hiera('ib_servers')}"
      "ig.isc.%{hiera('db_name')}.userid":     "%{hiera('ib_user')}"
      "ig.isc.%{hiera('db_name')}.password":   "%{hiera('ib_pwd_encr')}"
      "ig.isc.%{hiera('db_name')}.toolsRel":   "%{hiera('tools_version')}"
      "ig.isc.%{hiera('db_name')}.DomainConnectionPwd":  "%{hiera('domain_pwd_encr')}"
      secureFileKeystorePasswd: "%{hiera('keystore_pwd_encr')}"
```

> For the password fields, encrypt the value with pscipher first. The password fields need to have the encrypted value, not a plain text value.
