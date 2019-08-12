#!/bin/bash

HTSLIB_RELEASE="1.9"
SAMTOOLS_RELEASE="1.9"
BCFTOOLS_RELEASE="1.9"
FUSERA_RELEASE="v0.0.18"

TEMP_DEPENDENCIES=(build-essential libbz2-dev liblzma-dev libncurses5-dev zlib1g-dev)
SOFTWARE=(bzip2 curl libcurl4-gnutls-dev liblzma5 libncurses5 tcsh fuse gzip wget xz-utils zlib1g zstd)

install_htslib() {
    curl -L -o /tmp/htslib-$HTSLIB_RELEASE.tar.bz2 https://github.com/samtools/htslib/releases/download/$HTSLIB_RELEASE/htslib-$HTSLIB_RELEASE.tar.bz2
    tar -xvjf /tmp/htslib-$HTSLIB_RELEASE.tar.bz2 -C /tmp
    cd /tmp/htslib-$HTSLIB_RELEASE/ || exit
    /tmp/htslib-$HTSLIB_RELEASE/./configure && cd ~ || exit
    make -j5 -C /tmp/htslib-$HTSLIB_RELEASE
    make install -C /tmp/htslib-$HTSLIB_RELEASE
}

install_samtools() {
    curl -L -o /tmp/samtools-$SAMTOOLS_RELEASE.tar.bz2 https://github.com/samtools/samtools/releases/download/$SAMTOOLS_RELEASE/samtools-$SAMTOOLS_RELEASE.tar.bz2
    tar -xvjf /tmp/samtools-$SAMTOOLS_RELEASE.tar.bz2 -C /tmp
    cd /tmp/samtools-$SAMTOOLS_RELEASE/ || exit
    /tmp/samtools-$SAMTOOLS_RELEASE/./configure && cd ~ || exit
    make -j5 -C /tmp/samtools-$SAMTOOLS_RELEASE
    make install -C /tmp/samtools-$SAMTOOLS_RELEASE
}

install_bcftools() {
    curl -L -o /tmp/bcftools-$BCFTOOLS_RELEASE.tar.bz2 https://github.com/samtools/bcftools/releases/download/$BCFTOOLS_RELEASE/bcftools-$BCFTOOLS_RELEASE.tar.bz2
    tar -xvjf /tmp/bcftools-$BCFTOOLS_RELEASE.tar.bz2 -C /tmp
    cd /tmp/bcftools-$BCFTOOLS_RELEASE/ || exit
    /tmp/bcftools-$BCFTOOLS_RELEASE/./configure && cd ~ || exit
    make -j5 -C /tmp/bcftools-$BCFTOOLS_RELEASE
    make install -C /tmp/bcftools-$BCFTOOLS_RELEASE
}

setup_bwakit() {
    curl -L -o /tmp/bwakit-0.7.15_x64-linux.tar.bz2 https://sourceforge.net/projects/bio-bwa/files/bwakit/bwakit-0.7.15_x64-linux.tar.bz2
    tar -xvjf /tmp/bwakit-0.7.15_x64-linux.tar.bz2 -C /tmp
    curl -L -o /tmp/bwa.kit/run-gen-ref https://raw.githubusercontent.com/lh3/bwa/master/bwakit/run-gen-ref
    mkdir -p /reference /root/.cache/hts-ref
    cd /reference/ || exit
    /tmp/bwa.kit/./run-gen-ref hs38DH
    /tmp/samtools-$SAMTOOLS_RELEASE/misc/./seq_cache_populate.pl -root /root/.cache/hts-ref -subdirs 2 /reference/hs38DH.fa > seq.cache.idx
    bgzip hs38DH.fa
    samtools faidx hs38DH.fa.gz
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

    export DEBIAN_FRONTEND=noninteractive

    apt-get update && apt-get upgrade -y

    for package in "${TEMP_DEPENDENCIES[@]}"
    do
        apt-get install -y "$package"
    done

    for package in "${SOFTWARE[@]}"
    do
        apt-get install -y "$package"
    done
}

cleanup() {
    # Remove unused software packages
    for package in "${TEMP_DEPENDENCIES[@]}"
    do
        apt-get purge -y "$package"
    done

    apt-get autoremove -y

    # Remove APT lists
    rm -rf /var/lib/apt/lists/*
    rm -rf /tmp/*
}

setup
install_htslib
install_samtools
install_bcftools
install_fusera
setup_bwakit
cleanup
