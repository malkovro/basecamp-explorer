module Barkibu
  class Comment < Model
    PR_REGEX = %r{https://github\.com/(?<org>[^/]*)/(?<repo>[^/]*)/pull/(?<number>\d+)}.freeze
    WORK_STARTED_REGEX = %r{Moved this to Kanban list: <b>(?<kanbancol>.*)</b>}.freeze
    WORK_INITIATED_KANBAN_COLUMNS = ['In Progress', 'Waiting for PR review', 'Waiting for QA'].freeze

    def mention_pr?
      !content.match(PR_REGEX).nil?
    end

    def pull_requests
      content.scan(PR_REGEX).uniq.map do |org, repo, pull_request_number|
        gh_client.pull_request("#{org}/#{repo}", pull_request_number)
      end
    end

    # This could be worked on, stripping html tags and checking the all sentence instead
    # of relying on this <span> detection...
    def work_started?
      content.scan(WORK_STARTED_REGEX).any? do |match|
        WORK_INITIATED_KANBAN_COLUMNS.include? match[0]
      end
    end
  end
end
