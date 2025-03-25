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

echo "Cleaning up temporary files"
rm control postinst postrm md5sums
rm zoom_amd64.deb

echo "Repacking zoom_amd64.deb"
ar r zoom_amd64.deb debian-binary control.tar.xz data.tar.xz 2>&1 > /dev/null
