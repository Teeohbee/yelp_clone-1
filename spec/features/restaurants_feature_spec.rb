require 'rails_helper'

feature 'restaurants' do

  context 'after signing in' do
    before(:each) do
      user = User.create(email: "test3@test.com", password: "testpass", provider: "facebook", uid: 12345)
      visit '/'
      click_link 'Sign in'
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_button "Log in"
    end

    scenario 'prompts user to fill out a form, then displays the new restaurant' do
      click_link 'Add a restaurant'
      fill_in 'Name', with: 'KFC'
      click_button 'Create Restaurant'
      expect(page).to have_content 'KFC'
      expect(current_path).to eq '/restaurants'
    end

    scenario 'let a user edit a restaurant' do
      Restaurant.create(name:'KFC')
      visit '/restaurants'
      click_link 'Edit KFC'
      fill_in 'Name', with: 'Kentucky Fried Chicken'
      click_button 'Update Restaurant'
      expect(page).to have_content 'Kentucky Fried Chicken'
      expect(current_path).to eq '/restaurants'
    end

    scenario 'removes a restaurant when a user clicks a delete link' do
      Restaurant.create(name:'KFC')
      visit '/restaurants'
      click_link 'Delete KFC'
      expect(page).not_to have_content 'KFC'
      expect(page).to have_content 'Restaurant deleted successfully'
    end

  end

    context "not signed in" do
      scenario 'user must be logged in to create a restaurant' do
        visit '/'
        click_link 'Add a restaurant'
        expect(Restaurant.count).to be(0)
        expect(page).to have_content('You need to sign in or sign up before continuing')
      end
    end

  context 'no restaurants have been added' do
    scenario 'should display a prompt to add a restaurant' do
      visit '/restaurants'
      expect(page).to have_content 'No restaurants yet'
      expect(page).to have_link 'Add a restaurant'
    end

    context 'restaurants have been added' do
      before do
        Restaurant.create(name: 'KFC')
      end

      scenario 'display restaurants' do
        visit '/restaurants'
        expect(page).to have_content('KFC')
        expect(page).not_to have_content('No restaurants yet')
      end
    end
  end

  context 'viewing restaurants' do
    let!(:kfc){Restaurant.create(name:'KFC')}
    scenario 'lets a user view a restaurant' do
      visit '/restaurants'
      click_link 'KFC'
      expect(page).to have_content 'KFC'
      expect(current_path).to eq "/restaurants/#{kfc.id}"
    end
  end

end
