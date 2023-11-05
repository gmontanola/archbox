FROM quay.io/toolbx-images/archlinux-toolbox:latest

LABEL com.github.containers.toolbox="true" \
      usage="This image is meant to be used with the toolbox or distrobox command" \
      summary="A cloud-native terminal experience" \
      maintainer="gabriel@montanola.com"

COPY extra-packages /
RUN sed -i '/en_US.UTF-8 UTF-8/s/^#//g' /etc/locale.gen \
    && locale-gen \
    && pacman -R mlocate --noconfirm \
    && pacman -Syu --needed --noconfirm - < extra-packages \
    && rm -rf /extra-packages \
    && pacman -Scc --noconfirm \
    && rm -rf /var/cache/pacman/pkg/*

ARG AUR_USER=builduser
ARG HELPER=yay
ADD scripts/add-aur.sh /root
RUN bash /root/add-aur.sh "${AUR_USER}" "${HELPER}"

RUN   ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/docker && \
      ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/flatpak && \
      ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/podman && \
      ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/rpm-ostree
