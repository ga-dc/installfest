
## Welcome to Installfest - for Linux!

Until our scripts have been updated to work with Linux, you will be ignoring the class-wide instructions and following the instructions below.
          
## Before you start...

Today, you will be installing the basic software you need for the class.

If you have ANY questions, raise your hand for assistance.

1. You will be reading instructions from one Terminal window and
2. Entering these commands into *another* Terminal window.
** If you don't have the additional Terminal open, do so now. **


Each package will list the installation steps.

Read through every instruction carefully and follow them to the letter.

You should be able to copy and paste the lines into Terminal.
With these exceptions:
- If you see all capitals (like "YOUR NAME"), replace this placeholder with your appropriate information.
- Commands will start with a dollar sign (`$`),
but you should NOT actually copy/type the `$` into your Terminal.
The dollar sign is a standard convention to indicate a bash (terminal) command.
          
## Go Rails (Installing ruby & rails)

1. Browse to https://gorails.com/setup/ubuntu
2. Choose your specific version of Ubuntu.
3. Installing Ruby:
  - Choose the most recent version of ruby.
  - Choose "Using rvm"
  - Install rvm and ruby
4. Configuring Git: follow all instructions
5. Installing Rails
  - Choose the most recent version of Rails and follow the instructions.
6. Setting up MySQL: SKIP this section
7. Setting Up PostgreSQL: follow all instructions
8. Final Steps: optional.
          
## "Atom" Text Editor

1. Download atom [from their website](https://atom.io) and install.
2. Run "atom".  From the "Atom" menu, select "Install Shell Commands".
3. Then configure your terminal to use 'atom'.

    $ echo "EDITOR=atom" >> ~/.bash_profile

## Slack for linux (Scud Cloud)

1. Install Scud Cloud
          
## git
    $ brew install git

### You know it worked if...
The output of `git --version` is greater than or equal to 2.0

## Configure Git

1. Personalize git
    $ git config --global user.name  "YOUR FULL NAME"
    $ git config --global user.email "THE_EMAIL_YOU_USE_FOR_GITHUB@EMAIL.COM"
          

2. You can copy & paste all of these commands at once:
    git config --global color.ui always
    git config --global color.branch.current   "green reverse"
    git config --global color.branch.local     green
    git config --global color.branch.remote    yellow
    git config --global color.status.added     green
    git config --global color.status.changed   yellow
    git config --global color.status.untracked red


3. Tell git what editor to use for commits

  3a. If you chose to use sublime:

    $ git config --global core.editor "subl --wait --new-window"

  3b. OR, if you are using atom (the default):

    $ git config --global core.editor "atom --wait"


## Github (The Social Network of Code)

1. Go to Github.com and create an account. Make sure you update your Profile with:
  - Your Name
  - A recognizable profile picture
  - An e-mail address

2. Add it to your system configuration:

    $ echo "export GITHUB_USERNAME='YOUR GITHUB USERNAME'" >> ~/.bash_profile
        
## Authorize WDI to use your github info

1. Go to http://auth.wdidc.org/ and follow the instructions
        

## Let's verify that everything was installed... programmatically.

    $ rake installfest:doctor
