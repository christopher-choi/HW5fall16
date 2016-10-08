# Completed step definitions for basic features: AddMovie, ViewDetails, EditMovie 

Given /^I am on the RottenPotatoes home page$/ do
  visit movies_path
 end


 When /^I have added a movie with title "(.*?)" and rating "(.*?)"$/ do |title, rating|
  visit new_movie_path
  fill_in 'Title', :with => title
  select rating, :from => 'Rating'
  click_button 'Save Changes'
 end

 Then /^I should see a movie list entry with title "(.*?)" and rating "(.*?)"$/ do |title, rating| 
   result=false
   all("tr").each do |tr|
     if tr.has_content?(title) && tr.has_content?(rating)
       result = true
       break
     end
   end  
  expect(result).to be_truthy
 end

 When /^I have visited the Details about "(.*?)" page$/ do |title|
   visit movies_path
   click_on "More about #{title}"
 end

 Then (/^(?:|I )should see "([^"]*)"$/) do |text|
    expect(page).to have_content(text)
 end

 When /^I have edited the movie "(.*?)" to change the rating to "(.*?)"$/ do |movie, rating|
  click_on "Edit"
  select rating, :from => 'Rating'
  click_button 'Update Movie Info'
 end


# New step definitions to be completed for HW5. 
# Note that you may need to add additional step definitions beyond these


# Add a declarative step here for populating the DB with movies.

Given /the following movies have been added to RottenPotatoes:/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create(movie)
  end
end

When /^I have opted to see movies rated: "(.*?)"$/ do |rating_list|
    rating_list = rating_list.split(%r{,\s*})
    ratings = ["G","PG","R","NC-17","PG-13"]
    ratings.each do |r|
        if rating_list.include?(r)
            check("ratings_#{r}")
        else
            uncheck("ratings_#{r}")
        end
    click_button 'Refresh'
  end
end

Then /^I should see only movies rated: "(.*?)"$/ do |rating_list|
    ratings = rating_list.split(%r{,\s*})
    rating_check = true
    page.all("tr/td[2]").each do |r|
        if (ratings.include? r.text) == false
            rating_check = false
        end
    end
    expect(rating_check).to be_truthy
end

Then /^I should see all of the movies$/ do
    expect(page.all('tr/td[2]').count == Movie.count).to be_truthy
end

When /^I have opted to see movies sorted from A to Z$/ do
   click_link('Movie Title')
end

Then(/^I should see "(.*?)" before "(.*?)"$/) do |title1, title2|
    expect(page.body.index(title1) < page.body.index(title2)).to be_truthy
end

When /^I have opted to see movies sorted by release date$/ do
    click_link('Release Date')
end

Then(/^I should see the date "(.*?)" before "(.*?)"$/) do |date1, date2|
    expect(page.body.index(date1) < page.body.index(date2)).to be_truthy
end