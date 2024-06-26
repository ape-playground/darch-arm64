FROM agners/archlinuxarm-arm64v8

WORKDIR /archlinux

RUN mkdir -p /archlinux/rootfs

COPY agners/pacstrap-docker /archlinux/

RUN ./pacstrap-docker /archlinux/rootfs \
	bash sed gzip pacman

# Remove current pacman database, likely outdated very soon
RUN rm rootfs/var/lib/pacman/sync/*

FROM scratch
COPY --from=0 /archlinux/rootfs/ /
COPY agners/rootfs/ /

ENV LANG=en_US.UTF-8

RUN locale-gen
RUN pacman-key --init
RUN pacman-key --populate archlinuxarm

CMD ["/usr/bin/bash"]