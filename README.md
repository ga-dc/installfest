# InstallFest Tasks

A collection of supporting tasks for InstallFest.

Students should be able to `curl` and run this independently.

## Docs

     rake -T

## Configuration

installfest.yml is a list, containing any known package.

Generate a sample config via:

    rake installfest:generate_config_file

List all possible pacakages via:

    rake installfest:known


## Architecture:
All required functionality is in this single Rakefile;
the rake tasks, the supporting library code, and the tests.
This is by design; to make it easier to install and use, at the expense of readability.  Students should be able to `curl` and run this independently.  

## Important methods
- InstallFest#my_packages lists all packages of interest to you.
- InstallFest#packages lists all known packages, with suppporting info.
- InstallFest#assert_* are the various assertion methods.
