
# Installfest!

##Before you start...

We will be installing multiple applications.  The installation steps will be provided for each application.

You should be able to copy and paste the lines into Terminal -- except for a few that have obvious prompts in them, like "YOUR NAME", which you should replace accordingly.

The lines below all start with `$`, but **you shouldn't actually write the `$`.** Its purpose is just to make the starts of lines easy to see in these instructions.

We recommend that you configure your system so that you can see both the instructions and Terminal at the same time.

## Open Terminal "app"

If you haven't done so already, open Terminal so you can begin entering commands.

You can open Terminal by:
- typing "Terminal" into Spotlight (ensure you select the Termainl app)
- or you can open it from Finder, look in "Applications > Utilities".
    
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
        
## PostgreSQL (A Database)

- Go to www.postgresapp.com
- Click 'Download'
- "Unzip" the file that downloads. (Double-click on it.)
- Move the Postgres.app to your 'Applications' folder.
- Double-click on Postgres.app
- Be able to open Postgres from the command line:
  - `$ echo "export PATH=$PATH:/Applications/Postgres.app/Contents/Versions/9.4/bin" >> ~/.bash_profile`
          
## RVM (Ruby Version Manager)

First, check to see if you have `rbenv` installed already, since this conflicts with `rvm`:

    $ which rbenv

If the output is anything other than blank, get an instructor to help you uninstall.


Otherwise, go ahead and install RVM:

    $ \curl -sSL https://get.rvm.io | bash -s stable --auto-dotfiles

Then **CLOSE and REOPEN** the Terminal.


### You know it worked if...
The output of `$ type rvm | head -n 1` is `rvm is a function`.  # as recommended in https://rvm.io/rvm/install
## ruby

    $ rvm get stable
    $ rvm install 2.2.1
    $ rvm use 2.2.1 --default

Then, **CLOSE and REOPEN the terminal** to ensure the terminal is using these changes.


### You know it worked if...

* The output of `$ ruby --version` **starts** with `ruby 2.2.1p85`.
        
## git
    $ brew install git

### You know it worked if...
The output of `git --version` is greater than or equal to 2.0

## Configure Git

### Personalize git
    $ git config --global user.name  "YOUR NAME"'
    $ git config --global user.email "YOUR@EMAIL.COM"'
          

### You can copy & paste all of these commands at once:
    git config --global color.ui always
    git config --global color.branch.current   "green reverse"
    git config --global color.branch.local     green
    git config --global color.branch.remote    yellow
    git config --global color.status.added     green
    git config --global color.status.changed   yellow
    git config --global color.status.untracked red


### Tell git what editor to use for commits

    $ git config --global core.editor "atom --wait"

OR (for sublime)

    $ git config --global core.editor "subl --wait --new-window"

## Github (The Social Network of Code)

- Go to Github.com and create an account. Make sure you add:
  - A profile picture
  - An e-mail address
- Go to http://auth.wdidc.org/ and follow the instructions
        
## slack

- Open "App Store"
- Install "Slack"
          

## Let's verify that everything was installed... programmatically.

    $ rake installfest:doctor

## Sign Up for GitHub

Complete the "sign up" steps at www.GitHub.com

Write your github username on the whiteboard.
