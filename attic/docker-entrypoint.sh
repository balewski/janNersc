#!/bin/bash

# using a short-hand version
[[ ! -z "${DOCENT_VERBOSE}" ]] && echo Image /srv/docker-entrypoint.sh

if [[ ! -z "${DOCENT_VERBOSE}" ]] ; then
    cat /etc/*release |grep PRETTY_NAME
    free -g
    echo "num-cpus: "`nproc --all`
    python3 -V    
    echo all entrypoint variables:
    env |grep DOCENT
fi

#example of image customization
#if [[ ! -z "${DOCENT_NEURON_BUILD}" ]] ; then
#    export PATH=${DOCENT_NEURON_BUILD}/nrn/bin:$PATH
#    export PYTHONPATH=${DOCENT_NEURON_BUILD}/nrn/lib/python/
#    [[ ! -z "${DOCENT_VERBOSE}" ]] &&  echo Image current PATH=$PATH, PYTHONPATH=$PYTHONPATH
#fi

# the last line is obligatory
exec "$@"
