# Architecture:
# All required functionality is in this single Rakefile;
#   the rake tasks, the supporting library code, and the tests.
# This is by design; to make it easier to install and use, at the expense of readability.

# Important methods
# Installfest#my_packages lists all packages of interest to you.
# Installfest#packages lists all known packages, with suppporting info.
# Installfest#assert_* are the various assertion methods.

require 'yaml'

########################
# Supporting Libraries
class Installfest
  # TODO: extract Package
  def assert(boolean_expression, failure_message_for_actual, failure_message_for_expected)
    if boolean_expression
      return OpenStruct.new( status: true, message: 'met' )
    else
      message = colorize("FAIL", :red)
      message += "\n  #{failure_message_for_actual}"
      message += "\n  #{failure_message_for_expected}."
      return OpenStruct.new( status: false, message: message )
    end
  end

  def assert_equals(expected, shell_command)
    begin
      actual = `#{shell_command}`.chomp
      assert (actual == expected),
             "Expected this: '#{actual}' (via `#{shell_command}`)",
             "To equal this: '#{expected}'"
    rescue Errno::ENOENT => err # command not found, no such file/dir
     assert false, err, ''
    end
  end

  def assert_match(match_pattern, shell_command)
    begin
      value = `#{shell_command}`.chomp
      assert (value =~ match_pattern),
             "Expected this: '#{value}' (via `#{shell_command}`)",
             "To match this: #{match_pattern.inspect}"
    rescue Errno::ENOENT => err # command not found, no such file/dir
      assert false, err, ''
    end
  end

  def assert_version_is_sufficient(target_version, shell_command)
    begin
      current_version = `#{shell_command}`.chomp
      result = (Gem::Version.new(current_version) >= Gem::Version.new(target_version))
      assert result,
           "Expected this version: v#{current_version} (via `#{shell_command}`)",
           "To match this version: v#{target_version}"
    rescue Errno::ENOENT => err # command not found, no such file/dir
      assert false, err, ''
    end
  end

  def check_gh_username
    if @github_username.empty?
      puts "Type your Github username and press enter"
      @github_username = $stdin.gets.chomp.downcase
    end
    cmd = "curl http://auth.wdidc.org/is_created.php?username=#{@github_username} --silent"
    return cmd
  end

  def config_file
    'installfest.yml'
  end

  def configured_packages
    if File.exist?(config_file)
      YAML.load_file(config_file)
    end
  end

  def default_packages
    [editor, :homebrew, :rvm, :ruby, :git, :git_configuration]
  end

  def display_instructions
    puts instructions
  end

  # checks for valid installation
  def doctor
    my_packages.each do |package_name|
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
    my_packages.each do |package_name|
      package = packages.fetch(package_name)
      package = {header: package_name}.merge(package)
      instructions += instructions_for(package)
    end
    instructions += "\n"
    instructions += instruction_footer

    instructions
  end

  def generate_config
    File.open(config_file, 'w') {|f| f.write default_packages.to_yaml }
  end

  # list of packages to check
  def my_packages
    configured_packages || default_packages
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
- If you don't have a github username, go to Github.com and create an account. Make sure you add:
  - A profile picture
  - An e-mail address
- Go to http://auth.wdidc.org/ and follow the instructions
        )],
        verify: -> { assert_match(/PASS/, check_gh_username) }
      },

      atom: {
        header: '"Atom" Text Editor',
        installation_steps: [
          %q(
1. Download atom [from their website](https://atom.io) and install.
2. Run "atom" and select "Atom | Install Shell Commands".
3. Then configure your terminal to use 'atom'.

    $ echo "EDITOR=atom" >> ~/.bash_profile
)
        ],
        verify: -> { assert_version_is_sufficient('0.177.0', 'atom --version') }
      },

      git: {
        installation_steps: [
          '    $ brew install git'
        ],
        verify: lambda do
          assert_version_is_sufficient(
            '2.3.0',
            'git --version | head -n1 | cut -f3 -d " "'
          ) # non-abbreviated flag names are not available in BSD
        end,
        ykiwi: "The output of `git --version` is greater than or equal to 2.0
"
      },

      git_configuration: {
        header: 'Configure Git',
        installation_steps: [
          %q(
### Personalize git
    $ git config --global user.name  "YOUR NAME"'
    $ git config --global user.email "YOUR@EMAIL.COM"'
          ),
          %q(
### You can copy & paste all of these commands at once:
    git config --global color.ui always
    git config --global color.branch.current   "green reverse"
    git config --global color.branch.local     green
    git config --global color.branch.remote    yellow
    git config --global color.status.added     green
    git config --global color.status.changed   yellow
    git config --global color.status.untracked red
),
          %q(
### Tell git what editor to use for commits

    $ git config --global core.editor "atom --wait"

OR (for sublime)

    $ git config --global core.editor "subl --wait --new-window"
),
        ],
        verify: -> { assert_equals('core.editor=atom --wait', 'git config --list | grep core.editor')}
      },

      github: {
        header: %q(Github (The Social Network of Code)),
        installation_steps: [
          %q(
- Go to Github.com and create an account. Make sure you add:
  - A profile picture
  - An e-mail address
        )],
        verify: -> { notify("Enter your github username and press enter"); @github_username = $stdin.gets.strip; assert(!@github_username.empty?, "Follow the instructions below.", '') }
      },

      homebrew: {
        header: %q(Homebrew (OSX's Package Manager)),
        installation_steps: [
          %q(    $ ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"),
          %q(    $ brew update && brew upgrade),
          %q(    $ echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.bash_profile)
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
- Go to www.postgresapp.com
- Click 'Download'
- Move the Postgres.app to your 'Applications' folder.
- Double-click on Postgres.app
- Enable opening Postgres from the command line (via psql):
    $ echo 'export PATH=$PATH:/Applications/Postgres.app/Contents/Versions/9.4/bin' >> ~/.bash_profile
          )
        ],
        verify: -> { assert_version_is_sufficient('9.4.0', 'psql --version | cut -f3 -d " "')}
      },

      rvm: {
        header: 'RVM (Ruby Version Manager)',
        installation_steps: [
          %q(
First, check to see if you have `rbenv` installed already, since this conflicts with `rvm`:

    $ which rbenv

If the output is anything other than blank, get an instructor to help you uninstall.
),
          %q(
Otherwise, go ahead and install RVM:

    $ \curl -sSL https://get.rvm.io | bash -s stable --auto-dotfiles
)
        ],
        # TODO: https://rvm.io/rvm/install suggests using
        #   the output of `$ type rvm | head 1` is `rvm is a function`.
        # However, this command didn't get this result within this script.
        verify: -> { assert_match(%r{.rvm/bin/rvm$}, 'which rvm') },
        ykiwi: %q(The output of `$ type rvm | head -n 1` is `rvm is a function`.  # as recommended in https://rvm.io/rvm/install)
      },

      ruby: {
        installation_steps: [
          %q(
    $ rvm get stable
    $ rvm install 2.2.1
    $ rvm use 2.2.1 --default

)
        ],
        verify: -> { assert_match(/^ruby 2.2.1p85/, 'ruby --version') },
        ykiwi: %q(
* The output of `$ ruby --version` **starts** with `ruby 2.2.1p85`.
        )
      },

      slack: {
        installation_steps: [
          %q(
- Open "App Store"
- Install "Slack"
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

      xcode_cli_tools: {
        header: 'XCode CLI tools',
        installation_steps: [
          %q(    $ xcode-select --install)
        ],
        verify: -> { assert_version_is_sufficient('2339', 'xcode-select --version | head -n1 | cut -f3 -d " " | sed "s/[.]//g"' ) }

      }
    }
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

  def start
    system "clear"
    notify start_header
    notify "\nPress enter when you are ready to continue."
    $stdin.gets
    # notify "## Starting installation..."
    my_packages.each do |package_name|
      package = packages[package_name]
      # header defaults to package_name
      package = {header: package_name}.merge(package)
      system "clear"
      until result = verify_package(package_name, package)
        notify "\n#{'-' * 25}\nWARNING: This package is NOT installed correctly.  Follow the instructions below.  \nIf issues persist, raise your hand and someone will assist you."
        show_instructions_for(package)
        notify "\nPress <enter> when you have completed the above steps."
        response = $stdin.gets.strip
        system "clear"
        notify "Restart installfest via: \n    rake installfest:start"
        system "exec bash -l"
      end
    end
#    system "clear"
#    notify "\n## Everything is installed.  Running one final check..."
#    Rake::Task["installfest:doctor"].execute
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
      cyan: 36
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

## Sign Up for GitHub

Complete the "sign up" steps at www.GitHub.com

Write your github username on the whiteboard.
)
  end

  def instruction_header
    %q(
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
      instructions += "\n\n### You know it worked if..."
      instructions += "\n" + you_know_it_worked_if
    end
    return instructions
  end

  def show_instructions_for(package)
    notify instructions_for(package)
  end


  def start_footer
    %q(
## Congratulations!  You are good to go.

  Inform your instructors.
    )
  end

  def start_header
    %q(
# Welcome to Installfest!

## Before you start...

Today, you will be installing the basic software you need for the class.

If you have ANY questions, raise your hand for assistance.

Each package will list the installation steps.
You will be entering these into another Terminal window.
If you don't have that open, do so now.

Read through every instruction carefully and follow them to the letter.

You will be restarting the process after each package is installed.

You should be able to copy and paste the lines into Terminal.
With these exceptions:
- If you see all capitals (like "YOUR NAME"), replace with your appropriate information.
- The commands below all start with a dollar sign (`$`),
but **you should not actually write the `$`.**
The dollar sign is a standard convention to indicate a bash (terminal) command.
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
        @installfest.assert(true, 'test_actual', 'test_expected').must_equal true
      end

      describe 'when boolean_expression is false' do
        it "returns false" do
          @installfest.assert(false, 'test_actual', 'test_expected').must_equal false
        end

        it "notifies the user of a failure" do
          ENV["VERBOSE"] = 'true'
          out, err = capture_io do
            @installfest.assert(false, 'test_actual', 'test_expected')
          end
          assert_match(/FAIL/i, err)
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
        ['1.2', 'echo 1.2.1', true],
        ['1.2', 'echo 1.10', true],
        ['2', 'echo 1', false],
        ['1.10', 'echo 1.2', false]
      ].each do |target_version, current_version, expectation|
        it "uses 'natural' comparison for string versions (#{current_version} is #{expectation ? '' : 'not '}> #{target_version})" do
          @installfest.assert_version_is_sufficient(target_version, current_version).must_equal(expectation)
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

end # $PROGRAM_FILE == FILE
