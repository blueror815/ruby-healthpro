require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the RolesHelper. For example:
#
# describe RolesHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe CustomForms::ApplicationHelper, type: :helper do
  describe '#link_to_add_fields' do
    let(:form) { FormHelper::GroundedFormBuilder.new(:custom_form, resource, self, {}) }
    it 'should return anchor tag' do
      # expect(helper.link_to_add_fields("Add Section", f, "sections['1']", "section_fields", 'sections')).to eq()
    end
  end
end
