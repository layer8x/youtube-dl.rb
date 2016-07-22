# youtube-dl.rb

Ruby wrapper for [youtube-dl](http://rg3.github.io/youtube-dl/).

[![Build Status](https://travis-ci.org/layer8x/youtube-dl.rb.svg?branch=master)](https://travis-ci.org/layer8x/youtube-dl.rb)
[![Code Climate](https://codeclimate.com/github/layer8x/youtube-dl.rb/badges/gpa.svg)](https://codeclimate.com/github/layer8x/youtube-dl.rb)
[![Test Coverage](https://codeclimate.com/github/layer8x/youtube-dl.rb/badges/coverage.svg)](https://codeclimate.com/github/layer8x/youtube-dl.rb/coverage)
[![security](https://hakiri.io/github/layer8x/youtube-dl.rb/master.svg)](https://hakiri.io/github/layer8x/youtube-dl.rb/master)
[![Inline docs](http://inch-ci.org/github/layer8x/youtube-dl.rb.svg?branch=master)](http://inch-ci.org/github/layer8x/youtube-dl.rb)
[![Dependency Status](https://gemnasium.com/layer8x/youtube-dl.rb.svg)](https://gemnasium.com/layer8x/youtube-dl.rb)

[![Build history for master branch](https://buildstats.info/travisci/chart/layer8x/youtube-dl.rb?branch=master&buildCount=50)](https://travis-ci.org/layer8x/youtube-dl.rb/builds)
[![Stories in Ready](https://badge.waffle.io/layer8x/youtube-dl.rb.svg?label=ready&title=Ready)](http://waffle.io/layer8x/youtube-dl.rb)

## Gem::InstallError: activesupport requires Ruby version >= 2.2.2.

This gem indirectly depends on ActiveSupport, but ActiveSupport 5 (the latest version) requires Ruby version >= 2.2.2. If you are using a version older than this, add this line to your `Gemfile`:

```
gem 'activesupport', '< 5.0'
```

## Install the gem

**IMPORTANT NOTE:** The [`youtube_dl`](https://github.com/ystomar-work/youtube_dl) gem and the [`ruby-youtube-dl`](https://github.com/bnmrrs/ruby-youtube-dl) gem will [cause a conflict](https://github.com/layer8x/youtube-dl.rb/issues/24) with this gem. Please `gem uninstall` those gems before using this one.

Add this line to your application's Gemfile:

```ruby
gem 'youtube-dl.rb'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install youtube-dl.rb

## Install youtube-dl
This gem ships with the latest (working) version of youtube-dl built-in, so you don't have to install youtube-dl at all! Unless you want to.

Some features of youtube-dl require ffmpeg or avconf to be installed.  Normally these are available for installation from your distribution's repositories.

## Usage

Pretty simple.

```ruby
YoutubeDL.download "https://www.youtube.com/watch?v=gvdf5n-zI14", output: 'some_file.mp4'
```

All options available to youtube-dl can be passed to the options hash

```ruby
options = {
  username: 'someone',
  password: 'password1',
  rate_limit: '50K',
  format: :worst,
  continue: false
}

YoutubeDL.download "https://www.youtube.com/watch?v=gvdf5n-zI14", options
```

Options passed as `options = {option: true}` or `options = {option: false}` are passed to youtube-dl as `--option` or `--no-option`

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Pass test suite (`rake test`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create a new Pull Request

Remember: commit now, commit often.
