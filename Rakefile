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

  desc 'Auto update binaries and increment version number'
  task :update => :latest do
    File.open('./lib/youtube-dl/version.rb', 'r+') do |f|
      version_file = f.read
      f.rewind
      f.write version_file.gsub(/\d{4}\.\d+\.\d+\.?\d+?/, `./vendor/bin/youtube-dl --version`.strip)
    end
    abort unless system("git commit -a -m 'Updated binaries to #{`./vendor/bin/youtube-dl --version`.strip}'")
  end
end
