module Github
  class Releases
    @as_hash = {}

    def self.as_hash(client, repository)
      @as_hash[repository] ||= client.releases(repository).map do |release|
        [client.refs(repository, "tags/#{release.tag_name}").object.sha,
         { created_at: release.created_at, tag_name: release.tag_name }]
      end.to_h
    end
  end
end
