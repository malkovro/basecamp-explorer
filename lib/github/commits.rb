module Github
  class Commits
    def self.singleton_for(client, repository)
      @instances ||= {}
      @instances[repository] ||= new(client.access_token, repository)
    end

    attr_reader :client, :access_token
    attr_accessor :next_page, :commits

    def initialize(access_token, repository_name)
      @client = Github::Client.new(access_token)
      repository = client.repository(repository_name)
      self.next_page = repository.agent.expand_url(repository.commits_url)
      self.commits = []
      load_page
    end

    def each
      index = 0

      loop do
        commits.drop(index).each do |commit|
          index += 1
          yield commit
        end

        break unless next_page

        load_page
      end
    end

    private

    def load_page
      commits.concat client.get(next_page, per_page: 100)
      self.next_page = client.last_response.rels[:next]&.href
    end
  end
end
