#platform=x86, AMD64, or Intel EM64T

# firewall configuration
firewall --disabled

# install os instead of upgrade
install

# use network installation
url --url="http://{{ pxe_hostname }}/{{ item.image_path }}"

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

# extra yum repositories
#repo --name=updates --baseurl=http://ftp.sunet.se/pub/Linux/distributions/centos/6/updates/i386
#repo --name=epel --baseurl=http://ftp.sunet.se/pub/Linux/distributions/fedora/epel/6/i386

# ------------------------------------------------------------------------------
# disk partitioning
# ------------------------------------------------------------------------------

# bootloader configuration
bootloader --location=mbr --driveorder=sdb
bootloader --location=mbr --driveorder=sda

ignoredisk --only-use=sda,sdb
part raid.01 --fstype="raid" --onpart=sda1
part raid.02 --fstype="raid" --onpart=sdb1
part raid.03 --fstype="raid" --onpart=sda2
part raid.04 --fstype="raid" --onpart=sdb2

raid /boot --device=md0 --fstype="ext4" --level=1 raid.01 raid.02
raid pv.01 --device=md1 --level=1 raid.03 raid.04

volgroup vg0 pv.01
logvol swap  --vgname=vg0 --name=swap --fstype="swap" --recommended
logvol /     --vgname=vg0 --name=root --fstype="ext4" --size={{ item.root_size }}
logvol /home --vgname=vg0 --name=home --fstype="ext4" --size=1 --grow

# ------------------------------------------------------------------------------
# services configuration
# ------------------------------------------------------------------------------
services --enabled ntpd
services --disabled avahi-daemon,bluetooth,iscsi,iscsid,kdump

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

#@desktop
#@general-desktop
#@graphical-admin-tools
#@office-suite

# centos base packages
java-1.7.0-openjdk
java-1.7.0-openjdk-devel
#logwatch
ntp
screen
telnet
#uucp

PackageKit-gtk-module
yum-plugin-changelog

# epel packages:
#epel-release

# ------------------------------------------------------------------------------
# post install script
# ------------------------------------------------------------------------------
%pre
# for some reason, the centos installer insists upon reordering
# raid partitions so that the largest partition comes first on disk.
# we want a small boot partition at the beginning of each disk.
# manually create partitions here before running the installer, and
# instruct the installer to use the existing partition layout.

BOOT_SIZE_MB=512
PARTED='parted --script'

# clear mbr and partition table
dd if=/dev/zero of=/dev/sda bs=512 count=1 2> /dev/null
dd if=/dev/zero of=/dev/sdb bs=512 count=1 2> /dev/null
$PARTED /dev/sda mklabel msdos
$PARTED /dev/sdb mklabel msdos

# calculate disk sizes
HDA_SIZE_MB=`$PARTED /dev/sda unit mb print free | grep Free | awk '{print $3}' | cut -d "M" -f1`
HDB_SIZE_MB=`$PARTED /dev/sdb unit mb print free | grep Free | awk '{print $3}' | cut -d "M" -f1`

# find smallest disk
if [ $HDA_SIZE_MB -lt $HDB_SIZE_MB ]; then
    DISK_SIZE_MB=$HDA_SIZE_MB
else
    DISK_SIZE_MB=$HDB_SIZE_MB
fi

# create partitions
let P1_START=1
let P1_END=$BOOT_SIZE_MB
let P2_START=$P1_END
let P2_END=$DISK_SIZE_MB

$PARTED /dev/sda --align cylinder mkpart primary $P1_START $P1_END
$PARTED /dev/sda --align cylinder mkpart primary $P2_START $P2_END
$PARTED /dev/sdb --align cylinder mkpart primary $P1_START $P1_END
$PARTED /dev/sdb --align cylinder mkpart primary $P2_START $P2_END
sync

# delete old raid metadata (if any)
mdadm --zero-superblock /dev/sda1
mdadm --zero-superblock /dev/sda2
mdadm --zero-superblock /dev/sdb1
mdadm --zero-superblock /dev/sdb2
%end

%post
# grant sudo access for tango user
echo "tango ALL=(ALL) ALL" >> /etc/sudoers
%end

