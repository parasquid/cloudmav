class Tagging 
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :count, :type => Integer, :default => 0
  field :score, :type => Float, :default => 0.0
  
  belongs_to :tag
  belongs_to :taggable, :polymorphic => true

  def to_s
    tag.to_s
  end
end
