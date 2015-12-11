require "rails_helper"

RSpec.describe ReimbursementTimesheetsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/reimbursement_timesheets").to route_to("reimbursement_timesheets#index")
    end

    it "routes to #new" do
      expect(:get => "/reimbursement_timesheets/new").to route_to("reimbursement_timesheets#new")
    end

    it "routes to #show" do
      expect(:get => "/reimbursement_timesheets/1").to route_to("reimbursement_timesheets#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/reimbursement_timesheets/1/edit").to route_to("reimbursement_timesheets#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/reimbursement_timesheets").to route_to("reimbursement_timesheets#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/reimbursement_timesheets/1").to route_to("reimbursement_timesheets#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/reimbursement_timesheets/1").to route_to("reimbursement_timesheets#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/reimbursement_timesheets/1").to route_to("reimbursement_timesheets#destroy", :id => "1")
    end

  end
end
