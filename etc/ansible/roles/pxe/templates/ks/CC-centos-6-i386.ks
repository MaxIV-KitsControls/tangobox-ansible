#platform=x86, AMD64, or Intel EM64T

# firewall configuration
firewall --disabled

# install os instead of upgrade
install

# use network installation
url --url="http://{{ pxe_hostname }}/{{ pxe_image_path }}"

# root password
rootpw --iscrypted $1$R9lyLHF4$7/xpamxPfExRFOj3m99yW/

# configuration management account
user --name=tango --iscrypted --password=$1$rC5M.ACD$m47AI2UPWvL33fxhuB4AI1 --shell=/bin/bash

# user account
#user --name=user --shell=/bin/bash

# network information
#network  --bootproto=dhcp --device=eth0 --onboot=on --hostname=ec-new-0.maxlab.lu.se
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

# extra yum repositories
#repo --name=updates --baseurl=http://ftp.sunet.se/pub/Linux/distributions/centos/6/updates/i386
#repo --name=epel --baseurl=http://ftp.sunet.se/pub/Linux/distributions/fedora/epel/6/i386

# ------------------------------------------------------------------------------
# disk partitioning
# ------------------------------------------------------------------------------

# bootloader configuration
bootloader --location=mbr --driveorder=sda

clearpart --drives=sda --all --initlabel
ignoredisk --only-use=sda

part /boot --asprimary --fstype="ext4" --size=512
part pv.01 --asprimary --fstype="lvm"  --size=1 --grow

volgroup vg0 pv.01
logvol swap  --vgname=vg0 --name=swap --fstype="swap" --recommended
logvol /     --vgname=vg0 --name=root --fstype="ext4" --size={{ pxe_root_size }}
logvol /home --vgname=vg0 --name=home --fstype="ext4" --size=1 --grow

# ------------------------------------------------------------------------------
# services configuration
# ------------------------------------------------------------------------------
services --enabled ntpd
services --disabled avahi-daemon,bluetooth,iscsi,iscsid,kdump

# start x on boot (runlevel 5)
xconfig --startxonboot --defaultdesktop=GNOME

# ------------------------------------------------------------------------------
# package selection
# ------------------------------------------------------------------------------
%packages

# package groups:
@base
@development
@emacs
@fonts
@internet-browser
@network-file-system-client
@x11

@desktop
@general-desktop
@graphical-admin-tools
@office-suite

# centos base packages
java-1.7.0-openjdk
java-1.7.0-openjdk-devel
#logwatch
ntp
#screen
#telnet
nc
#uucp

PackageKit-gtk-module
yum-plugin-changelog

# epel packages:
#epel-release

# ------------------------------------------------------------------------------
# post install script
# ------------------------------------------------------------------------------
%post
# grant sudo access for tango user
echo "tango ALL=(ALL) ALL" >> /etc/sudoers
%end

