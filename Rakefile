require 'bundler/gem_tasks'
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.pattern = 'test/**/*_test.rb'
end

task default: [:test]

namespace :binaries do
  def get_binaries(version)
    puts 'Updating python script'
    system("wget -O ./vendor/bin/youtube-dl https://yt-dl.org/downloads/#{version}/youtube-dl")
    puts 'Updating Windows EXE'
    system("wget -O ./vendor/bin/youtube-dl.exe https://yt-dl.org/downloads/#{version}/youtube-dl.exe")
  end

  desc 'Get latest binaries'
  task :latest do
    get_binaries('latest')
  end

  desc 'Get binaries for specific version (run with `rake binaries:version[2015.07.07]`)'
  task :version, [:ver] do |_t, a|
    get_binaries(a[:ver])
  end

  desc 'Update the version in version.rb to the vendor youtube-dl version'
  task :update_gem_version do
    # Hack to get the version template from DATA
    _, data = File.read(__FILE__).split(/^__END__$/, 2)

    version = `./vendor/bin/youtube-dl --version`.strip
    version_filename = './lib/youtube-dl/version.rb'

    # Compliled template file
    version_file = ERB.new(data).result(binding)

    # Syntax Check. Throws a SyntaxError if it doesn't work.
    RubyVM::InstructionSequence.compile(version_file)

    File.open(version_filename, 'w') do |f|
      f.write(version_file)
    end

    # Checks new version string to make sure it's not malformed
    load version_filename
    Gem::Version.new(YoutubeDL::VERSION)

    abort unless system("git commit -a -m 'Updated binaries to #{version}'")

    puts "\e[92mSuccessfully updated binaries to version #{version}\e[0m"
  end

  desc 'Auto update binaries and increment version number'
  task :update => [:latest, :update_gem_version]
end

__END__
# Version file
# If you are updating this code, make sure you are updating
# lib/youtube-dl/version.rb as well as the Rakefile.

module YoutubeDL
  # Semantic Version as well as the bundled binary version.
  # "(major).(minor).(teeny).(pre-release).(binary-version)"
  VERSION = '0.3.1.<%= version %>'.freeze
end
