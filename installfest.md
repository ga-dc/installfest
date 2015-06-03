
# Installfest!

##Before you start...

Below are a bunch of commands to enter into Terminal, which is a way of interacting with your computer that doesn't use the fancy desktop interface you're used to.

You should be able to copy and paste the lines into Terminal -- except for a few that have obvious prompts in them, like "YOUR NAME", which you should replace accordingly.

The lines below all start with `$`, but **you shouldn't actually write the `$`.** Its purpose is just to make the starts of lines easy to see in these instructions.

##Terminal

Open Applications > Utilities > Terminal
    
## "Atom" Text Editor

1. Download atom [from their website](https://atom.io) and install.
2. Then configure your terminal to use 'atom'.

    $ echo "EDITOR=atom" >> ~/.bash_profile

## XCode CLI tools
    $ xcode-select --install
## Homebrew (OSX's Package Manager)
    $ ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    $ brew update && brew upgrade
    $ echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.bash_profile
### You know it worked if...


- The output of `$ which brew` is `/usr/local/bin/brew`.
- The output of `$ brew doctor` is `ready to brew`
        
## RVM (Ruby Version Manager)

First, check to see if you have `rbenv` installed already, since this conflicts with `rvm`:

    $ which rbenv

If the output is anything other than blank, get an instructor to help you uninstall.


Otherwise, go ahead and install RVM:

    $ \curl -sSL https://get.rvm.io | bash -s stable --auto-dotfiles

Then **close and reopen** the Terminal.

### You know it worked if...

The output of `$ type rvm | head 1` is `rvm is a function`.  # as recommended in https://rvm.io/rvm/install
## Ruby

    $ source ~/.rvm/scripts/rvm
    $ rvm install 2.2.0

Then, **close and reopen the terminal** to ensure the terminal is using these changes.

### You know it worked if...


* The output of `which ruby` is `/usr/bin/ruby` and
* The output of `$ ruby --version` **starts** with `ruby 2.2.0p0`.
        
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


## Tell git what editor to use for commits

    $ git config --global core.editor "atom --wait"

OR (for sublime)

    $ git config --global core.editor "subl --wait --new-window"


## Let's verify that everything was installed... programmatically.

    $ rake installfest:doctor

## Sign Up for GitHub

Complete the "sign up" steps at www.GitHub.com

Write your github username on the whiteboard.
