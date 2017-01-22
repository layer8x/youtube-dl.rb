source 'https://rubygems.org'

# Specify your gem's dependencies in youtube-dl.rb.gemspec
gemspec

group :test do
  gem 'activesupport', '< 5.0' unless RUBY_VERSION >= '2.2.2'
  gem "simplecov"
  gem "codeclimate-test-reporter", "~> 1.0.0"
end

group :extras do
  gem 'pry'
  gem 'pry-byebug'
  gem 'm'
end
