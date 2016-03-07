# Installfest Tasks

![Installfest logo](installfest_logo.png)

A collection of supporting (rake) tasks for Installfest.

Students should be able to download (or `curl`) and run this independently.  We are using installfest.sh to achieve this.

[![Dependency Status](https://gemnasium.com/ga-dc/installfest.svg)](https://gemnasium.com/ga-dc/installfest)

Travis CI ![Travis CI](https://travis-ci.org/ga-dc/installfest.svg?branch=master)


## Managing Student Instructions

The base readme.md provides instructions for students.
In order to simplify the instructions, we are using a shortened url for `https://raw.githubusercontent.com/ga-dc/installfest/master/installfest.sh`

## tldr
- packages to install are configured via installfest.yml (should be a "template" for your class)
- `rake installfest:start` will:
   - loop thru each package in installfest.yml (), for each package...
     - check to see if package is installed correctly.
     - if so, next package
     - if not, provide instructions.  
      - Once the students hits enter, to indicate they have completed instructions,
        - reload bash (to load new configuration) and
        - restart process


## For developers

- Help
  ```
  rake -T
  ```

- Generate instructions
  ```
  rake installfest:instructions > installfest.md
  ```

- You can debug using `--execute-continue`:
```
rake -E "require 'pry'" installfest:start
# or
rake -E "require 'debugger'" installfest:start
```

- You can skip the initial instructions header via SKIP_HEADER:
```
rake installfest:start SKIP_HEADER=true
```

### For linux

```
cp installfest_dc_wdi_linux.yml installfest.yml
rake installfest:instructions > installfest_linux.md
```


### Configuration

installfest.yml is a list of which packages are expected to be installed, in what order.  The list can contain any known package.  The current practice is to maintain one for each class (e.g. installfest_dc_wdi.yml) which is copied to `installfest.yml`.

**NOTE:** Make sure you update **your** installfest.yml whenever your class's template changes.

Generate a sample config via:

    rake installfest:generate_config_file

List all possible packages via:

    rake installfest:known



### Architecture:
All required functionality is in this single Rakefile;
the rake tasks, the supporting library code, and the tests.
This is by design; to make it easier to install and use, at the expense of readability.  As stated, students should be able to `curl` and run this independently.  

### Important methods
- Installfest#my_packages lists all packages of interest to you.
- Installfest#packages lists all known packages, with supporting info.
- Installfest#assert_* are the various assertion methods.
