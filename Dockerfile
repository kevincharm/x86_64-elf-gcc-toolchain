FROM ubuntu:18.04

WORKDIR /

# install dependencies
RUN apt-get update && \
    # deps for gcc, binutils:
    apt-get install -y gcc wget build-essential python3 && \
    # deps for grub 2:
    apt-get install -y autoconf autoconf automake gettext \
    autopoint pkg-config grub-common libfreetype6-dev unifont flex bison && \
    apt-get install -y curl unzip && \
    apt-get install -y git

RUN wget https://github.com/lordmilko/i686-elf-tools/releases/download/7.1.0/x86_64-elf-tools-linux.zip
RUN unzip x86_64-elf-tools-linux.zip -d x86_64-elf-tools-linux && \
    cd x86_64-elf-tools-linux && \
    cp -r . /usr/local/

# specify binutils/gcc version
ENV DOWNLOAD_BINUTILS=binutils-2.35.1
ENV DOWNLOAD_GCC=gcc-10.2.0
ENV DOWNLOAD_GRUB=grub-2.04
ENV DOWNLOAD_XORRISO=xorriso-1.4.8

# specify TARGET
ENV TARGET=x86_64-elf
ENV PREFIX=/usr/local

# xorriso
RUN wget -q ftp://ftp.gnu.org/gnu/xorriso/$DOWNLOAD_XORRISO.tar.gz       && \
    tar -xzf $DOWNLOAD_XORRISO.tar.gz                                    && \
    cd /$DOWNLOAD_XORRISO                                                && \
    ./configure --prefix=/usr                                            && \
    make                                                                 && \
    make install                                                         && \
    rm -r /$DOWNLOAD_XORRISO

# grub 2
RUN wget -q ftp://ftp.gnu.org/gnu/grub/$DOWNLOAD_GRUB.tar.gz             && \
    tar -xzf $DOWNLOAD_GRUB.tar.gz                                       && \
    cd /$DOWNLOAD_GRUB                                                   && \
    export PYTHON=python3                                                && \
    ./autogen.sh                                                         && \
    mkdir -p /srv/build_grub                                             && \
    cd /srv/build_grub                                                   && \
    /$DOWNLOAD_GRUB/configure --disable-werror TARGET_CC=$TARGET-gcc        \
    TARGET_OBJCOPY=$TARGET-objcopy TARGET_STRIP=$TARGET-strip               \
    TARGET_NM=$TARGET-nm TARGET_RANLIB=$TARGET-ranlib                       \
    --target=$TARGET                                                     && \
    make                                                                 && \
    make install                                                         && \
    rm -r /$DOWNLOAD_GRUB /srv/build_grub

# GNU-EFI / EFI headers / EFI tools
RUN apt-get install -y gnu-efi
RUN apt-get install -y parted mtools

COPY mkbootimg /usr/bin/mkbootimg

# cleanup
RUN apt-get clean autoclean                                              && \
    apt-get autoremove -y                                                && \
    rm -rf /var/lib/apt /var/lib/dpkg /var/lib/cache /var/lib/log
