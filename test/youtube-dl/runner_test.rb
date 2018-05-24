require_relative '../test_helper'

describe YoutubeDL::Runner do
  before do
    @runner = YoutubeDL::Runner.new(TEST_URL)
  end

  after do
    remove_downloaded_files
  end

  describe '#initialize' do
    it 'should take options as a hash yet still have configuration blocks work' do
      r = YoutubeDL::Runner.new(TEST_URL, {some_key: 'some value'})
      r.options.configure do |c|
        c.another_key = 'another_value'
      end

      assert_includes r.to_command, "--some-key"
      assert_includes r.to_command, "--another-key"
    end
  end

  describe '#executable_path' do
    it 'should set executable path automatically' do
      assert_match 'youtube-dl', @runner.executable_path
    end

    it 'should not have a newline char in the executable_path' do
      assert_match(/youtube-dl\z/, @runner.executable_path)
    end
  end

  describe '#backend_runner=, #backend_runner' do
    it 'should set terrapin runner' do
      @runner.backend_runner = Terrapin::CommandLine::BackticksRunner.new
      assert_instance_of Terrapin::CommandLine::BackticksRunner, @runner.backend_runner

      @runner.backend_runner = Terrapin::CommandLine::PopenRunner.new
      assert_instance_of Terrapin::CommandLine::PopenRunner, @runner.backend_runner
    end
  end

  describe '#to_command' do
    it 'should parse key-values from options' do
      @runner.options.some_key = "a value"

      refute_nil @runner.to_command.match(/--some-key\s.*a value.*/)
    end

    it 'should handle true boolean values' do
      @runner.options.truthy_value = true

      assert_match(/youtube-dl .*--truthy-value\s--|\"http.*/, @runner.to_command)
    end

    it 'should handle false boolean values' do
      @runner.options.false_value = false

      assert_match(/youtube-dl .*--no-false-value\s--|\"http.*/, @runner.to_command)
    end

    it 'should not have newline char in to_command' do
      assert_match(/youtube-dl\s/, @runner.to_command)
    end
  end

  describe '#run' do
    it 'should run commands' do
      @runner.options.output = TEST_FILENAME
      @runner.options.format = TEST_FORMAT
      @runner.run
      assert File.exists? TEST_FILENAME
    end
  end

  describe '#configure' do
    it 'should update configuration options' do
      @runner.configure do |c|
        c.output = TEST_FILENAME
      end

      assert_equal TEST_FILENAME, @runner.options.output
    end
  end
end
