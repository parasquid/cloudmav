class BacklogItemRecommendation
  include Mongoid::Document
  include Mongoid::Timestamps

  field :score, :type => Float, :default => 0.0
  
  referenced_in :backlog_item
  embedded_in :profile, :inverse_of => :backlog_item_recommendations

end