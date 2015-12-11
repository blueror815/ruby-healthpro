require 'rails_helper'

RSpec.describe CoverageAreasController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/coverage_areas').to route_to('coverage_areas#index')
    end

    it 'routes to #new' do
      expect(get: '/coverage_areas/new').to route_to('coverage_areas#new')
    end

    it 'routes to #show' do
      expect(get: '/coverage_areas/1').to route_to('coverage_areas#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/coverage_areas/1/edit').to route_to('coverage_areas#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/coverage_areas').to route_to('coverage_areas#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/coverage_areas/1').to route_to('coverage_areas#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/coverage_areas/1').to route_to('coverage_areas#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/coverage_areas/1').to route_to('coverage_areas#destroy', id: '1')
    end
  end
end
