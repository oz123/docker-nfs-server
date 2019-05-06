#!/bin/bash

set -e

# read an exports list from an environment variable
# the list can be separated with a ';' e.g:
# /path/to/share;/path/to/share2/;path/to/shareN
if [ -n ${EXPORTS} ]; then
   IFS=$';'
fi

# alternatively, accept a mount list from command line
# e.g. docker run /path/to/share /path/to/share2 /path/to/shareN
EXPORTS=${EXPORTS:-$@}


echo "#NFS Exports" > /etc/exports

for mnt in ${EXPORTS}; do
  src=$(echo $mnt | awk -F':' '{ print $1 }')
  mkdir -p $src
  echo "$src *(rw,sync,no_subtree_check,fsid=0,no_root_squash)" >> /etc/exports
done

exec runsvdir /etc/sv
