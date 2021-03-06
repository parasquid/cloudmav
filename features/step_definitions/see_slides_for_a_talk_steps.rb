Then /^I should see the user does not have a SlideShare account$/ do
  page.should have_content("#{@user.profile.display_name} has not signed up for a SlideShare account yet")
end

Given /^the user has a SlideShare profile$/ do
  Factory.create(:slide_share_profile, :profile => @user.profile)
end

Then /^I should see the user has not added the slides to SlideShare yet$/ do
  page.should have_content("#{@user.profile.display_name} has not added the slides to their SlideShare account yet")
end

Given /^the talk is on SlideShare$/ do
  @talk.has_slide_share = true
  @talk.slideshow_html = "FAKE SLIDES"
  @talk.save
end

Then /^I should be able to view the slides$/ do
  page.should have_css("#slideshow")
end
