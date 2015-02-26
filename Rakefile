class InstallFest
  def assert_version_is_sufficient(target_version, current_version)
    notify "Ensuring #{current_version} >= #{target_version}..."
    Gem::Version.new(current_version) >= Gem::Version.new(target_version)
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

namespace :installfest do
  installfest = InstallFest.new
  desc "List instructions"
  task :list do
    installfest.list
  end
end

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
    end
  end

end # $PROGRAM_FILE == FILE
