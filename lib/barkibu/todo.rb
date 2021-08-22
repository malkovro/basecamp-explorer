module Barkibu
  class Todo < Model
    def reportable?
      mention_pr? && work_started?
    end

    def comments
      @comments ||= super.map do |comment|
        Barkibu::Comment.new(comment, gh_client)
      end
    end

    def mention_pr?
      comments.any?(&:mention_pr?)
    end

    def work_started?
      comments.any?(&:work_started?)
    end

    def work_started_at
      comments.detect(&:work_started?).created_at
    end

    def pr_comments
      comments.select(&:mention_pr?)
    end

    def pull_requests
      @pull_requests ||= pr_comments.map(&:pull_requests).flatten
    end

    def latest_release
      @latest_release ||= pull_requests.map(&:release).max do |release_a, release_b|
        release_a[:created_at] <=> release_b[:created_at]
      end
    end
  end
end
