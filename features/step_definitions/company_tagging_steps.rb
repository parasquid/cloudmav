Given /^there is an employee with a job tagged "([^"]*)"$/ do |tag|
  employee = Factory.create(:user).profile
  employee.save
  job = Factory.create(:job, :profile => employee, :company => @company, :tags_text => tag)
  job.retag!
end

When /^the company's tags are calculated$/ do
  company = Company.find(@company.id)
  company.retag!
end

Then /^the company should be tagged "([^"]*)"$/ do |tag|
  company = Company.find(@company.id)
  company.has_tag?(tag).should == true
end

Then /^the company tag "([^"]*)" should have a count of (\d+)$/ do |tag, count|
  company = Company.find(@company.id)
  t = company.get_tagging(tag)
  t.count.should == count.to_i
end

Then /^the company tag "([^"]*)"\tshould have a weighted score of (\d+)$/ do |tag, score|
  company = Company.find(@company.id)
  t = company.get_tagging(tag)
  t.score.should == score.to_f
end
