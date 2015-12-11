require "rails_helper"

RSpec.describe CustomForms::FieldTypesController, type: :routing do
  routes { CustomForms::Engine.routes }
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/field_types").to route_to("custom_forms/field_types#index")
    end

    it "routes to #new" do
      expect(:get => "/field_types/new").to route_to("custom_forms/field_types#new")
    end

    it "routes to #show" do
      expect(:get => "/field_types/1").to route_to("custom_forms/field_types#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/field_types/1/edit").to route_to("custom_forms/field_types#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/field_types").to route_to("custom_forms/field_types#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/field_types/1").to route_to("custom_forms/field_types#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/field_types/1").to route_to("custom_forms/field_types#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/field_types/1").to route_to("custom_forms/field_types#destroy", :id => "1")
    end

  end
end
