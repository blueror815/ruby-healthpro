require 'rails_helper'

RSpec.describe TimesheetsController, type: :routing do
  describe 'routing' do
    it 'routes to #show' do
      expect(get: '/timesheets/1').to route_to('timesheets#show', id: '1')
    end
  end
end
