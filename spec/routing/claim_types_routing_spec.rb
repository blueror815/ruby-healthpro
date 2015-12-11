require "rails_helper"

RSpec.describe ClaimTypesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/claim_types").to route_to("claim_types#index")
    end

    it "routes to #new" do
      expect(:get => "/claim_types/new").to route_to("claim_types#new")
    end

    it "routes to #show" do
      expect(:get => "/claim_types/1").to route_to("claim_types#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/claim_types/1/edit").to route_to("claim_types#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/claim_types").to route_to("claim_types#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/claim_types/1").to route_to("claim_types#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/claim_types/1").to route_to("claim_types#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/claim_types/1").to route_to("claim_types#destroy", :id => "1")
    end

  end
end
