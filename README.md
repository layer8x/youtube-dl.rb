# youtube-dl.rb

Ruby wrapper for youtube-dl

## Installing youtube-dl
This gem does not ship with youtube-dl built in (yet), so you need to install manually.

### The easy way
Use your distro's package manager!

    $ apt-get install youtube-dl
    $ brew install youtube-dl

Or through Pip

    $ pip install youtube-dl

### The slightly harder way
```bash
sudo wget https://yt-dl.org/downloads/latest/youtube-dl -O /usr/local/bin/youtube-dl
sudo chmod a+x /usr/local/bin/youtube-dl
```

## Install the gem

Add this line to your application's Gemfile:

```ruby
gem 'youtube-dl.rb'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install youtube-dl.rb

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
  format: :worst
}

YoutubeDL.download "https://www.youtube.com/watch?v=gvdf5n-zI14", options
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Pass test suite (`rake test`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create a new Pull Request
