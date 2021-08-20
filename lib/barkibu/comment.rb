module Barkibu
  class Comment < SimpleDelegator
    PR_REGEX = %r{https://github\.com/.*/pull/(?<number>\d+)}.freeze
    WORK_STARTED_REGEX = /Moved this to Kanban list: .*In Progress/.freeze

    def mention_pr?
      !content.match(PR_REGEX).nil?
    end

    def pr_number
      match = content.match(PR_REGEX)
      match[:number].to_i unless match.nil?
    end

    def work_started?
      !content.match(WORK_STARTED_REGEX).nil?
    end
  end
end
