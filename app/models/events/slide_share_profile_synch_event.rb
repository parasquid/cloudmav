class SlideShareProfileSynchEvent < SynchEvent
  referenced_in :slide_share_profile, :inverse_of => :events

  def synch
    response = SlideShare.get_slideshows_by_user(slide_share_profile.slide_share_username)
    response["User"]["Slideshow"].each do |ss_talk|
      self.profile.talks << create_talk(ss_talk) unless has_talk?(ss_talk)
    end
    slide_share_profile.url = "http://www.speakerrate.net/#{slide_share_profile.slide_share_username}"
    profile.save!
    slide_share_profile.save!
  end

  def has_talk?(ss_talk)
    !profile.talks.where(:imported_id => ss_talk["ID"]).first.nil?
  end
  
  def create_talk(ss_talk)
    talk = Talk.new
    talk.title = ss_talk["Title"]
    talk.description = ss_talk["Description"]
    talk.slides_url = ss_talk["DownloadUrl"]
    talk.slides_thumbnail = ss_talk["ThumbnailURL"]
    talk.imported_id = ss_talk["ID"]
    return talk
  end

end
