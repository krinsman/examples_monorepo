#!/bin/bash

addusers() {

    # add some dummy users

    adduser -q --gecos "" --disabled-password william
    echo william:hi   | chpasswd

    adduser -q --gecos "" --disabled-password krinsman
    echo krinsman:bye | chpasswd

}

apt_install () {

	# introduces non-determinism but probably better for 
	# security reasons to install most up-to-date versions
	# apt packages rather than specific versions

	apt-get update			          
	apt-get --yes upgrade
	apt-get --yes install  --no-install-recommends $@
	
	# hopefully changes to apt package versions will
	# be less likely to cause things to break

	apt-get clean --yes
}



$@
