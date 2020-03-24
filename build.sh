#!/bin/sh

VERSION="2.729"
DEVICES="orangepipc orangepione orangepilite"

vagrant_copy() {
	tmpfile=`mktemp /tmp/vagrant-ssh-config.XXXX`
	vagrant ssh-config >$tmpfile
	scp -F $tmpfile "$@"
	rm $tmpfile
}

volumio_build() {
	echo "cd build/ && sudo -E bash build.sh -b arm -d $1 -v $2" | vagrant ssh
}

vagrant up
echo "git clone https://github.com/volumio/Build build" | vagrant ssh

for DEV in $DEVICES; do
	volumio_build $DEV $VERSION
done

vagrant_copy default:build/*.img default:build/*.img.md5 .
vagrant destroy -f

