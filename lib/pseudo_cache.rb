class PseudoCache
  def self.instance
    Thread.current[:pseudo_cache] ||= {}
  end

  def self.clean
    Thread.current.thread_variable_set(:pseudo_cache, nil)
  end
end
