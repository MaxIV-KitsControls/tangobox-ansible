ABOUT
=====
Do you ever dream to install a full Tango Control System by yourself?
or maybe you don't want to change your TangoBox every time it's updated?
or simply want to save your bandwith by installing Tango on existing machine!

The Tangobox Ansible project aims to facilitate the deployment of your Tango control system. It uses Ansible to orchestrate very smoothly the installation on one local or remote machine or 100s of them.
In this project you get more than 3 years of MAX IV experience on how to install and upgrade a full set up in less than 5 minutes. Did you know for example that the limit of file number limit has to be change in order to run several hundred of devices, even if it runs on a powerful machine?

Don't want to mess up your system! No problem, you can just read the playbook and the different role as a step by step instruction.
This collection of ansible roles allows you to choose which feature you want to install and where.
You can also use this project to see the difference with your actual system by asking ansible to only report the potential changes.

I hope you will appreciate this project like we do @ MAX IV. We have much more ansible roles to share but we think this simply enough to start with. Additionaly, some of them cannot be published as they are related to propriatary software i.e the Tango Mat... binding.

FEATURES
========
BASIC
-----
Configure the basic settings of the Operating system to welcome Tango. Check the etc/ansible/basic.yml file
- repositories: configure the extra repositories like the Tango repository (hosted by MAXIV)
- hostname: change the hostname of the computer
- ntp: set the NTP server to get a uniform timestamp system, useful for the archiving
- firewall: allow Tango communication throught a firewall
- users: create the local account for the users of the system i.e user: Tango password: tangobox with sudo access 
- email: setup the email server
- desktop: install the desktop environment for the Graphical User Interface. So only download the minimal OS install
- nvidia: if you have/need an Nvidia GPU
- network: Create a second interface for a dedicated communication channel with the hardware i.e camera and detector
- software/java: more or less mandatory to run the Tango utilities i.e jive, astor, ...
- vmware: install the vmware extra pack when running on a virtual machine cluster
- cls: connect an ldap and track who is doing what in your system 
- security: apply a collection of good practices i.e no root ssh access (sudo is your friend)

Bare TANGO CS
-------------
- tango-common: configure the TANGO_HOST
- tango-db: install and configure the Tango database with all the good practice on how to handle mysql
- tango-server: configure the machine to run Tango devices i.e runs the Tango starter
- tango-client: configure and install all the Tango utilities

Extra
-----
- tango-camera: prepare the machine to run lima
- icepap-db: configure a central icepap database
- icepap-client: configure the workstation to run the icepap utilities to the icepap database
- elog: configure an elog server. Very popular among the facilities.
- tango-archiving: set up a full and ready to use HDB/TDB/SNAPSHOT system
- nfs-server: create an NFS server
- nfs-client: mount an NFS directory
- cassandra-server: setup a cassandra cluster to run HDB++
- gateway: Let's make 2 Tango system communicate safely between 2 networks

OTHERS
------
MAX IV has also some roles in the private repository. We will continue to publish them as long as they are generic enough. Do you know that the ITECH LIBERA can be configured by Ansible.

Many more roles can be downloaded from Ansible Galaxy.

PREREQUISITE
============
Master
------
ANSIBLE 1.9.3: installed on the master (prefered) or locally on the machine to configure 
 - alternative will fail to setup java oracle by default if not configure before (when first installation of Java)



Operating System of the targets
-------------------------------
FULLY TESTED:
* CentOS 7 and 6: This is fully tested and daily used

UNSTABLE:
* Fedora is maybe compatible as MAX IV runs some of computer with Fedora (23?) but maybe it has not been merge yet. 
* Internaly we did some port to debian.

''''SELINUX'''' has to be disabled to run the first install and maybe to run Tango too(?)


QUICK START: Configure a Tangobox from scratch
===================================
From a Master
-------------
Here the master is any computer that can ssh your bare metal Operating System (See compatible OS above).
1 Download the tangobox-ansible on the computer to configure (master=target) or another one (master)
2 Go to the etc/ansible directory
```shell
 cd etc/ansible
```
3 Configure the ip of the target in the tangobox file. Ansible calls that 'Inventory'
```vi
65: [tango-sandbox-cc]
66: tangobox ansible_ssh_host=[10.0.1.30] desktop=True
```
4 Runs the basic configuration. Use a user with su or sudo privilege with the flag '-u'; by default ansible take your current login.
```shell
 ansible-playbook -i tangobox -u root -k basic.yml
```
5 Runs the cs configuration to install a full Tango Control System. From the application of the basic conf you should have a tango account.
```shell
 ansible-playbook -i tangobox -u tango -k cs.yml
```
6 Enjoy

From the localhost (target)
---------------------------
Here the target is your bare metal Operating System (See compatible OS above).
1 Download the tangobox-ansible on the computer to configure (master=target) or another one (master)
2 Go to the etc/ansible directory
```shell
 cd etc/ansible
```
3 Runs the basic configuration. Use a user with su or sudo privilege with the flag '-u'; by default ansible take your current login.
```shell
 ansible-playbook -i tangobox-localhost -u root -k basic.yml
```
After that the root account should be disabled from ssh connection. The rest of the command should be execute with the new tango account.

4 Runs the cs configuration to install a full Tango Control System. From the application of the basic conf you should have a tango account.
```shell
 ansible-playbook -i tangobox-localhost -u tango -k cs.yml
```
5 Enjoy


Other Usages
--------------
Ping all 'tango' computers:
```
 ansible tango-sandbox -i tangobox -k -m ping
```

Update the TANGO_HOST
```
 ansible-playbook -i prod -k -K cs.yml --check --tags TANGO_HOST
```

In the Future
=============
It was quite difficult to separate the Tangobox configuration from the specific MAXIV config. Our internal repository grows everyday and it's clear that we will have to split into different repo. At this moment this tangobox-ansible repository is an orphan branch of our internal repository (yep we have also some sensible information) but it's not clear how much it will take to maintain this public repo.
But for now having one repository is quite an easy way to introduce you to ansible

Collaboration
=============
More than welcome. Just fork and make some merge request.

Ask us if you want to work on a different Operating System. We may push some development branch to help you.

ACKNOWLEDGEMENT
===============
To all the KITS team that has contributed during more than 3 years to this configuration. Also to the Ansible community that have save us a lot of repetitive work, especially when we have migrated from CentOS 6 to 7.

What a pleasure to master our configuration!!!
