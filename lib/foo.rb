# /lib/foo.rb

module GitRequest
  def self.hello
    "hello"
  end
end

if __FILE__ == $PROGRAM_NAME
  require 'minitest/autorun'

  class GitRequestTests < MiniTest::Test
    def test_basic
      actual = GitRequest.hello
      expected = 'hello'
      assert_equal expected, actual
    end

    def test_no_op
      actual = GitRequest.hello
      expected = 'hello'
      assert_equal expected, actual
    end
  end
end
