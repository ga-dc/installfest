# Installfest!

##Before you start...

Below are a bunch of commands to enter into Terminal, which is a way of interacting with your computer that doesn't use the fancy desktop interface you're used to.

You should be able to copy and paste the lines into Terminal -- except for a few that have obvious prompts in them, like "YOUR NAME", which you should replace accordingly.

The lines below all start with `$`, but **you shouldn't actually write the `$`.** Its purpose is just to make the starts of lines easy to see in these instructions.

##Terminal

Open Applications > Utilities > Terminal

## Atom Text Editor

[Download](https://atom.io)

## XCode CLI tools

    $ xcode-select --install

## Homebrew

    $ ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    $ brew update && brew upgrade
    $ echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.bash_profile

### You know it worked if...

The output of `which brew` is not `brew not found`
The output of `brew doctor` is `ready to brew`

## RVM

This checks to see if you have RVM installed already:

    $ which rbenv

If the output is anything other than blank, get an instructor to help you uninstall.

Otherwise, go ahead and install RVM:

    $ \curl -sSL https://get.rvm.io | bash

Then close and reopen the Terminal.

### You know it worked if...

The output of `$ which rvm` is not `rvm not found`

## Ruby v 2.2.0

    $ source ~/.rvm/scripts/rvm
    $ rvm install 2.2.0

Then, **close and reopen the terminal** to ensure the terminal is using these changes.

### You know it worked if...

* The output of `which ruby` is **not** `/usr/bin/ruby` and
* The output of `ruby --version` starts with `ruby 2.2.0p0`.

## Git

    $ brew install git

### You know it worked if...

The output of `git --version` is greater than or equal to 2.0

## Configure Git

    $ git config --global user.name  "YOUR NAME"
    $ git config --global user.email "YOUR@EMAIL.COM"
    $ git config --global color.ui always
    $ git config --global color.branch.current   "green reverse"
    $ git config --global color.branch.local     green
    $ git config --global color.branch.remote    yellow
    $ git config --global color.status.added     green
    $ git config --global color.status.changed   yellow
    $ git config --global color.status.untracked red
    $ git config --global core.editor "atom --wait"

## Let's verify that everything was installed... programmatically.

Run the following commands, sequentially, to download the `Rakefile` and run the appropriate `rake` command.:

    $ brew install curl
    $ curl https://raw.githubusercontent.com/ga-students/wdi_dc5/master/Rakefile?token=AAB8uRz3KXIgO9dtuCh8LW-6vyl6GzfRks5U_yBYwA%3D%3D > Rakefile
    $ rake installfest:doctor

## Sign Up for GitHub

Complete the "sign up" steps at www.GitHub.com

Write your github username on the whiteboard.
