#!/usr/bin/env bash

# download the shared Rakefile
curl --location https://raw.githubusercontent.com/ga-dc/installfest/master/Rakefile > Rakefile
# Download the config for linux
curl --location https://raw.githubusercontent.com/ga-dc/installfest/master/installfest_dc_wdi_linux.yml > installfest.yml
