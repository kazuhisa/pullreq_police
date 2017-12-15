require 'octokit'
require 'yaml'

setting = YAML.load_file('setting.yml')
client = Octokit::Client.new(access_token: setting['github_token'])
list = setting['branches']
(list.size - 1).times.each do |idx|
  retry_counter = 0
  begin
    from_branch = list[idx]
    to_branch = list[idx + 1]
    client.create_pull_request(setting['repos'], to_branch, from_branch, setting['title'], setting['body'])
  rescue Octokit::BadGateway
    retry_counter += 1
    retry if retry_counter < 3
  rescue Octokit::UnprocessableEntity => e
    puts e.message
  end
end
