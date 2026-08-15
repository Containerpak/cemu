FROM ubuntu:26.04 AS source

ADD --checksum=sha256:0c20c4aeb800bb13d9bab9474ef45a6f8fcde6402cad9b32ac2a1bbd03186313 https://github.com/cemu-project/Cemu/releases/download/v2.6/Cemu-2.6-x86_64.AppImage /tmp/app.AppImage

RUN chmod 0755 /tmp/app.AppImage && \
    cd /tmp && \
    ./app.AppImage --appimage-extract >/dev/null && \
    mkdir -p /stage && \
    cp -a /tmp/squashfs-root/. /stage/

FROM ghcr.io/containerpak/gtk3:main

LABEL org.opencontainers.image.source="https://github.com/Containerpak/cemu"

RUN apt-get update && \
    apt-get install -y --no-install-recommends libice6 libopengl0 libsm6 && \
    cpak-clean-junk

COPY --from=source /stage/ /opt/cemu/
COPY cemu /usr/bin/cemu
COPY cemu.desktop /usr/share/applications/cemu.desktop
COPY icon.png /usr/share/icons/hicolor/128x128/apps/cemu.png

RUN chmod 0755 /usr/bin/cemu && cpak-clean-junk
