#!/bin/bash

set -e

# Install pxelinux.0 AND ldlinux.c32 for network boot
mkdir app/tftp && cp /usr/lib/PXELINUX/pxelinux.0 /app/tftp && cp /usr/lib/syslinux/modules/bios/ldlinux.c32 /app/tftp

# Import CoreOS Signing Key
wget -qO- https://coreos.com/security/image-signing-key/CoreOS_Image_Signing_Key.pem | gpg --import

# Install coreos pxe images
cd /app/tftp && \
    wget -q http://$COREOS_CHANNEL.release.core-os.net/amd64-usr/current/coreos_production_pxe.vmlinuz && \
    wget -q http://$COREOS_CHANNEL.release.core-os.net/amd64-usr/current/coreos_production_pxe.vmlinuz.sig && \
    gpg --verify coreos_production_pxe.vmlinuz.sig

# Download image to /tmp
cd /tmp && \
    wget -q http://$COREOS_CHANNEL.release.core-os.net/amd64-usr/current/coreos_production_pxe_image.cpio.gz && \
    wget -q http://$COREOS_CHANNEL.release.core-os.net/amd64-usr/current/coreos_production_pxe_image.cpio.gz.sig && \
    gpg --verify coreos_production_pxe_image.cpio.gz.sig

# Extract and combine with /oem
#RUN mkdir /tmp/initrd && \
#    cd /tmp/initrd && \
#    cat /tmp/coreos_production_pxe_image.cpio.gz | gzip -d | cpio -i && \
#    unsquashfs -f -d ./tttmp usr.squashfs && \
#    cp -R /oem/* ./tttmp && \
#    rm usr.squashfs && \
#    mksquashfs ./tttmp ./usr.squashfs && \
#    rm -R ./tttmp && \
#    find | cpio -o --format=newc | gzip -9c > /app/tftp/coreos_production_pxe_image_oem.cpio.gz
mv /tmp/coreos_production_pxe_image.cpio.gz /app/tftp/coreos_production_pxe_image_oem.cpio.gz
rm -R /tmp/*
