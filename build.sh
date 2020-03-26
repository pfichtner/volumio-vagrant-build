#!/bin/sh

vagrant_copy() {
	TMPFILE=`mktemp vagrant-ssh-config.XXXXXXXXXX`
	vagrant ssh-config >$TMPFILE
	scp -F $TMPFILE "$@"
	rm $TMPFILE
}

if [ -z "$PROVIDER" ]; then
	vagrant up
else	
	vagrant up --provider="$PROVIDER"
fi

vagrant ssh -c "git clone https://github.com/volumio/Build build && cd build/ && sudo -E bash build.sh -b armv7 -d $DEVICE -v $VERSION && sudo bzip2 -9 Volumio$VERSION-*-$DEVICE.img"
vagrant_copy default:build/*.img.bz2 default:build/*.img.md5 .
vagrant destroy -f

