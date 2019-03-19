#!/bin/bash

HTSLIB_RELEASE="1.9"
SAMTOOLS_RELEASE="1.9"
BCFTOOLS_RELEASE="1.9"
FUSERA_RELEASE="v0.0.16"

install_htslib() {
    curl -L -o /tmp/htslib-$HTSLIB_RELEASE.tar.bz2 https://github.com/samtools/htslib/releases/download/1.9/htslib-$HTSLIB_RELEASE.tar.bz2
    tar -xvjf /tmp/htslib-$HTSLIB_RELEASE.tar.bz2 -C /tmp
    cd /tmp/htslib-$HTSLIB_RELEASE/
    /tmp/htslib-$HTSLIB_RELEASE/./configure && cd ~
    make -j5 -C /tmp/htslib-$HTSLIB_RELEASE
    make install -C /tmp/htslib-$HTSLIB_RELEASE
}

install_samtools() {
    curl -L -o /tmp/samtools-$SAMTOOLS_RELEASE.tar.bz2 https://github.com/samtools/samtools/releases/download/1.9/samtools-$SAMTOOLS_RELEASE.tar.bz2
    tar -xvjf /tmp/samtools-$SAMTOOLS_RELEASE.tar.bz2 -C /tmp
    cd /tmp/samtools-$SAMTOOLS_RELEASE/
    /tmp/samtools-$SAMTOOLS_RELEASE/./configure && cd ~
    make -j5 -C /tmp/samtools-$SAMTOOLS_RELEASE
    make install -C /tmp/samtools-$SAMTOOLS_RELEASE
}

install_bcftools() {
    curl -L -o /tmp/bcftools-$BCFTOOLS_RELEASE.tar.bz2 https://github.com/samtools/bcftools/releases/download/1.9/bcftools-$BCFTOOLS_RELEASE.tar.bz2
    tar -xvjf /tmp/bcftools-$BCFTOOLS_RELEASE.tar.bz2 -C /tmp
    cd /tmp/bcftools-$BCFTOOLS_RELEASE/
    /tmp/bcftools-$BCFTOOLS_RELEASE/./configure && cd ~
    make -j5 -C /tmp/bcftools-$BCFTOOLS_RELEASE
    make install -C /tmp/bcftools-$BCFTOOLS_RELEASE
}

install_fusera() {
    curl -L -o /usr/local/bin/fusera https://github.com/mitre/fusera/releases/download/$FUSERA_RELEASE/fusera
    curl -L -o /usr/local/bin/sracp https://github.com/mitre/fusera/releases/download/$FUSERA_RELEASE/sracp

    chmod +x /usr/local/bin/fusera
    chmod +x /usr/local/bin/sracp
}

setup() {
    echo "Waiting for Ubuntu to initialize..."
    sleep 30

    apt-get update && apt-get upgrade -y
    apt-get install -y build-essential bzip2 curl fuse gzip libbz2-dev liblzma-dev libncurses5-dev xz-utils zlib1g-dev zstd
}

setup
install_htslib
install_samtools
install_bcftools
install_fusera
