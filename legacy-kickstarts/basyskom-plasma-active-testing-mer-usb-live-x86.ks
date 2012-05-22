# -*-mic2-options-*- -f livecd -*-mic2-options-*-

#
# Do not Edit! Generated by:
# kickstarter.py
#

lang en_US.UTF-8
keyboard us
timezone --utc Europe/Berlin
part / --size 3000 --ondisk sda --fstype=ext3
rootpw mer
xconfig --startxonboot
# bootloader --timeout=0 --append="quiet"
bootloader  --timeout=0 --menu="autoinst:Installation:systemd.unit=installer-shell.service"
desktop --autologinuser=mer
user --name mer  --groups audio,video --password mer


repo --name=ce_tools --baseurl=http://repo.pub.meego.com/CE:/Utils/Mer_Core_i586 --save --debuginfo
repo --name=mer-core --baseurl=http://releases.merproject.org/releases/latest/builds/i586/packages/ --save --debuginfo
repo --name=mer-core-debuginfo --baseurl=http://releases.merproject.org/releases/0.20111104.1/builds/i586/debug/ --save --debuginfo

repo --name=mer-shared  --baseurl=http://repo.pub.meego.com/CE:/MW:/Shared/Mer_Core_i586/ --save --debuginfo
repo --name=mer-plasma-shared --baseurl=http://repo.pub.meego.com/CE:/MW:/PlasmaActive/CE_MW_Shared_i586/ --save --debuginfo
repo --name=mer-extras --baseurl=http://repo.pub.meego.com/Project:/KDE:/Mer_Extras/Mer_Extras_i586/ --save --debuginfo

repo --name=plasma --baseurl=http://repo.pub.meego.com/Project:/KDE:/Trunk:/Testing/CE_UX_PlasmaActive_i586/ --save --debuginfo
repo --name=adaptation-x86-generic --baseurl=http://repo.pub.meego.com/CE:/Adaptation:/x86-generic/Mer_Core_i586/ --save --debuginfo


%packages
#custom-kernel
##############
kernel-adaptation-pc

# ce_tools repository
#####################
alsa-utils

# mer-core repository
####################

@Mer Core
# Mer Core defines following packages (06 dec 2011)
# basesystem bash boardname coreutils deltarpm e2fsprogs file filesystem fontpackages-filesystem
# kbd lsb-release meego-release nss pam passwd prelink procps readline rootfiles rpm setup
# shadow-utils shared-mime-info systemd-sysv time udev usbutils util-linux xdg-user-dirs zypper

@Mer Connectivity
# Mer Connectivity defines following packages (06 dec 2011)
# bluez connman crda iproute iputils net-tools ofono wireless-tools wpa_supplicant

@Mer Graphics Common
# Mer Graphics Common defines following packages (06 dec 2011)
# cjkuni-fonts droid-sans-fonts droid-sans-mono-fonts droid-serif-fonts liberation-fonts-common
# liberation-mono-fonts liberation-sans-fonts liberation-serif-fonts uxlaunch

@Mer Minimal Xorg
# Mer Minimal Xorg defines following packages (06 dec 2011)
# xorg-x11-server-Xorg xorg-x11-xauth

# Additional packages from mercore repository
connman-test
cpio
dbus
dbus-x11
diffutils
gzip
#libdrm
#mailcap
#mesa-dri-i915-driver
#mesa-dri-i965-driver
mesa-dri-swrast-driver
#mesa-libEGL
#mesa-libGL
openssh-clients
openssh-server
pulseaudio
qt-mobility
qt-qmlviewer
libqtdeclarative4-gestures
libqtwebkit-qmlwebkitplugin
libdeclarative-multimedia
sed
sensorfw
tar
vim-enhanced
xorg-x11-drv-fbdev
xorg-x11-drv-vesa
xorg-x11-utils-xhost


# mer-shared repository
#######################

@Nemo Middleware Shared
# Nemo Middleware Shared defines following packages (06 dec 2011)
# maliit-framework maliit-plugins ohm

# Additional packages from mer-shared repository
gdb
gst-plugins-good
xterm
ca-certificates
pulseaudio-policy-enforcement

# mer-plasma-shared repository
##############################
iodbc
# Hopefully not needed
# iodbc-admin

# plasma repository
###################
contour
contour-intro
declarative-plasmoids
kdelibs-data
kdelibs-imageio-plugins
kdelibs-plasma-runtime
kdepim-strigi-plugins
kde-runtime-desktoptheme
kde-runtime-emoticons
kde-runtime-nepomuk
kde-runtime-netattach
kde-runtime-newstuff
kde-runtime-plasma
kde-runtime-solid
kde-runtime-sounds
kde-runtime-wallet
kmix
plasma-active
plasma-active-config-blacklist
plasma-mobile-mouse
startactive
virtuoso
virtuoso-drivers
virtuoso-server
# Required by installdbgsymbols.sh
kdialog

# add some simple testing tools
simple-tests

# add kde-security packages
encfs
fuse
rlog

# Games
lskat
katomic
kfourinline
knetwalk
kshisen
kmahjongg
kpat
kreversi
# Apps
bangarang
kwrite
ksnapshot

# adaptation-x86-generic repository
###################################
@Intel x86 Generic Support
#Intel x86 Generic Support defines following packages (08 dec 2011)
# acpid linux-firmware installer-shell xorg-x11-drv-mtev xorg-x11-drv-synaptics
# xorg-x11-drv-intel mesa-dri-i915-driver mesa-dri-i965-driver mesa-libGLESv2
# contextkit-meego-battery-upower

# The kernel should be taken from the custom-kernel repo
#kernel-adaptation-pc

# mer-extras repository
#######################
alsa-plugins-pulseaudio
less
strace
xorg-x11-drv-mtev

# peregrine repository
######################
#peregrine-tablet-common
-okular

%end


%post
# save a little bit of space at least...
rm -f /boot/initrd*

# Prelink can reduce boot time
if [ -x /usr/sbin/prelink ]; then
    /usr/sbin/prelink -aRqm
fi

rm -f /var/lib/rpm/__db*
rpm --rebuilddb

# Add work-a-round to get virtualbox running
chmod u+s /usr/bin/Xorg

# verify link of flash plugin
if [ -f /usr/lib/flash-plugin/setup ]; then
    sh /usr/lib/flash-plugin/setup install
    rm -f /root/oldflashplugins.tar.gz
fi

echo "DISPLAYMANAGER=\"uxlaunch\"" >> /etc/sysconfig/desktop
# echo "session=/usr/bin/startactive" >> /etc/sysconfig/uxlaunch
# cursor not needed with plasma-mobile-mouse package installed
#echo "xopts=-nocursor" >> /etc/sysconfig/uxlaunch

# Create a session file X-MEEGO-HS.desktop
echo "[Desktop Entry]" >> /usr/share/xsessions/X-MEEGO-HS.desktop
echo "Version=1.0" >> /usr/share/xsessions/X-MEEGO-HS.desktop
echo "Name=mtf compositor session" >> /usr/share/xsessions/X-MEEGO-HS.desktop
echo "Exec=/usr/bin/startactive" >> /usr/share/xsessions/X-MEEGO-HS.desktop
echo "Type=Application" >> /usr/share/xsessions/X-MEEGO-HS.desktop

# Set symlink pointing to .desktop file 
ln -sf X-MEEGO-HS.desktop /usr/share/xsessions/default.desktop

echo "10-pegatron" > /etc/boardname-override
echo "10-pegatron" > /etc/boardname
cp /etc/sensorfw/sensord.conf.d/* /etc/sensorfw/

# kde-security: load the fuse module
#echo "/sbin/modprobe fuse" >> /etc/modprobe.d/dist.conf
mkdir -p /etc/modules-load.d/
echo "fuse" > /etc/modules-load.d/fuse.conf

# Work around for eGalax Touchscreen
cp /etc/X11/xorg.conf.d/60-cando-mtev.conf /etc/X11/xorg.conf.d/60-egalax-mtev.conf
sed -i s/"Cando Multi Touch Panel"/"eGalax Touchscreen"/ /etc/X11/xorg.conf.d/60-egalax-mtev.conf
sed -i s/Cando/eGalax/ /etc/X11/xorg.conf.d/60-egalax-mtev.conf

# Copy boot and shutdown images
cp /usr/share/themes/1024-600-10/images/system/boot-screen.png /usr/share/plymouth/splash.png
cp /usr/share/themes/1024-600-10/images/system/shutdown-screen.png /usr/share/plymouth/shutdown-1024x600.png
# work around for maemo6 sensor crash
rm /usr/lib/qt4/plugins/sensors/libqtsensors_meego.so

# Work around for camera
rm /usr/lib/gstreamer-0.10/libgstcamerabin.so

# Create a file for important details about the image
echo "2012-02-01-10-03-basyskom-plasma-active-testing-mer-usb-live" >> /etc/image-release
echo "" >> /etc/image-release
echo "Initial Packages:" >> /etc/image-release
rpm -qa | sort >> /etc/image-release


%end

%post --nochroot
if [ -n "" ]; then
    echo "BUILD: " >> /etc/meego-release
fi

%end