# Installfest Tasks

![Installfest logo](installfest_logo.png)

A collection of supporting (rake) tasks for Installfest.

Students should be able to download (or `curl`) and run this independently.

[![Dependency Status](https://gemnasium.com/ga-dc/installfest.svg)](https://gemnasium.com/ga-dc/installfest)

## Sample Student Instructions
Here are the instructions we provided our **students** during Installfest

`>>>>>>>>>>>>>>`

You will be using 'rake', a ruby tool for managing commands.

Run the following commands, sequentially, to download the `Rakefile`, download the config file, and run the appropriate `rake` command to start installfest:

1. Change to the appropriate directory:
  ```
  $ cd ~/dev/ga/wdi6 # suggested
  ```

2. Download the rakefile:
  ```
  $ curl --location http://git.io/vL4KB > Rakefile
  ```

3. Download the appropriate config file.
  ```
  $ curl --location {{your config file goes here}} > installfest.yml
  ```
  e.g. DC WDI
  ```
  $ curl --location https://raw.githubusercontent.com/ga-dc/installfest/master/installfest_dc_wdi.yml > installfest.yml
  ```

4. You can either run a script to step through the installation steps:
  ```
  $ rake installfest:start
  ```
Or get the full instruction set:
  ```
  $ open installfest.md
  ```

5. Read and follow the given instructions.

`<<<<<<<<<<<<<<`

## For developers

- Help
  ```
  rake -T
  ```

- Generate instructions
  ```
  rake installfest:instructions > installfest.md
  ```

### Configuration

installfest.yml is a list of which packages are expected to be installed, in what order.  The list can contain any known package.

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
