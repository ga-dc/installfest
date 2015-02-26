# require 'pry'

# Supporting Libraries
class InstallFest
  def assert_version_is_sufficient(target_version, current_version)
    if current_version.respond_to? :call
      current_version = current_version.call
    end
    notify "Ensuring #{current_version} >= #{target_version}..."
    Gem::Version.new(current_version) >= Gem::Version.new(target_version)
  end

  # checks for valid installation
  def doctor
    packages.each do |package, package_info|
      notify "Verifying #{package}..."
      verification = package_info[:verify]
      verification.call
    end
  end

  def packages
    {
      atom: { verify: ->{ assert_version_is_sufficient('0.177.0', ->{`atom --version`}) }}
    }
  end

  def instruction_file
    File.expand_path('installfest.md')
  end

  def list
    open instruction_file
  end

private

  def notify(message)
    puts message if ENV['VERBOSE'] == 'true'
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
  desc "Verifies InstallFest"
  task :doctor do
    installfest.doctor
  end

  desc "List instructions"
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

      it "supports retrieving a version from a Proc" do
        @installfest.assert_version_is_sufficient('1.1', ->{'1.2'}).must_equal(true)
        @installfest.assert_version_is_sufficient('2', ->{'1'}).must_equal(false)
      end
    end
  end

end # $PROGRAM_FILE == FILE
