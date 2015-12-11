require 'rails_helper'

RSpec.describe "notifications/index", type: :view do
  before(:each) do
    assign(:notifications, [
      Notification.create!(
        :sender_id => 1,
        :receiver_id => "",
        :notifiable_id => 2,
        :notifiable_type => "Notifiable Type"
      ),
      Notification.create!(
        :sender_id => 1,
        :receiver_id => "",
        :notifiable_id => 2,
        :notifiable_type => "Notifiable Type"
      )
    ])
  end

  it "renders a list of notifications" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "Notifiable Type".to_s, :count => 2
  end
end
