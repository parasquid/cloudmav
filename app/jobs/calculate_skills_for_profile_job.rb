class CalculateSkillsForProfileJob
  @queue = :scoring
  
  def self.perform(profile_id)
    profile = Profile.find(profile_id)
    profile.clear_skills!
    
    # knowledge
    
    # experience
    calculate_skills_for_jobs(profile)
    
    # coder
    calculate_skills_for_git_hub(profile)
    # speaker
    calculate_skills_for_talks(profile)
    
    # writer
    # social
    
    profile.save
  end
  
  def self.calculate_skills_for_git_hub(profile)
    return if profile.git_hub_profile.nil?
    
    profile.git_hub_profile.repositories.each do |r|
      r.clear_skills!      
      skills = get_skills_from_taggable(r)
      
      if (skills.count > 0)
        skill_score = r.total_score / skills.count
        skills.each do |skill|
          r.earn_skill(skill_score, skill.name, :coder, "for GitHub repository", r)
          profile.earn_skill(skill_score, skill.name, :coder, "for GitHub repository", r)
        end
      end      
    end
  end
  
  def self.calculate_skills_for_talks(profile)
    profile.talks.each do |talk|
      talk.clear_skills!
      skills = get_skills_from_taggable(talk)
      
      if (skills.count > 0)
        skill_score = talk.total_score / skills.count
        skills.each do |skill|
          talk.earn_skill(skill_score, skill.name, :speaker, "for Talk", talk)
          profile.earn_skill(skill_score, skill.name, :speaker, "for Talk", talk)
        end
      end
      #profile.earn(talk.total_score, :speaker_points, "for Talk", talk) 
    end
  end
  
  def self.calculate_skills_for_jobs(profile)
    profile.jobs.each do |job|
      job.clear_skills!
      skills = get_skills_from_taggable(job)

      if (skills.count > 0)
        skill_score = job.total_score / skills.count
        skills.each do |skill|
          job.earn_skill(skill_score, skill.name, :experience, "for Job", job)
          profile.earn_skill(skill_score, skill.name, :experience, "for Job", job)
        end
      end
    end    
  end
  
  def self.get_skills_from_taggable(taggable)
    skills = []
    tags = taggable.tags
    Skill.all.each do |skill|
      tag_found = false
      skill.tags.each do |t|
        if (tags.include? t)
          tag_found = true
        end
      end
      
      if (tag_found)
        skills << skill
      end
    end
    skills
  end

end