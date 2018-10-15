#!/bin/bash

HTSLIB_RELEASE="1.9"
SAMTOOLS_RELEASE="1.9"
BCFTOOLS_RELEASE="1.9"
FUSERA_RELEASE="v0.0.13"

install_htslib() {
    curl -L -o /tmp/htslib-$HTSLIB_RELEASE.tar.bz2 https://github.com/samtools/htslib/releases/download/1.9/htslib-$HTSLIB_RELEASE.tar.bz2
    tar -xvjf /tmp/htslib-$HTSLIB_RELEASE.tar.bz2 -C /tmp
    cd /tmp/htslib-$HTSLIB_RELEASE/
    sudo /tmp/htslib-$HTSLIB_RELEASE/./configure && cd ~
    sudo make -j5 -C /tmp/htslib-$HTSLIB_RELEASE
    sudo make install -C /tmp/htslib-$HTSLIB_RELEASE
}

install_samtools() {
    curl -L -o /tmp/samtools-$SAMTOOLS_RELEASE.tar.bz2 https://github.com/samtools/samtools/releases/download/1.9/samtools-$SAMTOOLS_RELEASE.tar.bz2
    tar -xvjf /tmp/samtools-$SAMTOOLS_RELEASE.tar.bz2 -C /tmp
    cd /tmp/samtools-$SAMTOOLS_RELEASE/
    sudo /tmp/samtools-$SAMTOOLS_RELEASE/./configure && cd ~
    sudo make -j5 -C /tmp/samtools-$SAMTOOLS_RELEASE
    sudo make install -C /tmp/samtools-$SAMTOOLS_RELEASE
}

install_bcftools() {
    curl -L -o /tmp/bcftools-$BCFTOOLS_RELEASE.tar.bz2 https://github.com/samtools/bcftools/releases/download/1.9/bcftools-$BCFTOOLS_RELEASE.tar.bz2
    tar -xvjf /tmp/bcftools-$BCFTOOLS_RELEASE.tar.bz2 -C /tmp
    cd /tmp/bcftools-$BCFTOOLS_RELEASE/
    sudo /tmp/bcftools-$BCFTOOLS_RELEASE/./configure && cd ~
    sudo make -j5 -C /tmp/bcftools-$BCFTOOLS_RELEASE
    sudo make install -C /tmp/bcftools-$BCFTOOLS_RELEASE
}

install_fusera() {
    sudo curl -L -o /usr/local/bin/fusera https://github.com/mitre/fusera/releases/download/$FUSERA_RELEASE/fusera
    sudo curl -L -o /usr/local/bin/sracp https://github.com/mitre/fusera/releases/download/$FUSERA_RELEASE/sracp

    sudo chmod +x /usr/local/bin/fusera
    sudo chmod +x /usr/local/bin/sracp
}

setup() {
    echo "Waiting for Ubuntu to initialize..."
    sleep 30

    sudo apt-get update && sudo apt-get upgrade -y
    sudo apt-get install -y build-essential bzip2 curl fuse gzip libbz2-dev liblzma-dev libncurses5-dev xz-utils zlib1g-dev zstd
}

setup
install_htslib
install_samtools
install_bcftools
install_fusera
