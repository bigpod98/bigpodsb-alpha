ARG FEDORA_MAJOR_VERSION
ARG IMAGE_TYPE
FROM ghcr.io/ublue-os/bluefin${IMAGE_TYPE}:${FEDORA_MAJOR_VERSION}

COPY etc /etc

RUN rpm-ostree override remove evince-djvu evince-libs evince-previewer evince-thumbnailer gnome-user-docs
RUN rpm-ostree override remove vim-minimal virtualbox-guest-additions yelp yelp-libs yelp-xsl gnome-user-share
RUN rpm-ostree install code chromium fish iotop plasma-workspace-wallpapers dbus-x11 htop breeze-cursor-theme direnv cascadia-code-fonts dotnet-sdk-7.0
RUN rpm-ostree install qemu qemu-user-static qemu-user-binfmt virt-manager libvirt qemu qemu-user-static qemu-user-binfmt edk2-ovmf
RUN rpm-ostree install cockpit-bridge cockpit-system cockpit-networkmanager cockpit-selinux cockpit-storaged cockpit-podman cockpit-machines cockpit-pcp 
RUN rpm-ostree install dconf-editor mediawriter vlc ceph-common python3-qt5 hplip-gui flatpak-builder neofetch code-insiders gnome-console
RUN wget https://github.com/loft-sh/devpod/releases/latest/download/DevPod_linux_x86_64.rpm -O /tmp/devpod.rpm
RUN rpm-ostree install /tmp/devpod.rpm
RUN wget https://github.com/loft-sh/devpod/releases/latest/download/devpod-linux-amd64 -O /tmp/devpod
RUN install -c -m 0755 /tmp/devpod /usr/bin
RUN rpm-ostree override remove rpmfusion-free-release rpmfusion-nonfree-release
RUN systemctl enable podman.service
RUN rm -rf /tmp/* /var/*
RUN ostree container commit
