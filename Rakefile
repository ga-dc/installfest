class InstallFest
  def instruction_file
    File.expand_path('installfest.md')
  end

  def list
    open instruction_file
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
