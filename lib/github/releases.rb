module Github
  class Releases
    def self.as_hash(client, repository)
      PseudoCache.instance[:releases] ||= {}
      PseudoCache.instance[:releases][repository] ||= client.releases(repository).map do |release|
        [client.refs(repository, "tags/#{release.tag_name}").object.sha,
         { created_at: release.created_at, tag_name: release.tag_name }]
      end.to_h
    end
  end
end
