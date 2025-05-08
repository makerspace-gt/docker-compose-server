#!/bin/bash

# Make sure we're in the same venv as the Ansible-devc-feature,
# as this is where molecule was installed in
source /usr/local/py-utils/venvs/ansible-core/bin/activate
molecule test
