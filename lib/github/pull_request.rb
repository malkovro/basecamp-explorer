module Github
  class PullRequest < Model
    def release
      published_release = nil
      Commits.singleton_for(client, repository).each do |commit|
        published_release = releases[commit.sha] if releases[commit.sha]

        return published_release if commit.sha == merge_commit_sha
      end

      nil
    end

    def releases
      Releases.as_hash(client, repository)
    end
  end
end
