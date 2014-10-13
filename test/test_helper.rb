ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require 'factory_girl'
include ActionDispatch::TestProcess

FactoryGirl.find_definitions

class ActiveSupport::TestCase
  include FactoryGirl::Syntax::Methods
end

require 'vcr'

VCR.configure do |c|
  c.hook_into :webmock

  c.cassette_library_dir = 'test/vcr'
end