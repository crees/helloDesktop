#!/bin/sh

destdir=$1

hello_tag="r0.8.1"
helloSystem_repo='https://api.cirrus-ci.com/v1/artifact/github/crees/helloDesktop/pkg/binary/${ABI}'
FreeBSD_base_repo='https://www.bayofrum.net/pkg-download/pkgbase/${ABI}/latest'

err() {

	>&2 echo "$*"
	exit 1
}

get_base_pkg_list() {

	pkg query -Cx %n ^FreeBSD- | \
		grep -Ev '[-]dbg$|-dev$' | \
		grep -v '[-]kernel-'
	echo FreeBSD-kernel-generic
}

install_pkg() {

	env PKG_CACHEDIR=/var/cache/pkg pkg -r $destdir -R $destdir/usr/local/etc/pkg/repos install -y "$@"
}

create_pkg_repoconf() {
	local name=$1
	local url=$2
	local priority=${3:-100}

	mkdir -p $destdir/usr/local/etc/pkg/repos
	cat > $destdir/usr/local/etc/pkg/repos/$1.conf << EOF
$name: {
	url: "$url",
	mirror_type: "srv",
	enabled: yes,
	priority: $priority
}
EOF
}

install_base_pkgs() {

	create_pkg_repoconf FreeBSD-base "$FreeBSD_base_repo"
	install_pkg $(get_base_pkg_list)
}

install_hello_pkg() {

	create_pkg_repoconf helloSystem "$helloSystem_repo"
	install_pkg helloSystem
}

bootstrap_base() {

	mkdir -p $destdir/usr/share/keys
	cp -R /usr/share/keys/pkg $destdir/usr/share/keys
}

install_extra_pkgs() {
	cp $destdir/etc/pkg/FreeBSD.conf $destdir/usr/local/etc/pkg/repos/
	for list in hello common-13; do
	    fetch -o - "https://raw.githubusercontent.com/helloSystem/ISO/$hello_tag/settings/packages.$list" | \
	    while read pkg; do
		case "$pkg" in
		\#*)
		    continue
		    ;;
		"")
		    continue
		    ;;
		*'# !'*)
		    continue
		    ;;
		https://*)
		    echo $pkg >> $destdir/pkg_to_add
		    ;;
		*)
		    echo $pkg >> $destdir/pkg_to_install
		    ;;
		esac
	    done
	done
	env ABI=FreeBSD:12:amd64 pkg -r $destdir add $(cat $destdir/pkg_to_add)
	install_pkg $(cat $destdir/pkg_to_install)
	rm $destdir/pkg_to_*
	rm $destdir/usr/local/etc/pkg/repos/FreeBSD.conf
}

if [ -z "$destdir" ]; then
	mkdir /tmp/newhello || err "md already exists, make sure you delete it first!"
	# Big memdisk!
	md=$(mdconfig -at swap -s 7000M)
	if [ $? -ne 0 ]; then
		err mdconfig failed
	fi
	newfs /dev/$md
	mount /dev/$md /tmp/newhello
	destdir=/tmp/newhello
fi

bootstrap_base

install_base_pkgs

#install_hello_pkg

install_extra_pkgs

