# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'youtube-dl/version'

Gem::Specification.new do |spec|
  spec.name          = 'youtube-dl.rb'
  spec.version       = YoutubeDL::VERSION
  spec.authors       = %w(sapslaj xNightMare)
  spec.email         = ['saps.laj@gmail.com']
  spec.summary       = 'youtube-dl wrapper for Ruby'
  spec.description   = 'in the spirit of pygments.rb and MiniMagick, youtube-dl.rb is a command line wrapper for the python script youtube-dl'
  spec.homepage      = 'https://github.com/layer8x/youtube-dl.rb'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  #spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'terrapin', '>=0.6.0'

  spec.add_development_dependency 'bundler', '>= 1.6'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'minitest', '~> 5.8.1'
  spec.add_development_dependency 'purdytest'
  spec.add_development_dependency 'codeclimate-test-reporter'
end
