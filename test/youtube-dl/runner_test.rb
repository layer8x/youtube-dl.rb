require_relative '../test_helper'

describe YoutubeDL::Runner do
  before do
    @runner = YoutubeDL::Runner.new(NOPE)
  end

  after do
    if File.exists? 'nope.avi'
      File.delete 'nope.avi'
    end
  end

  it 'should set cocaine runner' do
    @runner.backend_runner = Cocaine::CommandLine::BackticksRunner.new
    assert_instance_of Cocaine::CommandLine::BackticksRunner, @runner.backend_runner

    @runner.backend_runner = Cocaine::CommandLine::PopenRunner.new
    assert_instance_of Cocaine::CommandLine::PopenRunner, @runner.backend_runner
  end

  it 'should set executable path automatically' do
    assert_equal @runner.executable_path, 'youtube-dl'
  end

  it 'should parse key-values from options' do
    @runner.options.some_key = "a value"

    assert_includes @runner.to_command, "--some-key 'a value'"
  end

  it 'should not include the value if value is true' do
    @runner.options.some_key = true

    refute @runner.to_command.include?("--some-key 'true'"), "adding true to boolean key >:("
  end

  it 'should run commands' do
    @runner.options.output = 'nope.avi'
    @runner.run
    binding.pry
    assert File.exists? 'nope.avi'
  end
end
