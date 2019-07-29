ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'chewy/minitest/helpers'

class ActiveSupport::TestCase
  include FactoryBot::Syntax::Methods
  include Chewy::Minitest::Helpers

  @@action_methods = {
    index: :get,
    create: :post,
    show: :get,
    update: :patch,
    destroy: :delete,
  }

  @@action_operands = {
    index: :index,
    create: :index,
    show: :record,
    update: :record,
    destroy: :record,
  }

  def self.indexing(strategy)
    setup do
      Chewy.strategy strategy
    end
    teardown do
      Chewy.strategy.pop
    end
  end

  def self.assert_requires_auth(type, actions)
    actions.each do |action|
      test "should not #{action} #{type} without auth" do
        if @@action_operands[action] == :index
          url = self.send("#{type}_index_url")
        else
          object = create(type)
          url = self.send("#{type}_url", object)
        end

        self.send(@@action_methods[action], url, params: {type => attributes_for(type)}, as: :json)
        assert_response 403
      end
    end
  end
end
