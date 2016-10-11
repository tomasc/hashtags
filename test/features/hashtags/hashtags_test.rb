require 'test_helper'

describe 'Hashtags test', :capybara do
  let(:user) { ::User.find('JTschichold') }
  let(:res) { ::MyResource.find(1) }
  let(:var_1) { 'A' }

  let(:action) do
    visit new_doc_path
  end

  before { action }

  it 'allows to insert user tag', js: true do
    fill_in 'doc_text', with: "@#{user.id.first}"
    within('.textcomplete-dropdown') do
      find('.textcomplete-item.active').click
    end
    page.must_have_field 'doc_text', with: "@#{user.id}"
    click_button 'Create'
    page.must_have_content user.name
  end

  it 'allows to insert variable tag', js: true do
    fill_in 'doc_text', with: '$v'
    within('.textcomplete-dropdown') do
      find('.textcomplete-item.active').click
    end
    page.must_have_field 'doc_text', with: '$var_1'
    click_button 'Create'
    page.must_have_content var_1
  end

  it 'allows to insert resource tag', js: true do
    fill_in 'doc_text', with: '#'
    within('.textcomplete-dropdown') do
      find('.textcomplete-item.active').click
    end
    fill_in 'doc_text', with: find('#doc_text').value + res.title.first
    within('.textcomplete-dropdown') do
      find('.textcomplete-item.active').click
    end
    page.must_have_field 'doc_text', with: "##{MyResourceTag.resource_name}:#{res.title}(#{res.id})"
    click_button 'Create'
    page.must_have_content res.title
  end
end
