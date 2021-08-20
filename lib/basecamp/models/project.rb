module Basecamp
  class Project < Model
    def todoset_dock
      dock.detect { |docked| docked['title'] == 'To-dos' }
    end

    def todoset
      return nil unless todoset_dock

      fetch todoset_dock['url'], Todoset
    end
  end
end
