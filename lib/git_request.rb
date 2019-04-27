require 'net/http'

module GitRequest
  extend self

  def user(token)
    user_url = 'https://api.github.com/user'
    user_json = fetch(token, user_url)
    user_json
  end

  def repos(token, user)
    repos_url = user['repos_url']
    repos_json = fetch(token, repos_url)
    repos_json
  end

  def issues(token, user, repo, sort_key)
    issues_url = ['https://api.github.com/repos', user, repo, 'issues'].join('/')
    issues_json = fetch(token, issues_url)
    issues_json.sort_by { |i| i[sort_key] }
  end

  private

  def fetch(token, url)
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
