require_relative '../test_helper'

TestKlass = Class.new do
  include YoutubeDL::Support

  def executable_path
    usable_executable_path_for 'youtube-dl'
  end
end

describe YoutubeDL::Support do
  before do
    @klass = TestKlass.new
  end

  describe '#usable_executable_path' do
    it 'should detect system executable' do
      vendor_bin = File.join(Dir.pwd, 'vendor', 'bin', 'youtube-dl')
      Dir.mktmpdir do |tmpdir|
        FileUtils.cp vendor_bin, tmpdir

        old_path = ENV["PATH"]
        ENV["PATH"] = "#{tmpdir}:#{old_path}"

        usable_path = @klass.usable_executable_path_for('youtube-dl')
        assert_match usable_path, "#{tmpdir}/youtube-dl"

        ENV["PATH"] = old_path
      end
    end

    it 'should not have a newline char in the executable_path' do
      assert_match /youtube-dl\z/, @klass.executable_path
    end
  end
end
