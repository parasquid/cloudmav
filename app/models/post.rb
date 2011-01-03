class Post
  include Mongoid::Document
  
  field :title, :type => String
  field :written_on, :type => DateTime  
  field :url, :type => String
  
  embedded_in :blog, :inverse_of => :posts
  embedded_in :profile, :inverse_of => :posts
end