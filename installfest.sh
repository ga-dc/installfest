#!/usr/bin/env bash

# This file lives in github pages so the reference url is "clean".  If we store this in the master branch, the url would be to "https://raw.githubusercontent..."

# download the shared Rakefile
curl --location https://git.generalassemb.ly/raw/DC-WDI/Installfest/master/Rakefile > Rakefile
# Download the config for THIS class
curl --location https://git.generalassemb.ly/raw/DC-WDI/installfest/master/installfest_dc_wdi.yml > installfest.yml
