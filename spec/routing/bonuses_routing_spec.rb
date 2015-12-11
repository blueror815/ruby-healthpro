require "rails_helper"

RSpec.describe BonusesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/bonuses").to route_to("bonuses#index")
    end

    it "routes to #new" do
      expect(:get => "/bonuses/new").to route_to("bonuses#new")
    end

    it "routes to #show" do
      expect(:get => "/bonuses/1").to route_to("bonuses#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/bonuses/1/edit").to route_to("bonuses#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/bonuses").to route_to("bonuses#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/bonuses/1").to route_to("bonuses#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/bonuses/1").to route_to("bonuses#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/bonuses/1").to route_to("bonuses#destroy", :id => "1")
    end

  end
end
