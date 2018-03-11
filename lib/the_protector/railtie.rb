require 'the_protector/middleware'

module TheProtector
  class Railtie < Rails::Railtie
    initializer 'the_protector.middleware' do |app|
       app.middleware.insert_after ActionDispatch::RequestId, TheProtector::Middleware
    end
  end
end
