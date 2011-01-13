When /^I synch my SpeakerRate account$/ do
  visit new_speaker_rate_profile_path(:username => @profile.username)
  fill_in "speaker_rate_profile_speaker_rate_id", :with => '10082'
  click_button "Synch"
  And %Q{I should be redirected}
end

Then /^I should have a SpeakerRate profile$/ do
  profile = User.find(@user.id).profile
  profile.speaker_rate_profile.should_not be_nil
end

Then /^I should have (\d+) speaker points$/ do |number|
  profile = User.find(@user.id).profile
  profile.score(:speaker_points).should == number.to_i
end

Then /^I should have my talks from SpeakerRate$/ do
  profile = User.find(@user.id).profile
  profile.talks.where(:title => "Virtual Brown Bag").count.should == 1
end

Given /^I synched my SpeakerRate account$/ do
  visit new_speaker_rate_profile_path(:username => @profile.username)
  fill_in "speaker_rate_profile_speaker_rate_id", :with => '10082'
  click_button "Synch"
  And %Q{I should be redirected}
end

Then /^I should not have duplicate talks from SpeakerRate$/ do
  profile = User.find(@user.id).profile
  profile.talks.where(:title => "Virtual Brown Bag").count.should == 1
end
