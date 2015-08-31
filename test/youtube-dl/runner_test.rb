require_relative '../test_helper'

describe YoutubeDL::Runner do
  before do
    @runner = YoutubeDL::Runner.new(TEST_URL)
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

  it 'should detect system youtube-dl' do
    vendor_bin = File.join(Dir.pwd, 'vendor', 'bin', 'youtube-dl')
    Dir.mktmpdir do |tmpdir|
      FileUtils.cp vendor_bin, tmpdir

      old_path = ENV["PATH"]
      ENV["PATH"] = "#{tmpdir}:#{old_path}"

      runner_usable_path = @runner.send(:usable_executable_path)
      assert_match runner_usable_path, "#{tmpdir}/youtube-dl"

      ENV["PATH"] = old_path
    end
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
    @runner.options.output = TEST_FILENAME
    @runner.options.format = TEST_FORMAT
    @runner.run
    assert File.exists? TEST_FILENAME
  end

  it 'should take options as a hash yet still have configuration blocks work' do
    r = YoutubeDL::Runner.new(TEST_URL, {some_key: 'some value'})
    r.options.configure do |c|
      c.another_key = 'another_value'
    end

    assert_includes r.to_command, "--some-key"
    assert_includes r.to_command, "--another-key"
  end

  it 'should handle strangely-formatted options correctly' do # See issue #9
    options = {
      format: 'bestaudio',
      :"prefer-ffmpeg" => "true",
      :"extract-audio" => true,
      :"audio-format" => "mp3"
    }

    @runner.options = YoutubeDL::Options.new(options)
    assert_match /youtube-dl --format 'bestaudio' --prefer-ffmpeg --extract-audio --audio-format 'mp3'/, @runner.to_command
  end
end
