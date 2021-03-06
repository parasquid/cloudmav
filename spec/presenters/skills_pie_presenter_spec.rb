require 'spec_helper'

describe SkillsPiePresenter do
  before(:each) do
    @profile = Factory.create(:user).profile
  end
  
  describe "get data" do
    context "One skill" do
      before(:each) do
        @profile.earn_skill(100, "ruby", :coder, "for GitHub repository", GitHubRepository.new)
        @profile.earn_skill(20, "ruby", :coder, "for StackOverflow", StackOverflowProfile.new)
        @data = SkillsPiePresenter.get_data(@profile)
      end
      it { @data[0]["skill"].should == "ruby" }
      it { @data[0]["score"].should == 120 }
      it { @data[0]["percent"].should == 100 }        
    end

    context "Two skills" do
      before(:each) do
        @profile.earn_skill(800, "ruby", :coder, "for GitHub repository", GitHubRepository.new)
        @profile.earn_skill(200, "csharp", :coder, "for StackOverflow", StackOverflowProfile.new)
        @data = SkillsPiePresenter.get_data(@profile)
      end
      it { @data[0]["skill"].should == "ruby" }
      it { @data[0]["score"].should == 800 }
      it { @data[0]["percent"].should == 80 }
      it { @data[1]["skill"].should == "csharp" }
      it { @data[1]["score"].should == 200 }
      it { @data[1]["percent"].should == 20 }  
    end
  end
  
  describe "as_javascript" do
    before(:each) do
      @data = [
        { "skill" => "ruby", "score" => 200, "percent" => 20 },
        { "skill" => "csharp", "score" => 800, "percent" => 80 }
      ]
      @javascript = SkillsPiePresenter.as_javascript(@data)
    end
    it { @javascript.should == %Q{[{"skill":"ruby", "score":200, "percent":20}, {"skill":"csharp", "score":800, "percent":80}]} }
  end
  
end