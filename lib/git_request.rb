# /lib/foo.rb

module GitRequest
  def self.hello
    "hello"
  end
end

if __FILE__ == $0
  require 'minitest/autorun'
  require 'active_support'
  require 'active_support/time'

   class GitRequestTests < MiniTest::Test
    def test_basic
      actual = OutlookFixer.add_utc_offset '2019-04-05T01:01:01'
      expected = '2019-04-05T01:01:01Z'
      assert_equal expected, actual
    end

     def test_no_op
      actual = OutlookFixer.add_utc_offset '2019-04-05T01:01:01Z'
      expected = '2019-04-05T01:01:01Z'
      assert_equal expected, actual
    end

     def test_ipad
      actual = OutlookFixer.add_utc_offset '2019-04-05 01:01:01'
      expected = '2019-04-05T01:01:01Z'
      assert_equal expected, actual
    end
  end
end
