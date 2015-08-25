require_relative '../test_helper'

describe YoutubeDL::Runner do
  before do
    @runner = YoutubeDL::Runner.new(NOPE)
  end

  after do
    remove_downloaded_files
  end

  it 'should set cocaine runner' do
    @runner.backend_runner = Cocaine::CommandLine::BackticksRunner.new
    assert_instance_of Cocaine::CommandLine::BackticksRunner, @runner.backend_runner

    @runner.backend_runner = Cocaine::CommandLine::PopenRunner.new
    assert_instance_of Cocaine::CommandLine::PopenRunner, @runner.backend_runner
  end

  it 'should set executable path automatically' do
    assert_match 'youtube-dl', @runner.executable_path
  end

  it 'should not have a newline char in the executable_path' do
    assert_match /youtube-dl\z/, @runner.executable_path
  end

  it 'should not have newline char in to_command' do
    assert_match /youtube-dl\s/, @runner.to_command
  end

  it 'should parse key-values from options' do
    @runner.options.some_key = "a value"

    refute_nil @runner.to_command.match(/--some-key\s.*a value.*/)
  end

  it 'should not include the value if value is true' do
    @runner.options.some_key = true

    refute @runner.to_command.include?("--some-key 'true'"), "adding true to boolean key >:("
  end

  it 'should run commands' do
    @runner.options.output = 'nope.flv'
    @runner.options.format = YOUTUBE_DL_FORMAT_FLV
    @runner.run
    assert File.exists? 'nope.flv'
  end

  it 'should take options as a hash yet still have configuration blocks work' do
    r = YoutubeDL::Runner.new(NOPE, {some_key: 'some value'})
    r.options.configure do |c|
      c.another_key = 'another_value'
    end

    assert_includes r.to_command, "--some-key"
    assert_includes r.to_command, "--another-key"
  end
end
