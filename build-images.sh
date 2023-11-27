#!/bin/bash

#
# Copyright (C) 2023 Nethesis S.r.l.
# SPDX-License-Identifier: GPL-3.0-or-later
#

# Terminate on error
set -e

# Prepare variables for later use
images=()
# ubuntu_version="jammy-20231004"
# sogo_version="${sogo_version}"
# The image will be pushed to GitHub container registry
repobase="${REPOBASE:-ghcr.io/nethserver}"


# #Create webtop-webapp container
# reponame="sogo-binary"
# container=$(buildah from docker.io/library/ubuntu:${ubuntu_version})
# buildah run "${container}" /bin/sh <<'EOF'
# set -e
# # Install build dependencies and fetch SOGo and SOPE sources
# # export DEBIAN_FRONTEND=noninteractive && export TZ=UTC && export sogo_version=5.9.0 && apt-get update && apt-get install -y curl wget jq apache2 dos2unix memcached libssl-dev gnustep-base-runtime libgnustep-base-dev gettext-base lsb-release gnupg --no-install-recommends && \
# # echo "deb [trusted=yes] http://www.axis.cz/linux/debian jammy sogo-v5" > /etc/apt/sources.list.d/sogo.list && \
# # apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 608F5293A04BE668 && \
# # apt-get update && apt-get install -y gnustep-make gnustep-base-runtime libgnustep-base-dev pkg-config make gobjc libz-dev zlib1g-dev libpq-dev libmysqlclient-dev libcurl4-openssl-dev libsodium-dev libxml2-dev libssl-dev libldap2-dev libzip-dev mysql-client postgresql-client tmpreaper python3-m2crypto python3-simplejson python3-vobject python3-dateutil postgresql-server-dev-all libmemcached-dev libcurl4-openssl-dev libwbxml2-* tzdata libytnef0 libytnef0-dev --no-install-recommends

# # wget https://github.com/Alinto/sope/archive/refs/tags/SOPE-${sogo_version}.tar.gz
# # wget https://github.com/Alinto/sogo/archive/refs/tags/SOGo-${sogo_version}.tar.gz
# # tar -xf SOPE-${sogo_version}.tar.gz
# # tar -xf SOGo-${sogo_version}.tar.gz 
# # mv sope-SOPE-${sogo_version} /tmp/SOPE
# # mv sogo-SOGo-${sogo_version} /tmp/SOGo 
# # cd /tmp/SOPE && ./configure --with-gnustep --enable-debug --disable-strip && make && make install
# # cd /tmp/SOGo && ./configure --enable-debug --disable-strip && make && make install

# # # Configure Apache, SOGo, and other dependencies
# # a2enmod headers proxy proxy_http rewrite ssl && \
# # echo "/usr/local/lib/sogo" > /etc/ld.so.conf.d/sogo.conf && \
# # ldconfig && \
# # groupadd --system sogo && \
# # useradd --system --gid sogo sogo && \
# # install -o sogo -g sogo -m 755 -d /var/run/sogo /var/spool/sogo /var/log/sogo && \
# # mkdir -p /usr/lib/GNUstep/ && \
# # ln -s /usr/local/lib/GNUstep/SOGo /usr/lib/GNUstep/SOGo && \
# # ln -s /usr/local/sbin/sogo-tool /usr/sbin/sogo-tool && \
# # ln -s /usr/local/sbin/sogo-ealarms-notify /usr/sbin/sogo-ealarms-notify && \
# # ln -s /usr/local/sbin/sogo-slapd-sockd /usr/sbin/sogo-slapd-sockd
# echo 'deb [signed-by=/etc/apt/keyrings/sogo.gpg] http://packages.sogo.nu/nightly/5/ubuntu/ jammy jammy' > /etc/apt/sources.list.d/sogo.list && \
#     curl -s 'https://keys.openpgp.org/vks/v1/by-fingerprint/74FFC6D72B925A34B5D356BDF8A27B36A6E2EAE9' | gpg --dearmor | tee /etc/apt/keyrings/sogo.gpg > /dev/null && \
#     apt-get update && \
#     apt-get -o Dpkg::Options::="--force-confold" upgrade -q -y --force-yes && \
#     apt-get install -y --no-install-recommends gettext-base apache2 sogo sope4.9-dbg sope4.9-gdl1-postgresql memcached libssl-dev && \
#     apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
# # clean and purge orphan deb
# #apt purge  automake libtool dovecot-dev libxapian-dev libicu-dev build-essential -y
# apt-get autoremove --purge -y && \
# apt-get autoclean -y && \
# rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /root/.cache/
# EOF
# #buildah add "${container}" imapsync/ /
# # Commit the image
# buildah commit --rm "${container}" "${repobase}/${reponame}"



# Configure the image name
reponame="sogo"

# Create a new empty container image
container=$(buildah from scratch)

# Reuse existing nodebuilder-sogo container, to speed up builds
if ! buildah containers --format "{{.ContainerName}}" | grep -q nodebuilder-sogo; then
    echo "Pulling NodeJS runtime..."
    buildah from --name nodebuilder-sogo -v "${PWD}:/usr/src:Z" docker.io/library/node:lts
fi

echo "Build static UI files with node..."
buildah run \
    --workingdir=/usr/src/ui \
    --env="NODE_OPTIONS=--openssl-legacy-provider" \
    nodebuilder-sogo \
    sh -c "yarn install && yarn build"

# Add imageroot directory to the container image
buildah add "${container}" imageroot /imageroot
buildah add "${container}" ui/dist /ui
# Setup the entrypoint, ask to reserve one TCP port with the label and set a rootless container
buildah config --entrypoint=/ \
    --label="org.nethserver.authorizations=traefik@node:routeadm" \
    --label="org.nethserver.tcp-ports-demand=1" \
    --label="org.nethserver.rootfull=0" \
    --label="org.nethserver.images=docker.io/mariadb:10.11.6 docker.io/frederickzh/archlinux-sogo:5.9.0" \
    "${container}"
# Commit the image
buildah commit "${container}" "${repobase}/${reponame}"

# Append the image URL to the images array
images+=("${repobase}/${reponame}")

#
# NOTICE:
#
# It is possible to build and publish multiple images.
#
# 1. create another buildah container
# 2. add things to it and commit it
# 3. append the image url to the images array
#

#
# Setup CI when pushing to Github. 
# Warning! docker::// protocol expects lowercase letters (,,)
if [[ -n "${CI}" ]]; then
    # Set output value for Github Actions
    printf "images=%s\n" "${images[*],,}" >> "${GITHUB_OUTPUT}"
else
    # Just print info for manual push
    printf "Publish the images with:\n\n"
    for image in "${images[@],,}"; do printf "  buildah push %s docker://%s:%s\n" "${image}" "${image}" "${IMAGETAG:-latest}" ; done
    printf "\n"
fi
