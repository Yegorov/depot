require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def login_as(user)
    post login_url, params: { name: user.name, password: 'secret' }
  end

  def logout
    delete logout_url
  end

  def setup
    if respond_to?(:session)
      login_as users(:one)
    end
  end
end
