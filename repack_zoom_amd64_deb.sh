#! /bin/bash

set -e

echo "Downloading zoom_amd64.deb"
curl --output zoom_amd64.deb --location --silent "https://zoom.us/client/latest/zoom_amd64.deb"

echo "Unpacking zoom_amd64.deb"
ar x zoom_amd64.deb

echo "Unpacking control file"
tar xf control.tar.xz
rm control.tar.xz

echo "Stripping ibus dependenecy from control file"
sed -i 's/ibus,\? \?//' control

echo "Creating new control file without ibus dependency"
tar --owner=0:0 --group=0:0 -c -a -f control.tar.xz ./control ./postinst ./postrm ./md5sums

echo "Repacking zoom_amd64.deb"
ar r zoom_amd64_repacked.deb debian-binary control.tar.xz data.tar.xz 2>&1 > /dev/null

echo "Cleaning up temporary files"
rm -f control postinst postrm md5sums _gpgbuilder control.tar.xz data.tar.xz debian-binary zoom_amd64.deb

