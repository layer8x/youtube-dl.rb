require_relative '../test_helper'

describe YoutubeDL::Runner do
  before do
    @options = YoutubeDL::Options.new
    @options[:some_option] = true
    @options[:another_option] = 50

    @runner = YoutubeDL::Runner.new(@options)
  end

  it 'should set cocaine runner' do
    @runner.backend_runner = Cocaine::CommandLine::BackticksRunner.new
    assert_instance_of Cocaine::CommandLine::BackticksRunner, @runner.backend_runner

    @runner.backend_runner = Cocaine::CommandLine::PopenRunner.new
    assert_instance_of Cocaine::CommandLine::PopenRunner, @runner.backend_runner
  end
end
