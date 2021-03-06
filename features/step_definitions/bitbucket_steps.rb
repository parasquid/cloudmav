When /^I sync my Bitbucket account$/ do
  VCR.use_cassette("bitbucket", :record => :new_episodes) do
    visit profile_syncable_path(@profile)
    fill_in "bitbucket_profile_username", :with => 'rookieone'
    within("#sync_bitbucket") do
      click_button "Sync"
    end
  end
end

Then /^I should have a Bitbucket profile$/ do
  Profile.find(@profile.id).bitbucket_profile.should_not be_nil
end

Then /^I should have the collection of my Bitbucket repos$/ do
  profile = Profile.find(@profile.id)
  profile.bitbucket_profile.repositories.count.should > 0
end

Then /^I should not see their Bitbucket profile$/ do
  page.has_selector?("#bitbucket_info").should == false
end

Then /^I should see their Bitbucket profile$/ do
  page.has_selector?("#bitbucket_info").should == true
end

Given /^the other user has a Bitbucket profile$/ do
  VCR.use_cassette("other bitbucket", :record => :new_episodes) do
    Factory.create(:bitbucket_profile, :username => "rookieone", :profile => @other_user.profile, :last_synced_date => DateTime.now)
    @other_user.profile.save
  end
end

Given /^I have a Bitbucket profile$/ do
  VCR.use_cassette("my bitbucket", :record => :new_episodes) do
    bb = Factory.create(:bitbucket_profile, :username => "rookieone", :profile => @profile, :last_synced_date => DateTime.now)
    @profile.save
    bb.sync!
  end
end

When /^I edit my Bitbucket id$/ do
  VCR.use_cassette("edit bitbucket", :record => :new_episodes) do
    profile = Profile.find(@profile.id)
    @old_repositories = profile.bitbucket_profile.repositories.to_a
    visit profile_syncable_path(@profile)
    fill_in "bitbucket_profile_username", :with => "claudiolassala"
    within("#sync_bitbucket") do
      click_button "Sync"
    end
  end
end

Then /^my old Bitbucket repositories should be deleted$/ do
  old_ids = @old_repositories.map(&:id)
  BitbucketRepository.any_in(:_id => old_ids).count.should == 0
end

Then /^I should have my new Bitbucket repositories$/ do
  profile = Profile.find(@profile.id)
  profile.bitbucket_profile.repositories.count.should > 0
end

When /^I delete my Bitbucket profile$/ do
  visit profile_syncable_path(@profile)
  profile = Profile.find(@profile.id)
  @old_repositories = profile.bitbucket_profile.repositories.to_a
  click_link "delete_bitbucket"
end

Then /^I should not have a Bitbucket profile$/ do
  Profile.find(@profile.id).bitbucket_profile.should be_nil
end

Then /^my Bitbucket repos should have their information$/ do
  @profile.reload
  repo = @profile.bitbucket_profile.repositories[0]
  repo.url.should_not be_nil
end

When /^I there is an error with my Bitbucket sync$/ do
  @profile.reload
  @profile.bitbucket_profile.error_message = "Bad username"
  @profile.bitbucket_profile.save
end

Then /^I should see my Bitbucket error on my syncable page$/ do
  visit profile_syncable_path(@profile)
  And %Q{I should see "Bad username"}
end

