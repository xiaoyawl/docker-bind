#!/bin/bash
#########################################################################
# File Name: entrypoint.sh
# Author: LookBack
# Email: admin#dwhd.org
# Version:
# Created Time: 2016年12月31日 星期六 18时24分32秒
#########################################################################

set -e

NAMED_CONF_DIR=${NAMED_CONF_DIR:-${INSTALL_DIR}/etc}
NAMED_CONF_FILE=${NAMED_CONF_FILE:-${NAMED_CONF_DIR}/named.conf}

[[ ! "${1:0:1}" == 'named' ]] && set -- named "$@"
[[ ! -d ${INSTALL_DIR}/bind ]] && mkdir -p ${INSTALL_DIR}/var/bind
#[[ ! -f ${INSTALL_DIR}/bind/named.ca ]] && mv ${NAMED_CONF_DIR}/named.ca ${INSTALL_DIR}/var/bind

set -- "${@}" -4 -g -c ${NAMED_CONF_FILE}

exec "${@}"
