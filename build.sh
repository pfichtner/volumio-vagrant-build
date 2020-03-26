#!/bin/sh

VERSION="2.729"
DEVICES="orangepilite"
#DEVICES="orangepipc orangepione orangepilite"

vagrant_copy() {
	TMPFILE=`mktemp vagrant-ssh-config.XXXXXXXXXX`
	vagrant ssh-config >$TMPFILE
	scp -F $TMPFILE "$@"
	rm $TMPFILE
}

volumio_build() {
	vagrant ssh -c "cd build/ && sudo -E bash build.sh -b armv7 -d $1 -v $2 && bzip2 -9 Volumio$2-*-$1.img && find"
}

if [ -z "$PROVIDER" ]; then
	vagrant up
else	
	vagrant up --provider="$PROVIDER"
fi

vagrant ssh -c "git clone https://github.com/volumio/Build build"

for DEV in $DEVICES; do
	volumio_build $DEV $VERSION
done

vagrant_copy default:build/*.img.bz2 default:build/*.img.md5 .
vagrant destroy -f

