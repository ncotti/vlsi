#!/bin/bash

## Launch the Synopsys IDE

source "./.secrets.sh"
nanolab3_ssh="ssh -X -C nanolab3 ./synopsys.sh"

sshpass -p "${pass}" ssh -o StrictHostKeyChecking=accept-new -X -C -tt "${user}@${ip}" \
    "/bin/bash -c 'sshpass -p ${pass} ${nanolab3_ssh}'"


