require "bundler/gem_tasks"
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.pattern = "test/**/*_test.rb"
end

task :default => [:test]

desc "Update YoutubeDL binaries"
task :update_binaries do
  puts "Updating python script"
  system('wget -O ./vendor/bin/youtube-dl https://yt-dl.org/latest/youtube-dl')
  puts "Updating Windows EXE"
  system('wget -O ./vendor/bin/youtube-dl.exe https://yt-dl.org/latest/youtube-dl.exe')
end
