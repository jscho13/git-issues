module GitRequest
  extend self

  def repos(token)
    user = fetch('https://api.github.com/user', token)
    repos_url = user['repos_url']
    @repos = fetch(repos_url, token)
  end

  def issues
  end

  private

  def fetch(url, token)
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.hostname, uri.port)
    http.use_ssl = true

    req = Net::HTTP::Get.new(uri.request_uri)
    req['Authorization'] = 'token ' + token

    res = http.request(req)
    JSON.parse(res.body)
  end
end


if __FILE__ == $0
  require 'minitest/autorun'

  class GitRequestTests < MiniTest::Test
    def test_basic
      actual = OutlookFixer.add_utc_offset '2019-04-05T01:01:01'
      expected = '2019-04-05T01:01:01Z'
      assert_equal expected, actual
    end
  end
end
