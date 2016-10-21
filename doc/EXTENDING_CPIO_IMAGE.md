# Extending the image

To add files to the image do the Dockerfile does:

```
RUN mkdir /tmp/initrd && \
    cd /tmp/initrd && \
    cat /tmp/coreos_production_pxe_image.cpio.gz | gzip -d | cpio -i && \
    unsquashfs -f -d ./tttmp usr.squashfs && \
    cp -R /oem/* ./tttmp && \
    rm usr.squashfs && \
    mksquashfs ./tttmp ./usr.squashfs && \
    rm -R ./tttmp && \
    find | cpio -o --format=newc | gzip -9c > /app/tftp/coreos_production_pxe_image_oem.cpio.gz
```

So everything inside `/oem` will be copied into the base image and
repacked.

Within the booted machine the files are located inside `/usr` directory.


```
/oem/etc/someConfig.txt => /usr/etc/someConfig.txt
```

