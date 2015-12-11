require 'rails_helper'

RSpec.describe 'diseases/new', type: :view do
  before(:each) do
    assign(:disease, Disease.new(
                       name: 'MyString'
    ))
  end

  it 'renders new disease form' do
    render

    assert_select 'form[action=?][method=?]', diseases_path, 'post' do
      assert_select 'input#disease_name[name=?]', 'disease[name]'
    end
  end
end
