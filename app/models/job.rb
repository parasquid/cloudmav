class Job
  include Mongoid::Document
  include Mongoid::Timestamps
  include CodeMav::Taggable
  include CodeMav::Scorable
  include CodeMav::Skillable
  
  field :title, :type => String
  field :description, :type => String
  field :start_date, :type => DateTime
  field :end_date, :type => DateTime
  field :imported_id, :type => String  
  
  belongs_to :company, :inverse_of => :employments
  belongs_to :profile
  
  scope :chronological_order, order_by([[:start_date, :desc]])

  def company_name
    self.company ? self.company.name : ""
  end
  
  def display_description
    (self.description.nil? || self.description.blank?) ? "No description provided" : self.description
  end
  
  def display_date_range
    sd = "No start date"
    if self.start_date
      sd = self.start_date.strftime("%m/%d/%y")
    end
    
    ed = "Present"
    if self.end_date
      ed = self.end_date.strftime("%m/%d/%y")
    end
    
    "#{sd} - #{ed}"
  end
  
  def related_items
    [company, profile.experience_profile]
  end
  
  def generate_tags
  end
  
  def job_duration_in_days
    return 0 if self.start_date.nil?
    sd = Time.parse(self.start_date.to_s)
    if self.end_date.nil?
      ed = Time.now
    else
      ed = Time.parse(self.end_date.to_s)
    end
    duration_in_seconds = (ed - sd)
    # 60 secs in min; 60 mins in hour; 24 hours in day
    duration_in_seconds / 60 / 60 / 24
  end

end
