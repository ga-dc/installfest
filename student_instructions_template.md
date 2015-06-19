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
