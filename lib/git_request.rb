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
    issues_json = sort_issues(issues_json, sort_key) if sort_key

    issues_json.each do |i|
      formated_date = Date.parse(i['created_at']).strftime('%m/%d/%Y')
      i['created_at'] = formated_date 

      diff_date = DateTime.now - DateTime.parse(i['updated_at'])
      i['updated_at'] = diff_date * 24 * 60 * 60.to_i
    end
  end

  def sort_issues(issues_json, sort_key)
    if sort_key == 'created_at_asc'
      issues_json.sort! { |a,b| DateTime.parse(a['created_at']) <=> DateTime.parse(b['created_at']) }
    elsif sort_key == 'created_at_desc'
      issues_json.sort! { |a,b| DateTime.parse(b['created_at']) <=> DateTime.parse(a['created_at']) }
    else
      issues_json.sort_by! { |i| i[sort_key] }
    end

    issues_json
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
  require 'date'

  class GitRequestTests < MiniTest::Test
    ISSUES_CONST = [
      { "created_at"=>"2020-04-29T02:19:25Z", "title"=>"b" },
      { "created_at"=>"2018-04-29T02:19:25Z", "title"=>"a" },
      { "created_at"=>"2019-04-29T02:19:25Z", "title"=>"c" }
    ]

    def test_desc
      actual = GitRequest.sort_issues(ISSUES_CONST, 'created_at_asc')
      expected = [ { "created_at"=>"2018-04-29T02:19:25Z", "title"=>"a" },
                   { "created_at"=>"2019-04-29T02:19:25Z", "title"=>"c" },
                   { "created_at"=>"2020-04-29T02:19:25Z", "title"=>"b" }
                 ]
      assert_equal expected, actual
    end

    def test_asc
      actual = GitRequest.sort_issues(ISSUES_CONST, 'created_at_desc')
      expected = [ { "created_at"=>"2020-04-29T02:19:25Z", "title"=>"b" },
                   { "created_at"=>"2019-04-29T02:19:25Z", "title"=>"c" },
                   { "created_at"=>"2018-04-29T02:19:25Z", "title"=>"a" }
                 ]
      assert_equal expected, actual
    end

    def test_title
      actual = GitRequest.sort_issues(ISSUES_CONST, 'title')
      expected = [ { "created_at"=>"2018-04-29T02:19:25Z", "title"=>"a" },
                   { "created_at"=>"2020-04-29T02:19:25Z", "title"=>"b" },
                   { "created_at"=>"2019-04-29T02:19:25Z", "title"=>"c" }
                 ]
      assert_equal expected, actual
    end
  end
end
