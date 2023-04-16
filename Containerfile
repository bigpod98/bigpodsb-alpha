ARG FEDORA_MAJOR_VERSION
ARG IMAGE_TYPE
FROM ghcr.io/ublue-os/bluefin${IMAGE_TYPE}:${FEDORA_MAJOR_VERSION}

COPY etc /etc

RUN rpm-ostree override remove evince-djvu evince-libs evince-previewer evince-thumbnailer gnome-user-docs
RUN rpm-ostree override remove vim-minimal virtualbox-guest-additions yelp yelp-libs yelp-xsl
RUN rpm-ostree install code chromium fish iotop plasma-workspace-wallpapers dbus-x11 htop breeze-cursor-theme direnv cascadia-code-fonts
RUN rpm-ostree install qemu qemu-user-static qemu-user-binfmt virt-manager libvirt qemu qemu-user-static qemu-user-binfmt edk2-ovmf
RUN rpm-ostree install cockpit-bridge cockpit-system cockpit-networkmanager cockpit-selinux cockpit-storaged cockpit-podman cockpit-machines cockpit-pcp
RUN rpm-ostree install akmod-v4l2loopback dconf-editor mediawriter vlc
RUN rm -f /etc/yum.repos.d/vscode.repo
RUN rm -rf /tmp/* /var/*
RUN ostree container commit
