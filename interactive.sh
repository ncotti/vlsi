#!/bin/bash

## Launch an interactive terminal on the SSH server.

source "./.secrets.sh"
nanolab3_ssh="ssh -X -tt nanolab3"

sshpass -p "${pass}" ssh -o StrictHostKeyChecking=accept-new -X -C -tt "${user}@${ip}" \
    "/bin/bash -c 'sshpass -p ${pass} ${nanolab3_ssh}'"
