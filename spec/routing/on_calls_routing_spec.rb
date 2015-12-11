require "rails_helper"

RSpec.describe OnCallsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/on_calls").to route_to("on_calls#index")
    end

    it "routes to #new" do
      expect(:get => "/on_calls/new").to route_to("on_calls#new")
    end

    it "routes to #show" do
      expect(:get => "/on_calls/1").to route_to("on_calls#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/on_calls/1/edit").to route_to("on_calls#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/on_calls").to route_to("on_calls#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/on_calls/1").to route_to("on_calls#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/on_calls/1").to route_to("on_calls#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/on_calls/1").to route_to("on_calls#destroy", :id => "1")
    end

  end
end
