require 'octokit'
require 'yaml'

setting = YAML.load_file('setting.yml')
client = Octokit::Client.new(access_token: setting['github_token'])
list = setting['branches']
(list.size - 1).times.each do |idx|
  begin
    from_branch = list[idx]
    to_branch = list[idx + 1]
    client.create_pull_request(setting['repos'], to_branch, from_branch, setting['title'], setting['body'])
  rescue Octokit::UnprocessableEntity => e
    puts e.message
  end
end
