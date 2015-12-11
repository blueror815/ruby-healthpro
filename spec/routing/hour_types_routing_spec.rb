require "rails_helper"

RSpec.describe HourTypesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/hour_types").to route_to("hour_types#index")
    end

    it "routes to #new" do
      expect(:get => "/hour_types/new").to route_to("hour_types#new")
    end

    it "routes to #show" do
      expect(:get => "/hour_types/1").to route_to("hour_types#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/hour_types/1/edit").to route_to("hour_types#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/hour_types").to route_to("hour_types#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/hour_types/1").to route_to("hour_types#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/hour_types/1").to route_to("hour_types#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/hour_types/1").to route_to("hour_types#destroy", :id => "1")
    end

  end
end
