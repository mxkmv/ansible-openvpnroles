#!/bin/bash

KEY_DIR=~/openvpn-ca/keys
OUTPUT_DIR=~/clients/files
BASE_CONFIG=~/clients/base.conf
BUILD_KEY=~/openvpn-ca
CLICONF=~/clients
ANS=/etc/ansible

cd ${BUILD_KEY}
source vars
./build-key --batch ${1}

cat ${BASE_CONFIG} \
    <(echo -e '<ca>') \
    ${KEY_DIR}/ca.crt \
    <(echo -e '</ca>\n<cert>') \
    ${KEY_DIR}/${1}.crt \
    <(echo -e '</cert>\n<key>') \
    ${KEY_DIR}/${1}.key \
    <(echo -e '</key>\n<tls-auth>') \
    ${KEY_DIR}/tiv.key \
    <(echo -e '</tls-auth>') \
    > ${OUTPUT_DIR}/${1}.ovpn

#ls ${OUTPUT_DIR}

cd ${ANS}
ansible-playbook opensert.yml
