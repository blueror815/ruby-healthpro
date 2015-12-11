# require 'rubygems'
# require 'vcr'

VCR.configure do |_c|
  # c.cassette_library_dir = Rails.root.join('spec', 'vcr')
  # c.hook_into :fakeweb # or :fakeweb
end
