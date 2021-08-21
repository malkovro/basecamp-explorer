module Barkibu
  class Comment < SimpleDelegator
    PR_REGEX = %r{https://github\.com/(?<org>[^/]*)/(?<repo>[^/]*)/pull/(?<number>\d+)}.freeze
    WORK_STARTED_REGEX = /Moved this to Kanban list: .*In Progress/.freeze

    def mention_pr?
      !content.match(PR_REGEX).nil?
    end

    def pull_requests(github_client)
      content.scan(PR_REGEX).uniq.map do |org, repo, pull_request_number|
        github_client.pull_request("#{org}/#{repo}", pull_request_number)
      end
    end

    def work_started?
      !content.match(WORK_STARTED_REGEX).nil?
    end
  end
end
