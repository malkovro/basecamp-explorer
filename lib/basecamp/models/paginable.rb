module Basecamp
  class Paginable
    include Enumerable
    
    attr_reader :client, :total_count, :model_class, :params
    attr_accessor :next_page, :models

    def initialize(client, url, model_class, **params)
      @client = client
      @model_class = model_class
      @params = params
      self.next_page = url
      self.next_page += "?#{URI.encode_www_form(params)}" if params.any?
      self.models = []
      load_page
    end

    def [](index)
      return nil if index > count

      loop do
        return models[index] if index < models.count
      
        load_page
      end
    end

    def each
      index = 0
      loop do
        models.drop(index).each do |model|
          index += 1
          yield model_class.new(client, model)
        end

        break unless next_page
        load_page
      end
    end

    def count
      total_count
    end

    private

    def load_page
      request = client.class.get(next_page, headers: client.authorization_header)
      @total_count ||= request.headers['x-total-count'].to_i
      models.concat request.parsed_response.map { |vo| model_class.new(client, vo) }
      update_next_page(request.headers)
    end

    def update_next_page(headers)
      rels_headers = parse_link_header(headers['Link'])
      self.next_page = rels_headers[:next]
    end

    def parse_link_header(link_header)
      return {} if link_header.nil?

      parts = link_header.split(',')

      parts.map do |part, _|
        section = part.split(';')
        name = section[1][/rel="(.*)"/, 1].to_sym
        url = section[0][/<(.*)>/, 1]
   
        [name, url]
      end.to_h
    end
  end
end
