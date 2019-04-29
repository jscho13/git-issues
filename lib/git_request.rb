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
    if sort_key == 'created_at_asc'
      issues_json.sort! { |a,b| DateTime.parse(a['created_at']) <=> DateTime.parse(b['created_at']) }
    elsif sort_key == 'created_at_desc'
      issues_json.sort! { |a,b| DateTime.parse(b['created_at']) <=> DateTime.parse(a['created_at']) }
    else
      issues_json.sort_by! { |i| i[sort_key] }
    end

    issues_json.each do |i|
      formated_date = Date.parse(i['created_at']).strftime('%m/%d/%Y')
      i['created_at'] = formated_date 

      diff_date = DateTime.now - DateTime.parse(i['updated_at'])
      i['updated_at'] = diff_date * 24 * 60 * 60.to_i
    end
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
