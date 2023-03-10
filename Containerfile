ARG FEDORA_MAJOR_VERSION
ARG IMAGE_TYPE
FROM ghcr.io/ublue-os/bluefin${IMAGE_TYPE}:${FEDORA_MAJOR_VERSION}

COPY etc /etc

RUN rpm-ostree override remove evince-djvu evince-libs evince-previewer evince-thumbnailer gnome-tour gnome-user-docs
RUN rpm-ostree override remove vim-minimal virtualbox-guest-additions yelp yelp-libs yelp-xsl blackbox-terminal
RUN rpm-ostree install code chromium fish iotop plasma-workspace-wallpapers qemu qemu-user-static qemu-user-binfmt
RUN rm -f /etc/yum.repos.d/vscode.repo
RUN ostree container commit
