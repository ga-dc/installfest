
# Installfest!

## Before you start...

We will be installing multiple applications.  The installation steps will be provided for each application.

You should be able to copy and paste the lines into Terminal -- except for a few that have obvious prompts in them, like "YOUR NAME", which you should replace accordingly.

Many instructions start with dollar a sign (`$`).  The dollar sign is a convention used to indicate a bash (terminal) command.  You **should not** actually write the `$`.

We recommend that you configure your system so that you can see both the instructions and Terminal at the same time.

## Open Terminal "app"

If you haven't done so already, open Terminal so you can begin entering commands.

You can open Terminal by:
- typing "Terminal" into Spotlight (ensure you select the Terminal app)
- or you can open it from Finder, look in "Applications > Utilities".
    

## "Atom" Text Editor

1. Download atom [from their website](https://atom.io) and install.
2. Run "atom".  From the "Atom" menu, select "Install Shell Commands".
3. Then configure your terminal to use 'atom'.  This command appends the text "EDITOR=atom" to a config file.
```
$ echo "EDITOR=atom" >> ~/.bash_profile
```



## XCode CLI tools

1. Install the XCode CLI tools
```
$ xcode-select --install
```
          


## Homebrew (OSX's Package Manager)

1. Download and install Homebrew:
  ```
  $ ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  ```
2. Ensure you have the latest version of everything
  ```
  $ brew update && brew upgrade
  ```
3. ensure apps installed via Homebrew will be found via your Path.
  ```
  $ echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.bash_profile
  ```
          

### You know it worked if...


- The output of `$ which brew` is `/usr/local/bin/brew`.
- The output of `$ brew doctor` is `ready to brew`
        


## PostgreSQL (A Database)

1. Download Postgres.app from www.postgresapp.com
2. Move the Postgres.app to your 'Applications' folder.
3. Open the Postgres.app
  -  Look for the elephant in the the menu bar.
4. Configure bash to enable opening Postgres from the command line (via psql):
  ```
  $ echo 'export PATH=$PATH:/Applications/Postgres.app/Contents/Versions/9.4/bin' >> ~/.bash_profile
  ```
          


## RVM (Ruby Version Manager)

1. First, check to see if you have `rbenv` installed already, since this conflicts with `rvm`.  If the output of the following command is anything *other than* blank, get an instructor to help you uninstall.
  ```
  $ which rbenv
  ```

2. Otherwise, go ahead and install RVM:
  ```
  $ \curl -sSL https://get.rvm.io | bash -s stable --auto-dotfiles
  ```

3. Reload this shell, to initialize rvm.
  ```
  $ exec bash -l
  ```


### You know it worked if...

The output of `$ type rvm | head -n 1` is `rvm is a function`.  # as recommended in https://rvm.io/rvm/install


## ruby

1. Update rvm
    $ rvm get master

2. Install ruby
    $ rvm install 2.2.3

3. Configure your default version of ruby
    $ rvm use 2.2.3 --default


### You know it worked if...


* The output of `$ ruby --version` **starts** with `ruby 2.2.3p173`.
        


## slack

1. Install the free "Slack" app from the App Store
          


## git

```
$ brew install git
```
          

### You know it worked if...

The output of `git --version` is greater than or equal to 2.0


## Configure Git

1. Personalize git
  - Your Full Name:

    `$ git config --global user.name  "YOUR FULL NAME"`

  - The email in your github profile (https://github.com):

    `$ git config --global user.email "THE_EMAIL_YOU_USE_FOR_GITHUB@EMAIL.COM"`

2. Configure git's colors (you can copy & paste all of these commands at once):
  ```
  git config --global color.ui always
  git config --global color.branch.current   "green reverse"
  git config --global color.branch.local     green
  git config --global color.branch.remote    yellow
  git config --global color.status.added     green
  git config --global color.status.changed   yellow
  git config --global color.status.untracked red
  ```

3. Tell git what editor to use for commits

  3a. If you chose to use sublime:
  ```
  $ git config --global core.editor "subl --wait --new-window"
  ```

  3b. OR, if you are using atom (the default):
  ```
  $ git config --global core.editor "atom --wait"
  ```



## Github (The Social Network of Code)

If you don't have a github account:
  - Go to https://github.com and create an account.

We use information from your github account throughout the class.

1. Make sure you update your Profile with:
  - Your Name
  - A recognizable profile picture
  - An e-mail address

2. Add your github username to your system configuration (replacing "YOUR GITHUB USERNAME"):

  `$ echo "export GITHUB_USERNAME='YOUR GITHUB USERNAME'" >> ~/.bash_profile`
        


## bash_prompt
Update your prompt to show which git branch your are in.

1. Install the bash-completion script.
```
$ brew install bash-completion
```
          

2. Configure your prompt to show you working dir and git branch.
  - Open your `~/.bash_profile` file in atom.
  ```
  atom ~/.bash_profile
  ```

  - Copy and paste these lines to your ~/.bash_profile, prior to `[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*`:
  ```
  if  [ -f $(brew --prefix)/etc/bash_completion ]; then
    source $(brew --prefix)/etc/bash_completion
  fi

  if  [ -f $(brew --prefix)/etc/bash_completion.d/git-prompt.sh ]; then
    source $(brew --prefix)/etc/bash_completion.d/git-prompt.sh
    GIT_PS1_SHOWDIRTYSTATE=1 # display the unstaged (*) and staged (+) indicators
    # set your prompt. path: \w, git branch & status: $(__git_ps1), newline: \n, dollar sign delimiter: \$
    PS1='\w$(__git_ps1) \n\$ '
  fi
  ```
          

3. Sample prompt (context: in "installfest" dir, branch is "master" with unstaged changes):
~/dev/ga/apps/installfest (master *)
$
          

### You know it worked if...

You see the current git branch in your prompt, when you navigate to a directory within a git repository.


## Authorize WDI to use your github info

1. Go to http://auth.wdidc.org/ and follow the instructions
        


## Let's verify that everything was installed... programmatically.

    $ rake installfest:doctor
