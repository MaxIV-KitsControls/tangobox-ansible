PREREQUISITE
------------
ANSIBLE 1.9.3:
 - alternative will fail to setup java oracle by default if not configure before (when first installation of Java)

SET ENVIRONMENT
===============
Set the enviroment to be able to execute command from this directory.

 source bin/ansible.env


Configure the MAX IV Control system
===================================
* First configure new hosts with the basic configuration (root mode). This will configure the correct rpm repository proxy, the connection to the ldap to be able to connect with your own account.
```
 ansible-playbook -i prod_maxiv -k -u root basic.yml --limit="g-v0-cc-2410:g-v0-ec-0806"
```
After that the root account should be disabled from ssh connection. The rest of the command should be execute with your own account.

* Secondly, this will mount the home directory (separated action because root can not access the storage server)
```
 ansible-playbook -i prod_maxiv -k -K basic2.yml --limit="g-v0-cc-2410:g-v0-ec-0806"
```

* Finally, we can install and configure the control system stuff
```
 ansible-playbook -i prod_maxiv -k -K cs.yml --limit="g-v0-cc-2410:g-v0-ec-0806"


Configure a TangoBox
--------------------
New image: host-only adapter with Intel Pro/1000 MT Desktop (82540EM) with promiscuous mode == Allow all
Known issues:
* After the pxe boot you have to change the mode of the network adapter to reach Internet


```

Special notes:
It should not matter if you don't limit the list of host to configure. The Ansible configuration should be idempotent but ... it is not 100% sure. In case of you launched ansible wo the limitation it should not affect too much the current configuration


Other Examples
--------------
Ping all 'new' computer:
```
 ansible new -m ping --ask-pass
```

Configure the new computer as standard
```
 ansible-playbook -k -s -u root etc/ansible/new.yml
```

Update the TANGO_HOST
```
 ansible-playbook -i prod -k -K cs.yml --check --tags TANGO_HOST
```

Update the Remmina configuration for the scope of the Linac on the control room computer
```
 ansible-playbook -i prod_maxiv -k -K machine.yml --limit=machine-cc --tags=remmina
```

Configure the Backup System (separated from cs.yml until the merge with master)
```
 ansible-playbook -i prod_maxiv -k -K backup.yml
```
