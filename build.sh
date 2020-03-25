#!/bin/sh

VERSION="2.729"
DEVICES="orangepipc orangepione orangepilite"

vagrant_copy() {
	TMPFILE=`mktemp vagrant-ssh-config.XXXXXXXXXX`
	vagrant ssh-config >$TMPFILE
	scp -F $TMPFILE "$@"
	rm $TMPFILE
}

volumio_build() {
	vagrant ssh -c "cd build/ && sudo -E bash build.sh -b armv7 -d $1 -v $2"
}

vagrant up
vagrant ssh -c "git clone https://github.com/volumio/Build build"

for DEV in $DEVICES; do
	volumio_build $DEV $VERSION
done

vagrant_copy default:build/*.img default:build/*.img.md5 .
vagrant destroy -f

