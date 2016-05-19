# firewall configuration
firewall --disabled

# install os instead of upgrade
install

# use network installation
url --url="http://{{ inventory_hostname }}/{{ item.image_path }}"

# root password
rootpw --iscrypted $1$R9lyLHF4$7/xpamxPfExRFOj3m99yW/

# configuration management account
user --name=tango --iscrypted --password=$1$rC5M.ACD$m47AI2UPWvL33fxhuB4AI1 --shell=/bin/bash

# user account
#user --name=user --shell=/bin/bash

# network information
network  --bootproto=dhcp --device=eth0 --onboot=on

# system authorization information
auth  --useshadow  --passalgo=sha512

# use text installer
text

# do not run setup agent on first boot
firstboot --disabled

# System keyboard
keyboard us 

# system language
lang en_US

# selinux configuration
selinux --disabled

# installation logging level
logging --level=debug

# system timezone
timezone  Europe/Stockholm

# ------------------------------------------------------------------------------
# disk partitioning
# ------------------------------------------------------------------------------

# bootloader configuration
bootloader --location=mbr --driveorder=sda

clearpart --drives=sda --all --initlabel
ignoredisk --only-use=sda
autopart

#part /boot --asprimary --fstype="ext4" --size=512
#part pv.01 --asprimary --fstype="lvm"  --size=1 --grow

#volgroup vg0 pv.01
#logvol swap  --vgname=vg0 --name=swap --fstype="swap" --recommended
#logvol /home --vgname=vg0 --name=home --fstype="ext4" --size=1 --grow
#logvol /     --vgname=vg0 --name=root --fstype="ext4" --size={{ item.root_size }}

# ------------------------------------------------------------------------------
# services configuration
# ------------------------------------------------------------------------------
services --disabled avahi-daemon,bluetooth,iscsi,iscsid,kdump

{% if item.start_x is defined %}
# start x on boot (runlevel 5)
xconfig --startxonboot --defaultdesktop=GNOME
{% endif %}
# ------------------------------------------------------------------------------
# package selection
# ------------------------------------------------------------------------------
%packages

# package groups:
@base
ntp
nc
yum-plugin-changelog

{% for package in item.packages %}
package
{% endfor %}
