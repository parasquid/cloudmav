When /^I synch my SlideShare account$/ do
  VCR.use_cassette("slide_share", :record => :new_episodes) do
    visit new_profile_slide_share_profile_path(@profile)
    fill_in "slide_share_profile_slide_share_username", :with => 'rookieone'
    click_button "Save"
  end
end

Then /^I should have a SlideShare profile$/ do
  profile = User.find(@user.id).profile
  profile.slide_share_profile.should_not be_nil
end

Given /^I have synched my SlideShare account$/ do
  VCR.use_cassette("slide_share", :record => :new_episodes) do
    visit new_profile_slide_share_profile_path(@profile)
    fill_in "slide_share_profile_slide_share_username", :with => 'rookieone'
    click_button "Save"
  end
end

Then /^I should not have duplicate talks from SlideShare$/ do
  profile = Profile.find(@profile.id)
  profile.talks.where(:title => "Techfest design patterns").count.should == 1
end

Then /^I should import my talks from SlideShare$/ do
  profile = Profile.find(@profile.id)
  profile.talks.where(:title => "Techfest design patterns").count.should == 1
end

Then /^I should not see their SlideShare profile$/ do
  page.has_no_selector?("#slide_share_info").should == true
end

Given /^the other user has a SlideShare profile$/ do
  VCR.use_cassette('other slide_share ', :record => :new_episodes) do
    Factory.create(:slide_share_profile, :slide_share_username => "rookieone", :profile => @other_user.profile)
    @other_user.profile.save
    User.find(@other_user.id).profile.slide_share_profile.synch!
  end
end

Then /^I should see their SlideShare profile$/ do
  page.has_selector?("#slide_share_info").should == true
end

When /^I look at their presentation from SlideShare$/ do
  p = User.find(@other_user.id).profile
  talk = User.find(@other_user.id).profile.talks.first
  presentation = talk.presentations.first
  visit talk_presentation_path(talk, presentation)
end

Then /^I should be able to download the slides$/ do
  page.should have_css("#download_link")
end

Then /^I should see a preview of the slides$/ do
  page.should have_css("#slides_thumbnail")
end

Then /^I should see a slideshow$/ do
  page.should have_css("#slideshow")
end

Then /^I should have a slide count on my SlideShare profile$/ do
  profile = User.find(@user.id).profile
  profile.slide_share_profile.slides_count.should_not == 0
end

