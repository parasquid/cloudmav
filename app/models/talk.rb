class Talk
  include Mongoid::Document
  
  field :title, :type => String
  field :description, :type => String
  field :slides_url, :type => String
  field :slides_thumbnail, :type => String
  field :imported_id, :type => String
  field :tags, :type => Array, :default => []
  
  referenced_in :profile, :inverse_of => :talks
  embeds_many :presentations
  
  after_save :add_to_index
  after_destroy :remove_from_index
    
  def add_presentation(presentation)
    self.profile.earn("for presentation", 20, :speaker_points)
  end
  
  def tags_text
    return "" if self.tags.nil?
    self.tags.join(", ")
  end
  
  def tags_text=(value)
    self.tags = value.split(',')
  end
  
  def self.search(query, options = {})
    search = Sunspot.new_search(Talk)
    search.build do
      keywords query do
      end
    end
    search.execute
  end

  private
    def add_to_index
      return if Rails.env.test?
      Sunspot.index!(self) 
    rescue Errno::ECONNREFUSED
      puts "We could not index, likely because SOLR isn't running"
    rescue RSolr::RequestError
      puts "Solr is hating"
    end

    def remove_from_index
      return if Rails.env.test?
      Sunspot.remove(self)
    rescue Errno::ECONNREFUSED
      puts "We could not index, likely because SOLR isn't running"
    rescue RSolr::RequestError
      puts "Solr is hating"
    end
end