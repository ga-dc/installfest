# Architecture:
# All required functionality is in this single Rakefile;
#   the rake tasks, the supporting library code, and the tests.
# This is by design; to make it easier to install and use, at the expense of readability.

# Important methods
# InstallFest#my_packages lists all packages of interest to you.
# InstallFest#packages lists all known packages, with suppporting info.
# InstallFest#assert_* are the various assertion methods.

begin
  # pry is used during debugging,
  #  but will not be available on students machines during installfest
  # The Gemfile will not be available either.
  # We were commenting/uncommenting this line, but a "safe" require
  #  seems more reasonable (and less error prone).
  #  Translated: I forgot and committed "require 'pry'" and this caused problems. :)
  require 'pry'
rescue LoadError => err
  abort 'Please install the "pry" gem via `$ gem install pry`. We depend on it.'
end

require 'yaml'

########################
# Supporting Libraries
class InstallFest
  def assert(boolean_expression, failure_message_for_actual, failure_message_for_expected, message_type = :expectation)
    unless boolean_expression
      message = colorize("FAIL", :red)
      message += "\n  #{failure_message_for_actual}"
      message += "\n  #{failure_message_for_expected}."
      notify message, :failure
    end
    return boolean_expression
  end

  def assert_equals(expected, shell_command)
    actual = `#{shell_command}`.chomp
    assert (actual == expected),
           "Expected: '#{actual}' (via `#{shell_command}`)",
           "To equal: '#{expected}'"
  end

  def assert_match(match_pattern, shell_command)
    value = `#{shell_command}`.chomp
    assert (value =~ match_pattern),
           "Expected: '#{value}' (via `#{shell_command}`)",
           "To match: #{match_pattern}"
  end

  def assert_version_is_sufficient(target_version, shell_command)
    current_version = `#{shell_command}`.chomp
    result = (Gem::Version.new(current_version) >= Gem::Version.new(target_version))
    assert result,
           "Required version: v#{current_version} (via `#{shell_command}`)",
           "To match version: v#{target_version}"
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
      steps = package.fetch(:installation_steps)
      header = package[:header] || package_name.capitalize
      instructions += "\n## " + header.to_s

      steps.each do |step|
        instructions += "\n"
        instructions += step
      end
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
  def packages
    {
      atom: {
        header: '"Atom" Text Editor',
        installation_steps: [
          %q(
1. Download atom [from their website](https://atom.io) and install.
2. Then configure your terminal to use 'atom'.

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
        end
      },
      git_configuration: {
        header: 'Configure Git',
        installation_steps: [
          %q(
    $ git config --global user.name  "YOUR NAME"
    $ git config --global user.email "YOUR@EMAIL.COM"
    $ git config --global color.ui always
    $ git config --global color.branch.current   "green reverse"
    $ git config --global color.branch.local     green
    $ git config --global color.branch.remote    yellow
    $ git config --global color.status.added     green
    $ git config --global color.status.changed   yellow
    $ git config --global color.status.untracked red
),
          %q(
## Tell git what editor to use for commits

    $ git config --global core.editor "atom --wait"

OR (for sublime)

    $ git config --global core.editor "subl --wait --new-window"
),
        ],
        verify: -> { assert_equals('core.editor=atom --wait', 'git config --list | grep core.editor')}
      },
      homebrew: {
        header: %q(Homebrew (OSX's Package Manager)),
        installation_steps: [
          %q(    $ ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"),
          %q(    $ brew update && brew upgrade),
          %q(    $ echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.bash_profile')
        ],
        verify: -> { assert_match(/is ready to brew/, 'brew doctor') }
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

Then **close and reopen** the Terminal.
)
        ],
        # TODO: https://rvm.io/rvm/install suggests using
        #   the output of `$ type rvm | head 1` is `rvm is a function`.
        # However, this command didn't get this result within this script.
        verify: -> { assert_match(%r{.rvm/bin/rvm$}, 'which rvm') }
      },
      ruby: {
        installation_steps: [
          %q(
    $ source ~/.rvm/scripts/rvm
    $ rvm install 2.2.0

Then, **close and reopen the terminal** to ensure the terminal is using these changes.
)
        ],
        verify: -> { assert_match(/^ruby 2.2.0p0/, 'ruby --version') }
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
        verify: -> { notify 'SKIP: We can not verify programatically.', :skip }

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

  def verify_package(package, package_info)
    # TODO: this is asking for an object
    notify "Verifying #{package}...", :start
    verification = package_info.fetch(:verify)

    if verification.call
      notify ' met.', :success
    else
      # Failures are recorded within assertions
      # TODO: move back to here (assertions return more?)
    end
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

Run the following commands, sequentially, to download the `Rakefile` and run the appropriate `rake` command.:

    $ brew install curl
    $ curl --location http://git.io/x6jq > Rakefile
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

Below are a bunch of commands to enter into Terminal, which is a way of interacting with your computer that doesn't use the fancy desktop interface you're used to.

You should be able to copy and paste the lines into Terminal -- except for a few that have obvious prompts in them, like "YOUR NAME", which you should replace accordingly.

The lines below all start with `$`, but **you shouldn't actually write the `$`.** Its purpose is just to make the starts of lines easy to see in these instructions.

##Terminal

Open Applications > Utilities > Terminal
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
end

###########################
# The Rake Tasks
require 'rake'

namespace :installfest do
  installfest = InstallFest.new
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
end

################################
# The Tests
# Only run tests if this file is loaded directly (not thru rake)
# Usage: $ ruby Rakefile
if $PROGRAM_NAME == __FILE__
  require 'minitest/autorun'

  describe InstallFest do
    before do
      ENV['VERBOSE'] = 'false'
      @installfest = InstallFest.new
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
