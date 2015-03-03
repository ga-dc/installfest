# require 'pry'

# Architecture:
# All required functionality is in this single Rakefile;
#   the rake tasks, the supporting library code, and the tests.
# This is by design; to make it easier to install and use, at the expense of readability.

# The functionality mainly takes place in InstallFest.packages and the assert* methods.  The rest is support for these.

########################
# Supporting Libraries
class InstallFest
  def assert(boolean_expression, failure_message_for_actual, failure_message_for_expected, message_type = :expectation)
    unless boolean_expression
      message = "FAIL.\n  #{failure_message_for_actual}\n  #{failure_message_for_expected}."
      notify message, message_type
    end
    return boolean_expression
  end

  def assert_equals(expected, actual)
    actual.chomp!
    assert (actual == expected),
           "Expected: '#{actual}'",
           "To equal: '#{expected}'"
  end

  def assert_match(match_pattern, value)
    value.chomp!
    assert (value =~ match_pattern),
           "Expected: '#{value}'",
           "To match: #{match_pattern}"
  end

  def assert_version_is_sufficient(target_version, current_version)
    current_version.chomp!
    result = (Gem::Version.new(current_version) >= Gem::Version.new(target_version))
    assert result,
           "Expected version: '#{target_version}'",
           "Found version:    '#{current_version}'"
  end

  # checks for valid installation
  def doctor
    packages.each do |package, package_info|
      notify "Verifying #{package}...", :start
      verification = package_info[:verify]

      if verification.call
        notify ' met.', :success
      else
        # Failures are recorded within assertions
        # TODO: move back to here (assertions return more?)
      end
    end
  end

  # the list of packages
  # this is what you will edit as new packages are added/removed
  def packages
    {
      atom: {
        verify: -> { assert_version_is_sufficient('0.177.0', `atom --version`) }
      },
      homebrew: {
        verify: -> { assert_match(/is ready to brew/, `brew doctor`) }
      },
      rvm: {
        verify: -> { assert_match(%r{.rvm/bin/rvm$}, `which rvm`) }
      },
      ruby: {
        verify: -> { assert_match(/^ruby 2.2.0p0/, `ruby --version`) }
      },
      git: {
        verify: lambda do
          assert_version_is_sufficient(
            '2.3.0',
            `git --version | head -n1 | cut -f3 -d ' '`
          ) # non-abbreviated flag names are not available in BSD
        end
      },
      configure_git: {
        verify: -> { assert_equals('core.editor=atom --wait', `git config --list | grep core.editor`)}
      }
    }
  end

  def instruction_file
    File.expand_path('installfest.md')
  end

  def instruction_file_url
    'https://github.com/ga-students/wdi_dc5/blob/master/installfest.md'
  end

  # Opens local instruction file, falls back to url at github
  def open_instructions
    instructions = File.exist?(instruction_file) ? instruction_file : instruction_file_url
    open instructions
  end

private

  def notify(message, level = :info)
    return if ENV['VERBOSE'] == 'false'

    case level
    when :start
      print message
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

        it "notifies the user" do
          ENV["VERBOSE"] = 'true'
          out, err = capture_io do
            @installfest.assert(false, 'test_actual', 'test_expected')
          end
          assert_match(/^FAIL/i, out)
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
        ['1', '2', true],
        ['1', '10', true],
        ['1.2', '1.3', true],
        ['1.2', '1.2.1', true],
        ['1.2', '1.10', true],
        ['2', '1', false],
        ['1.10', '1.2', false]
      ].each do |target_version, current_version, expectation|
        it "uses 'natural' comparison for string versions (#{current_version} is #{expectation ? '' : 'not '}> #{target_version})" do
          @installfest.assert_version_is_sufficient(target_version, current_version).must_equal(expectation)
        end
      end
    end
  end

end # $PROGRAM_FILE == FILE
