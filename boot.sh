#!/bin/bash

_check_python() {
  lib=$1
  python3 -c "import $lib" || (
    echo "Library $lib not installed!"
    exit 1
  )
}

_check_python pytmc || exit 1
_check_python ads_deploy || exit 1

# TODO: important for pip installed pytmc
PATH=$HOME/.local/bin/:$PATH
ADS_IOC=/home/Administrator/ads-ioc

BOOT=/usr/local/etc/TwinCAT/3.1/Boot/
CURRENT_CONFIG=/usr/local/etc/TwinCAT/3.1/Boot/CurrentConfig

WORKDIR=/tmp/source
IOCBOOT=${WORKDIR}/iocBoot

rm -rf ${WORKDIR}

set -xe
mkdir -p ${WORKDIR}
cd ${WORKDIR}
unzip -p ${BOOT}/CurrentConfig.tszip '*.tsproj' > boot.tsproj
unzip ${CURRENT_CONFIG}/*.tpzip

python3 -m ads_deploy iocboot \
  --ioc-template-path ~/ads-ioc/iocBoot/templates \
  --destination ./iocBoot \
  boot.tsproj

cd ${IOCBOOT}/ioc*
gmake PLC_HOSTNAME=localhost

${ADS_IOC}/bin/rhel7-x86_64/adsIoc ./st.cmd
