#!/usr/bin/env bash

# This file lives in github pages so the reference url is "clean".  If we store this in the master branch, the url would be to "https://raw.githubusercontent..."

# download the shared Rakefile
curl --location https://raw.githubusercontent.com/ga-dc/installfest/master/Rakefile > Rakefile
# Download the config for THIS class
curl --location https://raw.githubusercontent.com/ga-dc/installfest/master/installfest_dc_wdi.yml > installfest.yml
# Start installfest
rake installfest:start
