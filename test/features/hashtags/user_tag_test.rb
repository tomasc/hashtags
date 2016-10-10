require 'test_helper'

describe 'User Tag tes', :capybara do
  let(:action) do
    visit new_doc_path
  end

  before { action }

  it 'allows to insert user tag' do
    fill_in 'doc_text', with: '@'
    page.must_have_content 'xmxmx'
  end
end
