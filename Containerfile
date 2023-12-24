ARG FEDORA_MAJOR_VERSION
ARG IMAGE_TYPE

FROM ubuntu:latest as installer
RUN apt update && apt upgrade -y && apt install -y wget tar
RUN wget https://github.com/prometheus/node_exporter/releases/download/v1.7.0/node_exporter-1.7.0.linux-amd64.tar.gz
RUN tar -xf node_exporter-1.7.0.linux-amd64.tar.gz
RUN mkdir -p /ROOTFS/usr/bin/
RUN cp /node_exporter-1.7.0.linux-amd64/node_exporter /ROOTFS/usr/bin/

FROM ghcr.io/ublue-os/bluefin${IMAGE_TYPE}:${FEDORA_MAJOR_VERSION}

COPY etc /etc

ARG IMAGE_NAME="bigpodsb-alpha"
ARG IMAGE_VENDOR="bigpod98"
ARG IMAGE_TYPE
ARG IMAGE_FLAVOR=$IMAGE_TYPE
ARG FEDORA_MAJOR_VERSION
ARG BASE_IMAGE_NAME="ghcr.io/ublue-os/bluefin${IMAGE_TYPE}:${FEDORA_MAJOR_VERSION}"

RUN wget https://copr.fedorainfracloud.org/coprs/ganto/lxc4/repo/fedora-"${FEDORA_MAJOR_VERSION}"/ganto-lxc4-fedora-"${FEDORA_MAJOR_VERSION}".repo -O /etc/yum.repos.d/ganto-lxc4-fedora-"${FEDORA_MAJOR_VERSION}".repo
COPY image-info.sh /tmp/image-info.sh
RUN bash /tmp/image-info.sh
RUN cat /tmp/image-info.sh
RUN echo $IMAGE_TYPE
RUN echo $IMAGE_FLAVOR
RUN rpm-ostree override remove evince-djvu evince-libs evince-previewer evince-thumbnailer gnome-user-docs
RUN rpm-ostree override remove vim-minimal virtualbox-guest-additions yelp yelp-libs yelp-xsl gnome-user-share
RUN rpm-ostree install code chromium fish iotop plasma-workspace-wallpapers dbus-x11 htop breeze-cursor-theme direnv cascadia-code-fonts dotnet-sdk-7.0 dotnet-sdk-8.0
RUN rpm-ostree install qemu qemu-user-static qemu-user-binfmt virt-manager libvirt qemu qemu-user-static qemu-user-binfmt edk2-ovmf
RUN rpm-ostree install cockpit-bridge cockpit-system cockpit-networkmanager cockpit-selinux cockpit-storaged cockpit-podman cockpit-machines cockpit-pcp 
RUN rpm-ostree install dconf-editor mediawriter vlc ceph-common python3-qt5 hplip-gui flatpak-builder neofetch code-insiders gnome-console azure-cli
RUN rpm-ostree install lxc-libs rpmdevtools squashfs-tools incus incus-agent microsoft-edge-stable
RUN rpm-ostree override remove rpmfusion-free-release rpmfusion-nonfree-release
COPY --from=installer /ROOTFS/* /
RUN systemctl enable podman.service
RUN systemctl enable node_exporter.service
RUN rm -rf /tmp/* /var/*
RUN ostree container commit
