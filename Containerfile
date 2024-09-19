
ARG FEDORA_MAJOR_VERSION
ARG IMAGE_TYPE
FROM cgr.dev/chainguard/helm:latest as helm
FROM cgr.dev/chainguard/kubectl:latest as kubectl

FROM fedora:39 AS copyfrom
RUN dnf install -y dotnet-sdk-7.0 --downloadonly
RUN mkdir /pkg
RUN cp /var/cache/dnf/updates-*/packages/* /pkg/

FROM ghcr.io/ublue-os/aurora${IMAGE_TYPE}:${FEDORA_MAJOR_VERSION}
ARG IMAGE_NAME="bigpodsb-bravo"
ARG IMAGE_VENDOR="bigpod98"
ARG IMAGE_TYPE
ARG IMAGE_FLAVOR=$IMAGE_TYPE
ARG FEDORA_MAJOR_VERSION
ARG BASE_IMAGE_NAME="ghcr.io/ublue-os/bluefin${IMAGE_TYPE}:${FEDORA_MAJOR_VERSION}"

COPY etc /etc

RUN wget https://copr.fedorainfracloud.org/coprs/ganto/lxc4/repo/fedora-"${FEDORA_MAJOR_VERSION}"/ganto-lxc4-fedora-"${FEDORA_MAJOR_VERSION}".repo -O /etc/yum.repos.d/ganto-lxc4-fedora-"${FEDORA_MAJOR_VERSION}".repo
COPY image-info.sh /tmp/image-info.sh
RUN bash /tmp/image-info.sh
RUN cat /tmp/image-info.sh
RUN echo $IMAGE_TYPE
RUN echo $IMAGE_FLAVOR
RUN rpm-ostree install code chromium fish iotopdbus-x11 htop breeze-cursor-theme direnv cascadia-code-fonts dotnet-sdk-8.0
RUN rpm-ostree install qemu qemu-user-static qemu-user-binfmt virt-manager libvirt qemu qemu-user-static qemu-user-binfmt edk2-ovmf
RUN rpm-ostree install cockpit-bridge cockpit-system cockpit-networkmanager cockpit-selinux cockpit-storaged cockpit-podman cockpit-machines cockpit-pcp 
RUN rpm-ostree install dconf-editor mediawriter vlc ceph-common python3-qt5 hplip-gui flatpak-builder neofetch code-insiders gnome-console azure-cli 
RUN rpm-ostree install lxc-libs rpmdevtools squashfs-tools incus incus-agent kde-connect git-filter-repo git-subtree
RUN rpm-ostree install containerd.io docker-ce docker-ce-cli docker-buildx-plugin docker-compose-plugin devpod
COPY --from=helm /usr/bin/helm /usr/bin/helm
COPY --from=kubectl /usr/bin/kubectl /usr/bin/kubectl
RUN systemctl enable podman.service
RUN systemctl disable node_exporter.service
RUN systemctl enable incus.service
RUN rm -rf /tmp/* /var/*
RUN ostree container commit
