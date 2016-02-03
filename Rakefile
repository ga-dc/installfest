# require 'pry-byebug'

# Architecture:
# All required functionality is in this single Rakefile;
#   the rake tasks, the supporting library code, and the tests.
# This is by design; to make it easier to install and use, at the expense of readability.

# Important methods
# Installfest#packages lists all known packages, with suppporting info.
# Installfest#assert_* are the various assertion methods.

require 'yaml'

########################
# Supporting Libraries
class Installfest
  class CommandResult
    attr_reader :status, :message
    def initialize(status, message)
      @status = !!status
      @message = message
    end

    def merge(other)
      status = @status && other.status
      messages = []
      if status
        messages << @message # either message is fine
      else
        # gather all failure messages
        messages << @message unless @status
        messages << other.message unless other.status
      end
      CommandResult.new(status, messages.join(';'))
    end

  end

  # TODO: extract Package
  def assert(boolean_expression, failure_message_for_actual, failure_message_for_expected)
    if boolean_expression
      return CommandResult.new(true, 'met')
    else
      message = "\nNOT met. Extra debugging info:"
      message += "\n  #{failure_message_for_actual}"
      message += "\n  #{failure_message_for_expected}"
      return CommandResult.new(false, colorize(message, :grey))
    end
  end

  def assert_equals(expected, shell_command)
    begin
      actual = `#{shell_command}`.chomp
      assert (actual == expected),
             "Actual result: '#{actual}' (via `#{shell_command}`)",
             "Should equal : '#{expected}'"
    rescue Errno::ENOENT => err # command not found, no such file/dir
     assert false, err, ''
    end
  end

  def assert_match(match_pattern, shell_command)
    begin
      value = `#{shell_command} 2>&1`.chomp
      assert (value =~ match_pattern),
             "Actual result: '#{value}' (via `#{shell_command}`)",
             "Should match : #{match_pattern.inspect}"
    rescue Errno::ENOENT => err # command not found, no such file/dir
      assert false, err, ''
    end
  end

  def assert_version_is_sufficient(target_version, shell_command)
    begin
      current_version = `#{shell_command}`.chomp
      result = (compare_versions(current_version, target_version) >= 0)
      assert result,
           "Actual version: v#{current_version} (via `#{shell_command}`)",
           "Should match  : v#{target_version}"
    rescue Errno::ENOENT => err # command not found, no such file/dir
      assert false, err, ''
    end
  end

  def check_gh_username
    if github_username.to_s.empty?
      persist_github_username(request_github_username)
    end
    cmd = "curl http://garnet.wdidc.org/users/#{github_username}/is_registered.json --silent"
    return cmd
  end

  def compare_versions(current_version, target_version)
    Gem::Version.new(current_version) <=> Gem::Version.new(target_version)
  end

  def config_file
    'installfest.yml'
  end

  def configured_packages
    YAML.load_file(config_file)
  rescue Errno::ENOENT
    fail "The config file (#{config_file}) is required. Your class should have a 'template' to copy."
  end

  def default_packages
    [editor, :homebrew, :rvm, :ruby, :git, :git_configuration]
  end

  def display_instructions
    puts instructions
  end

  # checks for valid installation
  def doctor
    configured_packages.each do |package_name|
      verify_package(package_name, packages[package_name])
    end
  end

  def editor
    case ENV['EDITOR']
    when 'subl'
      :sublime
    else
      :atom
    end
  end

  def instructions
    instructions = instruction_header
    configured_packages.each do |package_name|
      package = packages.fetch(package_name)
      package = {header: package_name}.merge(package)
      instructions += "\n"
      instructions += instructions_for(package)
      instructions += "\n"
    end
    instructions += "\n"
    instructions += instruction_footer

    instructions
  end

  def generate_config
    File.open(config_file, 'w') {|f| f.write default_packages.to_yaml }
  end

  # information about all packages
  # Package attributes:
  #   header: title of package (used for display)
  #   installation_steps: array of manual steps
  #   verify: code to assert step (method, *arguments)
  #   ykiwi (You Know It Worked If): manual verification
  def packages
    {
      authorize_wdi: {
        header: %q(Authorize WDI to use your github info),
        installation_steps: [
          %q(
1. Go to http://garnet.wdidc.org/github/authorize/
2. Click "Authorize Application" to allow GA to access to your public information.
        )],
        verify: -> { assert_match(/true/, check_gh_username) }
      },

      atom: {
        header: '"Atom" Text Editor',
        installation_steps: [
          %q(
1. Download atom [from their website](https://atom.io) and install.
2. Run "atom".  From the "Atom" menu, select "Install Shell Commands".
3. Then configure your terminal to use 'atom'.  This command appends the text "EDITOR=atom" to a config file.

    $ echo "EDITOR=atom" >> ~/.bash_profile
          )
        ],
        verify: -> { assert_version_is_sufficient('1.4.0', 'atom --version') }
      },

      bash_prompt: {
        header: "Bash Prompt (includes git branch)",
        installation_steps: [
          "Update your prompt to show which git branch you are in.",
          %q(
1. Install the bash-completion script.

    $ brew install bash-completion

2. Configure your prompt to show you working dir and git branch.
  - Open your `~/.bash_profile` file in atom.

    $ atom ~/.bash_profile


  - Copy and paste these lines to your ~/.bash_profile, prior to `[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*`:


    if  [ -f $(brew --prefix)/etc/bash_completion ]; then
      source $(brew --prefix)/etc/bash_completion
    fi

    if  [ -f $(brew --prefix)/etc/bash_completion.d/git-prompt.sh ]; then
      source $(brew --prefix)/etc/bash_completion.d/git-prompt.sh
      GIT_PS1_SHOWDIRTYSTATE=1 # display the unstaged (*) and staged (+) indicators
      # set your prompt. path: \w, git branch & status: $(__git_ps1), newline: \n, dollar sign delimiter: \$
      PS1='\w$(__git_ps1) \n\$ '
    fi

    This will change your bash prompt to something like this sample prompt (context: in "installfest" dir, branch is "master" with unstaged changes):

  ~/dev/ga/apps/installfest (master *)
  $
          ),
        ],
        verify: -> { assert_match(/git_ps1/, 'source ~/.bash_profile > /dev/null && echo $PS1') },
        ykiwi: "You see the current git branch in your prompt, when you navigate to a directory within a git repository."
      },

      disable_system_integrity_protection: {
        header: "El Capitan ONLY!!  Disable SIP (System Integrity Protection)",
        installation_steps: [
          %q(
1. Reboot into Recovery mode (Hold Cmd+R on boot) & access the Terminal.
2. Disable SIP:

    $ csrutil disable

3. Reboot back into OS X
4. Now that SIP is disabled, ensure Homebrew can write to the "/usr/local" directory:

    $ sudo mkdir /usr/local && sudo chflags norestricted /usr/local && sudo chown -R $(whoami):admin /usr/local
          )
        ],
        verify: -> {  case compare_versions(`sw_vers -productVersion`, '10.11.0')
                  when -1 # not El Capitan, pass test and skip this step.
                    assert true, nil, nil
                  when 0, 1 # is El Capitan, ensure /usr/local is writable
                    assert_match(/^$/, 'sudo touch /usr/local/wdi_test_sip_disabled.txt')
                  end
                }
      },

      git: {
        installation_steps: [
          %q(

    $ brew install git
          )
        ],
        verify: lambda do
          assert_version_is_sufficient(
            '2.7.0',
            'git --version | head -n1 | cut -f3 -d " "'
          ) # non-abbreviated flag names are not available in BSD
        end,
        ykiwi: "The output of `git --version` is greater than or equal to 2.0"
      },

      git_configuration: {
        header: 'Configure Git',
        installation_steps: [
          %q(
1. Personalize git
  - Your Full Name:

    $ git config --global user.name  "YOUR FULL NAME"

  - The email in your github profile (https://github.com):

    $ git config --global user.email "THE_EMAIL_YOU_USE_FOR_GITHUB@EMAIL.COM"

2. Configure the default push mode:

    $ git config --global push.default simple

3. Configure git's colors (you can copy & paste all of these commands at once):

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
          ),
        ],
        verify: -> { assert_match(/core.editor=#{editor} --wait/, 'git config --list | grep core.editor')}
      },

      github: {
        header: %q(Github (The Social Network of Code)),
        installation_steps: [
          %q(
If you don't have a github account:
  - Go to https://github.com and create an account.

We use information from your github account throughout the class.

1. Make sure you update your Profile with:
  - Your Name
  - A recognizable profile picture
  - An e-mail address

2. Add your github username to your system configuration (replacing "YOUR GITHUB USERNAME"):


    $ echo "export GITHUB_USERNAME='YOUR GITHUB USERNAME'" >> ~/.bash_profile
        )],
        verify: -> { assert(github_username != "YOUR GITHUB USERNAME" && !github_username.to_s.empty?, "This github username is unexpected ('#{github_username}').", "") }
      },

      global_gitignore: {
        header: "Register a global gitignore file",
        installation_steps: [
          %q(
1. Backup your existing global_gitignore (if it exists).  You can ignore a "No such file or directory" error:

    $ mv ~/.gitignore_global ~/.gitignore_global.bak

2. Download the provided global gitignore file to your home dir:

    $ curl -sSL https://raw.githubusercontent.com/ga-dc/installfest/master/support/gitignore_global -o ~/.gitignore_global

3. Configure git to use this global gitignore file:

    $ git config --global core.excludesfile ~/.gitignore_global
          )
        ],
        verify: -> {
          assert_file = assert_match(/\.DS\_Store/, 'cat ~/.gitignore_global | grep "DS_Store"')
          assert_config = assert_match(/Users\/.*\/.gitignore_global/, 'git config --global --list | grep core.excludesfile')

          assert_file.merge(assert_config)
        }
      },

      homebrew: {
        header: "Homebrew (OSX's Package Manager)",
        installation_steps: [
          %q(
1. Download and install Homebrew:

    $ ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

2. Ensure you have the latest version of everything

    $ brew update && brew upgrade

3. ensure apps installed via Homebrew will be found via your Path.

    $ echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.bash_profile
          ),
        ],
        verify: -> { assert_match(/is ready to brew/, 'brew doctor') },
        ykiwi: %q(
- The output of `$ which brew` is `/usr/local/bin/brew`.
- The output of `$ brew doctor` is `ready to brew`
        )
      },

      postgres: {
        header: 'PostgreSQL (A Database)',
        installation_steps: [
          %q(
1. Download Postgres.app from www.postgresapp.com
2. Move the Postgres.app to your 'Applications' folder.
3. Open the Postgres.app (using "right-click + open" for this non-Mac App store app)
  -  Look for the elephant in the the menu bar.
4. Configure bash to enable opening Postgres from the command line (via psql):

    $ echo 'export PATH=$PATH:/Applications/Postgres.app/Contents/Versions/9.4/bin' >> ~/.bash_profile
          )
        ],
        verify: -> { assert_version_is_sufficient('9.5.0', 'psql --version | cut -f3 -d " "')}
      },

      ruby: {
        installation_steps: [
          %q(
1. Update rvm

    $ rvm get master

2. Install ruby

    $ rvm install 2.2.3

3. Configure your default version of ruby

    $ rvm use 2.2.3 --default
          )
        ],
        verify: -> { assert_match(/^ruby 2.2.3p173/, 'ruby --version') },
        ykiwi: %q(
* The output of `$ ruby --version` **starts** with `ruby 2.2.3p173`.
        )
      },

      ruby_bundler: {
        header: "Ruby Gem (Bundler)",
        installation_steps: [
          %q(
1. Update to the latest version of Bundler, a Ruby Gem

    $ gem install bundler -v 1.11.2 && gem cleanup bundler
          )
        ],
        verify: -> { assert_version_is_sufficient('1.11.0', 'gem list bundler | head -n1  | cut -f2 -d " " | sed "s/[()]//g"') }
      },

      ruby_gems: {
        header: "Ruby Gems",
        installation_steps: [
          %q(
1. Update to the latest version of Ruby Gems

    $ gem update --system
          )
        ],
        verify: -> { assert_version_is_sufficient('2.5.2', 'gem -v') }
      },

      rvm: {
        header: 'RVM (Ruby Version Manager)',
        installation_steps: [
          %q(
1. First, check to see if you have `rbenv` installed already, since this conflicts with `rvm`.  If the output of the following command is anything *other than* blank, get an instructor to help you uninstall.

    $ which rbenv


2. Otherwise, go ahead and install RVM (yes, there is a leading slash):

    $ \curl -sSL https://get.rvm.io | bash


3. Reload this shell, to initialize rvm.

    $ exec bash -l
)
        ],
        # TODO: https://rvm.io/rvm/install suggests using
        #   the output of `$ type rvm | head 1` is `rvm is a function`.
        # However, this command didn't get this result within this script.
        verify: -> { assert_match(%r{.rvm/bin/rvm$}, 'which rvm') },
        ykiwi: %q[The output of `$ type rvm | head -n 1` is "rvm is a function" (as recommended in https://rvm.io/rvm/install)]
      },

      slack: {
        installation_steps: [
          %q(
1. Install the free "Slack" app from the App Store
          )
        ],
        verify: -> { assert_match(/Contents/, 'ls /Applications/slack.app') }
      },

      sublime: {
        installation_steps: [
          'FIX ME'
        ],
        verify: -> { assert_match(/Sublime Text 2 Build/, 'subl --version') }
      },

      uninstall_non_brew_node: {
        header: "Uninstall node (if not installed via 'brew')",
        # steps from : https://gist.github.com/TonyMtz/d75101d9bdf764c890ef
        installation_steps: [
          %q(
If you installed node without using 'brew install node', follow these instructions to uninstall that version.

1. First, uninstall the files listed in nodejs' Bill of Materials (bom):

    $ lsbom -f -l -s -pf /var/db/receipts/org.nodejs.node.pkg.bom | while read f; do  sudo rm /usr/local/${f}; done
    $ sudo rm -rf /usr/local/lib/node /usr/local/lib/node_modules /var/db/receipts/org.nodejs.*


2. Go to /usr/local/lib and delete any node and node_modules

    $ cd /usr/local/lib
    $ sudo rm -rf node*


3. Go to /usr/local/include and delete any node and node_modules directory

    $ cd /usr/local/include
    $ sudo rm -rf node*

4. Go to /usr/local/bin and delete any node executable

    $ cd /usr/local/bin
    $ sudo rm -rf /usr/local/bin/npm
    $ ls -las

5. Remove man docs

    $ sudo rm -rf /usr/local/share/man/man1/node.1

6. Remove debugging info

    $ sudo rm -rf /usr/local/lib/dtrace/node.d

8. Remove from Home dir

    $ sudo rm -rf ~/.npm

9. Check your Home directory for any "local" or "lib" or "include" folders, and delete any "node" or "node_modules" from there
10. Finally, ensure you have permissions to "/usr/local/"

    $ sudo chown -R `whoami`:staff /usr/local
          )
        ],
        verify: -> { assert_match(/No such file/, 'ls /var/db/receipts/org.nodejs*') }
      },

      xcode_cli_tools: {
        header: 'XCode CLI tools',
        installation_steps: [
          %q(
1. Install the XCode CLI tools

    $ xcode-select --install
          )
        ],
        verify: -> { assert_version_is_sufficient('2343', 'xcode-select --version | head -n1 | cut -f3 -d " " | sed "s/[.]//g"' ) }
      }
    }
  end

  def github_username
    ENV["GITHUB_USERNAME"]
  end

  def instruction_file
    File.expand_path('installfest.md')
  end

  def instruction_file_url
    'https://github.com/ga-students/wdi_dc5/blob/master/installfest.md'
  end

  def known_packages
    packages.keys
  end

  # Opens local instruction file, falls back to url at github
  def open_instructions
    generate_instruction_file instruction_file
    open instruction_file
  end

  def request_github_username
    notify("\nEnter your github username and press enter")
    $stdin.gets.strip
  end

  def persist_github_username(github_username)
    unless system("echo 'export GITHUB_USERNAME=#{github_username}' >> ~/.bash_profile")
      fail "Unable to set the environment variable (GITHUB_USERNAME)"
    end
  end

  def skip_header?
    !!ENV['SKIP_HEADER'].to_s.match(/t|true/i) # t, T, true, True, etc
  end

  def start
    unless skip_header?
      system "clear"
      notify start_header
      notify "\nPress enter when you are ready to continue."
      $stdin.gets
    end
    # notify "## Starting installation..."
    configured_packages.each do |package_name|
      package = packages[package_name]
      # header defaults to package_name
      package = {header: package_name}.merge(package)
      system "clear"
      until result = verify_package(package_name, package)
        notify colorize(%Q(#{'-' * 25}
IT'S YOUR TURN! Either you haven't installed this application yet, or it needs some tweaking.

Just follow the steps below!

If issues persist, raise your hand and an instructor will assist you.), :green)
        show_instructions_for(package)
        notify "\nPress <enter> when you have completed the above steps."
        response = $stdin.gets.strip

        # We need to reload the bash config and restart installfest.
        # `exec` (ruby) and `exec` (bash) did the trick
        notify "One package, of many, is installed. \nReloading bash (for latest config) and restarting installfest to continue..."
        exec "exec bash -l -c 'rake installfest:start SKIP_HEADER=true'"
      end
    end
    system "clear"
    notify "\n## Everything is installed.  Running one final check..."
    Rake::Task["installfest:doctor"].execute
    notify start_footer
  end

  def verify_package(package, package_info)
    # TODO: this is asking for an object
    notify "Verifying #{package}...", :start
    verification = package_info.fetch(:verify)
    result = verification.call
    notify result.message, result.status ? :success : :failure
    return result.status
  end
private

  def color_codes
    { red: 31,
      green: 32,
      yellow: 33,
      blue: 34,
      magenta: 35,
      cyan: 36,
      grey: 37
    }
  end

  def colorize(text, color)
    color_code = color_codes.fetch(color)
    "\e[#{color_code}m#{text}\e[0m"
  end

  def generate_instruction_file(file_name_including_path)
    File.open(file_name_including_path, 'w') do |file|
      file.write instructions
    end
  end

  def instruction_footer
    %q(
## Let's verify that everything was installed... programmatically.

    $ rake installfest:doctor

)
  end

  def instruction_header
    %q(
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
    )
  end

  def notify(message, level = :info)
    return if ENV['VERBOSE'] == 'false'

    case level
    when :skip
      puts colorize(message, :blue)
    when :start
      print message
    when :success
      puts colorize(message, :green)
    when :failure, :error
      $stderr.puts message
    else
      puts message
    end
  end

  def open(file)
    puts "Opening '#{file}'"
    `open "#{file}"`
  end

  def instructions_for(package)
    steps = package.fetch(:installation_steps)
    header = package.fetch(:header)
    instructions = ""
    instructions += "\n## #{header}"

    steps.each do |step|
      instructions += "\n"
      instructions += step
    end
    you_know_it_worked_if = package[:ykiwi]
    if you_know_it_worked_if
      instructions += "\n\n### You know it worked if...\n"
      instructions += "\n" + you_know_it_worked_if
    end
    return instructions
  end

  def show_instructions_for(package)
    notify instructions_for(package)
  end


  def start_footer
    %Q(
## #{colorize("Congratulations", :green)}!  You are good to go.

  Inform your instructors.
    )
  end

  def start_header
    %Q(#{colorize("-- Welcome to Installfest!", :green)}

#{colorize("-- Getting started...", :green)}

If you haven't done so already, open up a #{colorize("second Terminal window", :magenta)} so you can begin entering commands. (Press Command + N).

There's going to be a lot of text, so make this window and that window as tall as you can to accommodate it.

#{colorize("-- How this works", :green)}

This script will check to see whether certain applications have been installed on your computer. If they haven't, or if they still need tweaking, the script will stop and prompt you with a series of commands to enter. Write them in the OTHER Terminal window.

Depending on how much programming you've done before, you may have already completed some of these steps. So, for example, if Step 1 is to "Download Atom" and you've already downloaded it, go ahead to Step 2.

Please ignore any light-grey text like this: #{colorize("It just displays additional info about what's going on under-the-hood. If you have recurring problems the instructors may look at it.", :grey)}
)
  end

end

###########################
# The Rake Tasks
require 'rake'

namespace :installfest do
  installfest = Installfest.new
  desc 'Verifies required items are installed correctly'
  task :doctor do
    installfest.doctor
  end

  desc 'Generates a default config file.'
  task :generate_config_file do
    installfest.generate_config
  end

  desc 'Displays installation instructions.'
  task :instructions do
    installfest.display_instructions
  end

  desc "List known packages"
  task :known do
    puts installfest.known_packages
  end

  desc 'Opens instruction file (attempts local file, falls back to url)'
  task :open do
    installfest.open_instructions
  end

  desc 'Starts the installation process, listing out manual steps, then verifying the steps programmatically (when possible).'
  task :start do
    installfest.start
  end
end

################################
# The Tests
# Only run tests if this file is loaded directly (not thru rake)
# Usage: $ ruby Rakefile
if $PROGRAM_NAME == __FILE__
  require 'minitest/autorun'

  describe Installfest do
    before do
      ENV['VERBOSE'] = 'false'
      @installfest = Installfest.new
    end

    describe '.assert' do
      it "simply returns true for true boolean_expression" do
        result = @installfest.assert(true, 'test_actual', 'test_expected')
        result.status.must_equal true
      end

      describe 'when boolean_expression is false' do
        it "returns false" do
          result = @installfest.assert(false, 'test_actual', 'test_expected')
          result.status.must_equal false
        end

        it "notifies the user of a failure" do
          ENV["VERBOSE"] = 'true'
          result = nil
          out, err = capture_io do
            result = @installfest.assert(false, 'test_actual', 'test_expected')
          end
          assert_match(/NOT met/i, result.message)
        end

        it "notifies the user, unless ENV['VERBOSE'] == 'false'" do
          ENV["VERBOSE"] = 'false'
          out, err = capture_io do
            @installfest.assert(false, 'test_actual', 'test_expected')
          end
          assert_match('', out)
        end
      end
    end

    describe '.assert_version' do
      [
        ['1', 'echo 2', true],
        ['1', 'echo 10', true],
        ['1.2', 'echo 1.3', true],
        ['1.2', 'echo 1.2', true],
        ['1.2', 'echo 1.2.1', true],
        ['1.2', 'echo 1.10', true],
        ['1.2', 'echo 1.1', false],
        ['1.2', 'echo 1.1.9', false],
        ['2', 'echo 1', false],
        ['1.10', 'echo 1.2', false]
      ].each do |target_version, current_version, expectation|
        it "uses 'natural' comparison for string versions (#{current_version} is #{expectation ? '' : 'not '}> #{target_version})" do
          result = @installfest.assert_version_is_sufficient(target_version, current_version)
          result.status.must_equal(expectation)
        end
      end
    end

    describe '.packages' do
      it "includes 'atom', when EDITOR is NOT 'subl'" do
        ENV['EDITOR'] = 'vim'
        @installfest.packages.keys.must_include :atom
      end

      it "includes 'sublime', when EDITOR is 'subl'" do
        ENV['EDITOR'] = 'subl'
        @installfest.packages.keys.must_include :sublime
      end
    end
  end

  describe Installfest::CommandResult do
    before do
      @result = Installfest::CommandResult.new(true, "MESSAGE")
    end

    it "responds to #status" do
      @result.status.must_equal(true)
    end
    it "responds to #message" do
      @result.message.must_equal("MESSAGE")
    end

    it "converts status to boolean" do
      Installfest::CommandResult.new(nil, "MESSAGE").status.must_equal(false)
    end

    describe "#merge" do
      before do
        @other_result = Installfest::CommandResult.new(false, "OTHER MESSAGE")
      end

      it "'ands' the statuses" do
        @result.merge(@other_result).status.must_equal false
      end

      it "combines failure messages" do
        @result.merge(@other_result).message.must_equal "OTHER MESSAGE"
      end
    end
  end

end # $PROGRAM_FILE == FILE
