# require 'pry'

# Supporting Libraries
class InstallFest
  # TODO: replace with minitest assertions?
  def assert_equals(actual, expected)
    actual.chomp!
    result = (actual == expected)
    unless result
      notify " FAIL. \n  Expected: '#{actual}'\n  To equal: '#{expected}'.", :expectation
    end
    return result
  end

  def assert_match(value, match_pattern)
    value.chomp!
    result = (value =~ match_pattern)
    unless result
      notify "FAIL.\n  Expected: '#{value}'\n  To match: #{match_pattern}.", :expectation
    end
    return result
  end

  def assert_version_is_sufficient(target_version, current_version)
    current_version.chomp!
    result = (Gem::Version.new(current_version) >= Gem::Version.new(target_version))
    unless result
      notify "FAIL. \n  Expected version: '#{target_version}',\n  Found version:    '#{current_version}'.", :expectation
    end
    return result
  end

  # checks for valid installation
  def doctor
    packages.each do |package, package_info|
      notify "Verifying #{package}...", :start
      verification = package_info[:verify]

      if verification.call
        notify ' met.', :success
      # else
      #   notify 'FAIL. ', :failure
      end
    end
  end

  # the list of packages
  # this is what you will edit as new packages are added/removed
  def packages
    {
      atom: { verify: ->{ assert_version_is_sufficient('0.177.0', `atom --version`) }},
      homebrew: { verify: ->{ assert_match(`brew doctor`, /is ready to brew/)}},
      rvm: { verify: ->{ assert_match(`which rvm`, /.rvm\/bin\/rvm$/) }},
      ruby: { verify: ->{ assert_match( `ruby --version`, /^ruby 2.2.0p0/) }},
      git: { verify: ->{ assert_version_is_sufficient('2.3.0', `git --version | head -n1 | cut --fields=3 --delimiter=' '`)}},
      configure_git: { verify: ->{ assert_equals(`git config --list | grep core.editor`, 'core.editor=atom --wait' )}}
    }
  end

  def instruction_file
    File.expand_path('installfest.md')
  end

  def list
    open instruction_file
  end

private

  def notify(message, level = :info)
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

# The Rake Tasks
require 'rake'

namespace :installfest do
  installfest = InstallFest.new
  desc 'Verifies InstallFest'
  task :doctor do
    installfest.doctor
  end

  desc 'List instructions'
  task :list do
    installfest.list
  end
end

# The Tests
# Only run tests if this file is loaded directly (not thru rake)
if $PROGRAM_NAME == __FILE__
  require 'minitest/autorun'

  describe InstallFest do
    describe '.assert_version' do
      before do
        @installfest = InstallFest.new
      end

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

      it 'supports retrieving a version from a Proc' do
        @installfest.assert_version_is_sufficient('1.1', ->{'1.2'}).must_equal(true)
        @installfest.assert_version_is_sufficient('2', ->{'1'}).must_equal(false)
      end
    end
  end

end # $PROGRAM_FILE == FILE
